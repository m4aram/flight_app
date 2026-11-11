import 'package:equatable/equatable.dart';

/// A failure is what the domain/presentation layers receive when
/// something goes wrong.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [runtimeType, message];
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error, please try again.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not access local storage.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
