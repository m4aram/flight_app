import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];

  // Never print the password.
  @override
  String toString() => 'RegisterParams(name: $name, email: $email)';
}

class Register implements UseCase<User, RegisterParams> {
  const Register(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<User>> call(RegisterParams params) async {
    final error =
        Validators.name(params.name, field: 'Name') ??
        Validators.email(params.email) ??
        Validators.password(params.password);
    if (error != null) return Failed(ValidationFailure(error));

    return _repository.register(
      name: params.name.trim(),
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }
}
