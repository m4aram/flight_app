import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];

  // Never print the password.
  @override
  String toString() => 'LoginParams(email: $email)';
}

class Login implements UseCase<User, LoginParams> {
  const Login(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(LoginParams params) async {
    final error =
        Validators.email(params.email) ?? Validators.password(params.password);
    if (error != null) return Failed(ValidationFailure(error));

    return _repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }
}
