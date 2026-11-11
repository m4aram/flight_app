import '../../../../core/utils/result.dart';
import '../entities/payment_method.dart';

abstract interface class PaymentRepository {
  Future<Result<List<PaymentMethod>>> getPaymentMethods();

  Future<Result<String?>> getPreferredMethodId();

  Future<Result<void>> savePreferredMethodId(String id);
}
