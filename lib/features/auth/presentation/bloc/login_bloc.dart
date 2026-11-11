import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';

// ---------------- Events ----------------

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];

  // Never print the password (e.g. in BlocObserver logs).
  @override
  String toString() => 'LoginPasswordChanged(***)';
}

final class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

// ---------------- State ----------------

enum LoginStatus { initial, submitting, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.showErrors = false,
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;

  /// Field errors are only shown after the first submit attempt.
  final bool showErrors;
  final LoginStatus status;
  final User? user;
  final String? errorMessage;

  String? get emailError => showErrors ? Validators.email(email) : null;
  String? get passwordError =>
      showErrors ? Validators.password(password) : null;

  bool get isFormValid =>
      Validators.email(email) == null && Validators.password(password) == null;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? showErrors,
    LoginStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      showErrors: showErrors ?? this.showErrors,
      status: status ?? LoginStatus.initial,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    obscurePassword,
    showErrors,
    status,
    user,
    errorMessage,
  ];

  // Never print the password (e.g. in BlocObserver logs).
  @override
  String toString() =>
      'LoginState(email: $email, status: $status, showErrors: $showErrors)';
}

// ---------------- Bloc ----------------

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._login) : super(const LoginState()) {
    on<LoginEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<LoginPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<LoginPasswordVisibilityToggled>(
      (event, emit) =>
          emit(state.copyWith(obscurePassword: !state.obscurePassword)),
    );
    on<LoginSubmitted>(_onSubmitted);
  }

  final Login _login;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == LoginStatus.submitting) return;

    if (!state.isFormValid) {
      emit(state.copyWith(showErrors: true));
      return;
    }

    emit(state.copyWith(showErrors: true, status: LoginStatus.submitting));
    final result = await _login(
      LoginParams(email: state.email, password: state.password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        // Clear the password from memory once it is no longer needed.
        state.copyWith(password: '', status: LoginStatus.success, user: user),
      ),
    );
  }
}
