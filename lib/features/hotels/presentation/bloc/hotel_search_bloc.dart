import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../domain/entities/hotel_search_criteria.dart';
import '../../domain/usecases/get_hotel_cities.dart';
import '../../domain/usecases/search_hotels.dart';

part 'hotel_search_event.dart';
part 'hotel_search_state.dart';

class HotelSearchBloc extends Bloc<HotelSearchEvent, HotelSearchState> {
  HotelSearchBloc({
    required GetHotelCities getHotelCities,
    required SearchHotels searchHotels,
  }) : _getHotelCities = getHotelCities,
       _searchHotels = searchHotels,
       super(HotelSearchState.initial()) {
    on<HotelSearchStarted>(_onStarted);
    on<HotelTonightSelected>(_onTonightSelected);
    on<HotelCitySelected>(_onCitySelected);
    on<HotelCheckInSelected>(_onCheckInSelected);
    on<HotelCheckOutSelected>(_onCheckOutSelected);
    on<HotelGuestsRoomsChanged>(_onGuestsRoomsChanged);
    on<HotelSearchSubmitted>(_onSubmitted);
  }

  final GetHotelCities _getHotelCities;
  final SearchHotels _searchHotels;

  Future<void> _onStarted(
    HotelSearchStarted event,
    Emitter<HotelSearchState> emit,
  ) async {
    final initialCity = event.city?.trim();
    if (initialCity != null && initialCity.isNotEmpty) {
      emit(state.copyWith(city: () => initialCity));
    }

    final result = await _getHotelCities(const NoParams());
    result.fold((_) {}, (cities) => emit(state.copyWith(cities: cities)));
  }

  void _onTonightSelected(
    HotelTonightSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    final today = DateFormatter.today();
    emit(
      state.copyWith(
        checkIn: () => today,
        checkOut: () => today.add(const Duration(days: 1)),
      ),
    );
  }

  void _onCitySelected(
    HotelCitySelected event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(city: () => event.city));
  }

  void _onCheckInSelected(
    HotelCheckInSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    final checkIn = DateFormatter.dateOnly(event.date);
    final checkOut = state.checkOut;
    // Keep check-out at least one night after check-in.
    final fixedCheckOut =
        checkOut == null || !checkOut.isAfter(checkIn)
            ? checkIn.add(const Duration(days: 1))
            : checkOut;
    emit(state.copyWith(checkIn: () => checkIn, checkOut: () => fixedCheckOut));
  }

  void _onCheckOutSelected(
    HotelCheckOutSelected event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(checkOut: () => DateFormatter.dateOnly(event.date)));
  }

  void _onGuestsRoomsChanged(
    HotelGuestsRoomsChanged event,
    Emitter<HotelSearchState> emit,
  ) {
    emit(state.copyWith(guests: event.guests, rooms: event.rooms));
  }

  Future<void> _onSubmitted(
    HotelSearchSubmitted event,
    Emitter<HotelSearchState> emit,
  ) async {
    if (state.status == HotelSearchStatus.loading) return;

    emit(state.copyWith(status: HotelSearchStatus.loading));
    final result = await _searchHotels(state.toCriteria());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HotelSearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (hotels) => emit(
        state.copyWith(status: HotelSearchStatus.success, results: hotels),
      ),
    );
  }
}
