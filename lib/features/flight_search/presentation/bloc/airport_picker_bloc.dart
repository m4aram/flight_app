import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/airport.dart';
import '../../domain/usecases/get_airports.dart';

// ---------------- Events ----------------

sealed class AirportPickerEvent extends Equatable {
  const AirportPickerEvent();

  @override
  List<Object?> get props => [];
}

final class AirportQueryChanged extends AirportPickerEvent {
  const AirportQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

// ---------------- State ----------------

enum AirportPickerStatus { initial, loading, loaded, failure }

final class AirportPickerState extends Equatable {
  const AirportPickerState({
    this.query = '',
    this.airports = const [],
    this.status = AirportPickerStatus.initial,
    this.errorMessage,
  });

  final String query;
  final List<Airport> airports;
  final AirportPickerStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [query, airports, status, errorMessage];
}

// ---------------- Bloc ----------------

class AirportPickerBloc extends Bloc<AirportPickerEvent, AirportPickerState> {
  AirportPickerBloc(this._getAirports) : super(const AirportPickerState()) {
    on<AirportQueryChanged>(_onQueryChanged);
  }

  final GetAirports _getAirports;

  Future<void> _onQueryChanged(
    AirportQueryChanged event,
    Emitter<AirportPickerState> emit,
  ) async {
    emit(
      AirportPickerState(
        query: event.query,
        airports: state.airports,
        status: AirportPickerStatus.loading,
      ),
    );

    final result = await _getAirports(event.query);

    // Ignore stale responses when the user kept typing.
    if (state.query != event.query) return;

    result.fold(
      (failure) => emit(
        AirportPickerState(
          query: event.query,
          status: AirportPickerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (airports) => emit(
        AirportPickerState(
          query: event.query,
          airports: airports,
          status: AirportPickerStatus.loaded,
        ),
      ),
    );
  }
}
