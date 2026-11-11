import '../../../../core/utils/result.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this._local);

  final PaymentLocalDataSource _local;

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() =>
      guard(_local.getPaymentMethods);

  @override
  Future<Result<String?>> getPreferredMethodId() =>
      guard(() async => _local.getPreferredMethodId());

  @override
  Future<Result<void>> savePreferredMethodId(String id) =>
      guard(() => _local.savePreferredMethodId(id));
}
