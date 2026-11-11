import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';

class SendPasswordReset implements UseCase<void, String> {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  /// [params] is the account email.
  @override
  Future<Result<void>> call(String params) async {
    final error = Validators.email(params);
    if (error != null) return Failed(ValidationFailure(error));
    return _repository.sendPasswordReset(email: params.trim().toLowerCase());
  }
}
