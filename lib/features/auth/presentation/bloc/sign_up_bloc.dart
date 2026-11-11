import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/register.dart';

// ---------------- Events ----------------

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

final class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];

  @override
  String toString() => 'SignUpPasswordChanged(***)';
}

final class SignUpConfirmChanged extends SignUpEvent {
  const SignUpConfirmChanged(this.confirm);

  final String confirm;

  @override
  List<Object?> get props => [confirm];

  @override
  String toString() => 'SignUpConfirmChanged(***)';
}

final class SignUpPasswordVisibilityToggled extends SignUpEvent {
  const SignUpPasswordVisibilityToggled();
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

// ---------------- State ----------------

enum SignUpStatus { initial, submitting, success, failure }

final class SignUpState extends Equatable {
  const SignUpState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirm = '',
    this.obscurePassword = true,
    this.showErrors = false,
    this.status = SignUpStatus.initial,
    this.user,
    this.errorMessage,
  });

  final String name;
  final String email;
  final String password;
  final String confirm;
  final bool obscurePassword;
  final bool showErrors;
  final SignUpStatus status;
  final User? user;
  final String? errorMessage;

  String? get nameError =>
      showErrors ? Validators.name(name, field: 'Name') : null;
  String? get emailError => showErrors ? Validators.email(email) : null;
  String? get passwordError =>
      showErrors ? Validators.password(password) : null;
  String? get confirmError =>
      showErrors ? Validators.confirmPassword(confirm, password) : null;

  bool get isFormValid =>
      Validators.name(name, field: 'Name') == null &&
      Validators.email(email) == null &&
      Validators.password(password) == null &&
      Validators.confirmPassword(confirm, password) == null;

  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirm,
    bool? obscurePassword,
    bool? showErrors,
    SignUpStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirm: confirm ?? this.confirm,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      showErrors: showErrors ?? this.showErrors,
      status: status ?? SignUpStatus.initial,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirm,
    obscurePassword,
    showErrors,
    status,
    user,
    errorMessage,
  ];

  @override
  String toString() => 'SignUpState(email: $email, status: $status)';
}

// ---------------- Bloc ----------------

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(this._register) : super(const SignUpState()) {
    on<SignUpNameChanged>((e, emit) => emit(state.copyWith(name: e.name)));
    on<SignUpEmailChanged>((e, emit) => emit(state.copyWith(email: e.email)));
    on<SignUpPasswordChanged>(
      (e, emit) => emit(state.copyWith(password: e.password)),
    );
    on<SignUpConfirmChanged>(
      (e, emit) => emit(state.copyWith(confirm: e.confirm)),
    );
    on<SignUpPasswordVisibilityToggled>(
      (e, emit) =>
          emit(state.copyWith(obscurePassword: !state.obscurePassword)),
    );
    on<SignUpSubmitted>(_onSubmitted);
  }

  final Register _register;

  Future<void> _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.status == SignUpStatus.submitting) return;

    if (!state.isFormValid) {
      emit(state.copyWith(showErrors: true));
      return;
    }

    emit(state.copyWith(showErrors: true, status: SignUpStatus.submitting));
    final result = await _register(
      RegisterParams(
        name: state.name,
        email: state.email,
        password: state.password,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          password: '',
          confirm: '',
          status: SignUpStatus.success,
          user: user,
        ),
      ),
    );
  }
}
