import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/usecases/send_password_reset.dart';

// ---------------- Events ----------------

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  const ForgotPasswordEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted();
}

// ---------------- State ----------------

enum ForgotPasswordStatus { initial, submitting, sent, failure }

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.showErrors = false,
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  final String email;
  final bool showErrors;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  String? get emailError => showErrors ? Validators.email(email) : null;

  ForgotPasswordState copyWith({
    String? email,
    bool? showErrors,
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      showErrors: showErrors ?? this.showErrors,
      status: status ?? ForgotPasswordStatus.initial,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, showErrors, status, errorMessage];
}

// ---------------- Bloc ----------------

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._sendPasswordReset)
    : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(
      (e, emit) => emit(state.copyWith(email: e.email)),
    );
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final SendPasswordReset _sendPasswordReset;

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.status == ForgotPasswordStatus.submitting) return;

    if (Validators.email(state.email) != null) {
      emit(state.copyWith(showErrors: true));
      return;
    }

    emit(
      state.copyWith(showErrors: true, status: ForgotPasswordStatus.submitting),
    );
    final result = await _sendPasswordReset(state.email);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ForgotPasswordStatus.sent)),
    );
  }
}
