import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/getaway_idea.dart';
import '../../domain/usecases/get_getaway_ideas.dart';

// ---------------- Events ----------------

sealed class GetawayEvent extends Equatable {
  const GetawayEvent();

  @override
  List<Object?> get props => [];
}

final class GetawayRequested extends GetawayEvent {
  const GetawayRequested(this.type);

  final GetawayType type;

  @override
  List<Object?> get props => [type];
}

// ---------------- State ----------------

enum GetawayStatus { initial, loading, loaded, failure }

final class GetawayState extends Equatable {
  const GetawayState({
    this.status = GetawayStatus.initial,
    this.ideas = const [],
    this.errorMessage,
  });

  final GetawayStatus status;
  final List<GetawayIdea> ideas;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, ideas, errorMessage];
}

// ---------------- Bloc ----------------

class GetawayBloc extends Bloc<GetawayEvent, GetawayState> {
  GetawayBloc(this._getIdeas) : super(const GetawayState()) {
    on<GetawayRequested>(_onRequested);
  }

  final GetGetawayIdeas _getIdeas;

  Future<void> _onRequested(
    GetawayRequested event,
    Emitter<GetawayState> emit,
  ) async {
    emit(const GetawayState(status: GetawayStatus.loading));
    final result = await _getIdeas(event.type);
    result.fold(
      (failure) => emit(
        GetawayState(
          status: GetawayStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (ideas) => emit(GetawayState(status: GetawayStatus.loaded, ideas: ideas)),
    );
  }
}
