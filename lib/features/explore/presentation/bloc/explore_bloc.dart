import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/destination.dart';
import '../../domain/usecases/get_destinations.dart';

// ---------------- Events ----------------

sealed class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

final class ExploreStarted extends ExploreEvent {
  const ExploreStarted();
}

final class ExploreQueryChanged extends ExploreEvent {
  const ExploreQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

// ---------------- State ----------------

enum ExploreStatus { initial, loading, loaded, failure }

final class ExploreState extends Equatable {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.query = '',
    this.destinations = const [],
    this.errorMessage,
  });

  final ExploreStatus status;
  final String query;
  final List<Destination> destinations;
  final String? errorMessage;

  ExploreState copyWith({
    ExploreStatus? status,
    String? query,
    List<Destination>? destinations,
    String? errorMessage,
  }) {
    return ExploreState(
      status: status ?? this.status,
      query: query ?? this.query,
      destinations: destinations ?? this.destinations,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, destinations, errorMessage];
}

// ---------------- Bloc ----------------

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc(this._getDestinations) : super(const ExploreState()) {
    on<ExploreStarted>((event, emit) => _load(emit, state.query));
    on<ExploreQueryChanged>((event, emit) => _load(emit, event.query));
  }

  final GetDestinations _getDestinations;

  Future<void> _load(Emitter<ExploreState> emit, String query) async {
    emit(state.copyWith(status: ExploreStatus.loading, query: query));
    final result = await _getDestinations(query);

    // A newer query arrived while this one was loading.
    if (state.query != query) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExploreStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (destinations) => emit(
        state.copyWith(
          status: ExploreStatus.loaded,
          destinations: destinations,
        ),
      ),
    );
  }
}
