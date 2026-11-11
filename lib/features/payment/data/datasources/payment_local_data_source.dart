import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/key_value_storage.dart';
import '../../domain/entities/payment_method.dart';

abstract interface class PaymentLocalDataSource {
  Future<List<PaymentMethod>> getPaymentMethods();

  String? getPreferredMethodId();

  Future<void> savePreferredMethodId(String id);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  const PaymentLocalDataSourceImpl(this._storage);

  final KeyValueStorage _storage;

  static const List<PaymentMethod> _methods = [
    PaymentMethod(id: 'visa', name: 'Visa Credit'),
    PaymentMethod(id: 'paypal', name: 'PayPal'),
    PaymentMethod(id: 'mastercard', name: 'MasterCard Credit'),
    PaymentMethod(id: 'jcb', name: 'JCB'),
    PaymentMethod(id: 'amex', name: 'American Express'),
    PaymentMethod(id: 'apple_pay', name: 'Apple Pay'),
    PaymentMethod(id: 'google_pay', name: 'Google Pay'),
    PaymentMethod(id: 'discover', name: 'Discover'),
    PaymentMethod(id: 'unionpay', name: 'UnionPay'),
  ];

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async => _methods;

  @override
  String? getPreferredMethodId() =>
      _storage.getString(StorageKeys.preferredPaymentId);

  @override
  Future<void> savePreferredMethodId(String id) =>
      _storage.setString(StorageKeys.preferredPaymentId, id);
}
