import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_repository.dart';

class GetPaymentMethods implements UseCase<List<PaymentMethod>, NoParams> {
  const GetPaymentMethods(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Result<List<PaymentMethod>>> call(NoParams params) =>
      _repository.getPaymentMethods();
}

class GetPreferredPaymentMethod implements UseCase<String?, NoParams> {
  const GetPreferredPaymentMethod(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Result<String?>> call(NoParams params) =>
      _repository.getPreferredMethodId();
}

class SavePreferredPaymentMethod implements UseCase<void, String> {
  const SavePreferredPaymentMethod(this._repository);

  final PaymentRepository _repository;

  /// [params] is the payment method id.
  @override
  Future<Result<void>> call(String params) =>
      _repository.savePreferredMethodId(params);
}
