import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/airport.dart';
import '../../domain/entities/cabin_class.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/flight_leg.dart';
import '../../domain/entities/flight_search_criteria.dart';
import '../../domain/entities/passenger_count.dart';
import '../../domain/entities/trip_type.dart';
import '../../domain/usecases/get_airports.dart';
import '../../domain/usecases/search_flights.dart';

part 'flight_search_event.dart';
part 'flight_search_state.dart';

class FlightSearchBloc extends Bloc<FlightSearchEvent, FlightSearchState> {
  FlightSearchBloc({
    required SearchFlights searchFlights,
    required GetAirports getAirports,
  }) : _searchFlights = searchFlights,
       _getAirports = getAirports,
       super(const FlightSearchState()) {
    on<FlightSearchStarted>(_onStarted);
    on<TripTypeChanged>(_onTripTypeChanged);
    on<DepartureAirportSelected>(_onDepartureSelected);
    on<DestinationAirportSelected>(_onDestinationSelected);
    on<DepartureDateSelected>(_onDepartureDateSelected);
    on<ReturnDateSelected>(_onReturnDateSelected);
    on<PassengersChanged>(_onPassengersChanged);
    on<CabinClassChanged>(_onCabinClassChanged);
    on<PaymentTypeChanged>(_onPaymentTypeChanged);
    on<LegFromSelected>(_onLegFromSelected);
    on<LegToSelected>(_onLegToSelected);
    on<LegDateSelected>(_onLegDateSelected);
    on<LegAdded>(_onLegAdded);
    on<LegRemoved>(_onLegRemoved);
    on<FlightSearchSubmitted>(_onSubmitted);
  }

  final SearchFlights _searchFlights;
  final GetAirports _getAirports;

  Future<void> _onStarted(
    FlightSearchStarted event,
    Emitter<FlightSearchState> emit,
  ) async {
    emit(state.copyWith(tripType: event.tripType));

    final code = event.destinationCode?.trim().toUpperCase();
    if (code == null || code.isEmpty) return;

    final result = await _getAirports(code);
    result.fold((_) {}, (airports) {
      for (final airport in airports) {
        if (airport.code == code) {
          emit(state.copyWith(destination: () => airport));
          return;
        }
      }
    });
  }

  void _onTripTypeChanged(
    TripTypeChanged event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(tripType: event.tripType));
  }

  void _onDepartureSelected(
    DepartureAirportSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(departure: () => event.airport));
  }

  void _onDestinationSelected(
    DestinationAirportSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(destination: () => event.airport));
  }

  void _onDepartureDateSelected(
    DepartureDateSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    final date = DateFormatter.dateOnly(event.date);
    final returnDate = state.returnDate;
    final keepReturn = returnDate != null && !returnDate.isBefore(date);
    emit(
      state.copyWith(
        departureDate: () => date,
        returnDate: () => keepReturn ? returnDate : null,
      ),
    );
  }

  void _onReturnDateSelected(
    ReturnDateSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(returnDate: () => DateFormatter.dateOnly(event.date)));
  }

  void _onPassengersChanged(
    PassengersChanged event,
    Emitter<FlightSearchState> emit,
  ) {
    if (!event.passengers.isValid) return;
    emit(state.copyWith(passengers: event.passengers));
  }

  void _onCabinClassChanged(
    CabinClassChanged event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(cabinClass: event.cabinClass));
  }

  void _onPaymentTypeChanged(
    PaymentTypeChanged event,
    Emitter<FlightSearchState> emit,
  ) {
    emit(state.copyWith(paymentType: event.paymentType));
  }

  void _onLegFromSelected(
    LegFromSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    _updateLeg(
      emit,
      event.index,
      (leg) => leg.copyWith(from: () => event.airport),
    );
  }

  void _onLegToSelected(LegToSelected event, Emitter<FlightSearchState> emit) {
    _updateLeg(
      emit,
      event.index,
      (leg) => leg.copyWith(to: () => event.airport),
    );
  }

  void _onLegDateSelected(
    LegDateSelected event,
    Emitter<FlightSearchState> emit,
  ) {
    final date = DateFormatter.dateOnly(event.date);
    _updateLeg(emit, event.index, (leg) => leg.copyWith(date: () => date));
  }

  void _updateLeg(
    Emitter<FlightSearchState> emit,
    int index,
    FlightLeg Function(FlightLeg leg) update,
  ) {
    if (index < 0 || index >= state.legs.length) return;
    final legs = [...state.legs];
    legs[index] = update(legs[index]);
    emit(state.copyWith(legs: legs));
  }

  void _onLegAdded(LegAdded event, Emitter<FlightSearchState> emit) {
    if (!state.canAddLeg) return;
    // The new flight starts where the previous one landed.
    final legs = [...state.legs, FlightLeg(from: state.legs.last.to)];
    emit(state.copyWith(legs: legs));
  }

  void _onLegRemoved(LegRemoved event, Emitter<FlightSearchState> emit) {
    if (!state.canRemoveLeg) return;
    if (event.index < 0 || event.index >= state.legs.length) return;
    final legs = [...state.legs]..removeAt(event.index);
    emit(state.copyWith(legs: legs));
  }

  Future<void> _onSubmitted(
    FlightSearchSubmitted event,
    Emitter<FlightSearchState> emit,
  ) async {
    if (state.status == FlightSearchStatus.loading) return;

    emit(state.copyWith(status: FlightSearchStatus.loading));
    final result = await _searchFlights(state.toCriteria());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FlightSearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (flights) => emit(
        state.copyWith(status: FlightSearchStatus.success, results: flights),
      ),
    );
  }
}
