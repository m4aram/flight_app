import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/logout.dart';

// ---------------- Events ----------------

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Restores the saved session on app start.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Sent by the login screen after a successful login.
final class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// ---------------- State ----------------

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState._({required this.status, this.user});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final User? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user];
}

// ---------------- Bloc ----------------

/// App-wide authentication state, provided above the router.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required GetCurrentUser getCurrentUser, required Logout logout})
    : _getCurrentUser = getCurrentUser,
      _logout = logout,
      super(const AuthState.unknown()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoggedIn>(
      (event, emit) => emit(AuthState.authenticated(event.user)),
    );
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final GetCurrentUser _getCurrentUser;
  final Logout _logout;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUser(const NoParams());
    emit(
      result.fold(
        (_) => const AuthState.unauthenticated(),
        (user) =>
            user == null
                ? const AuthState.unauthenticated()
                : AuthState.authenticated(user),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    // Even if clearing storage failed, the UI must not stay logged in.
    emit(const AuthState.unauthenticated());
  }
}
