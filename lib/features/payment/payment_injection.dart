import 'package:get_it/get_it.dart';

import 'data/datasources/payment_local_data_source.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/repositories/payment_repository.dart';
import 'domain/usecases/payment_usecases.dart';
import 'presentation/bloc/payment_methods_bloc.dart';

void initPaymentFeature(GetIt sl) {
  sl
    ..registerLazySingleton<PaymentLocalDataSource>(
      () => PaymentLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetPaymentMethods(sl()))
    ..registerLazySingleton(() => GetPreferredPaymentMethod(sl()))
    ..registerLazySingleton(() => SavePreferredPaymentMethod(sl()))
    ..registerFactory(
      () => PaymentMethodsBloc(
        getPaymentMethods: sl(),
        getPreferred: sl(),
        savePreferred: sl(),
      ),
    );
}
