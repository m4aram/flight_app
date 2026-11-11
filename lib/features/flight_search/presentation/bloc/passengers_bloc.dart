import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/passenger_count.dart';

sealed class PassengersEvent extends Equatable {
  const PassengersEvent(this.type);

  final PassengerType type;

  @override
  List<Object?> get props => [runtimeType, type];
}

final class PassengerIncremented extends PassengersEvent {
  const PassengerIncremented(super.type);
}

final class PassengerDecremented extends PassengersEvent {
  const PassengerDecremented(super.type);
}

/// The state is the [PassengerCount] itself; all rules live in the entity.
class PassengersBloc extends Bloc<PassengersEvent, PassengerCount> {
  PassengersBloc(super.initial) {
    on<PassengerIncremented>(
      (event, emit) => emit(state.increment(event.type)),
    );
    on<PassengerDecremented>(
      (event, emit) => emit(state.decrement(event.type)),
    );
  }
}
