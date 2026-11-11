import 'package:get_it/get_it.dart';

import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/send_password_reset.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/forgot_password_bloc.dart';
import 'presentation/bloc/login_bloc.dart';
import 'presentation/bloc/sign_up_bloc.dart';

void initAuthFeature(GetIt sl) {
  sl
    // Data
    ..registerLazySingleton<AuthRemoteDataSource>(FakeAuthRemoteDataSource.new)
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    )
    // Domain
    ..registerLazySingleton(() => Login(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => Register(sl()))
    ..registerLazySingleton(() => SendPasswordReset(sl()))
    // Presentation
    ..registerFactory(() => AuthBloc(getCurrentUser: sl(), logout: sl()))
    ..registerFactory(() => LoginBloc(sl()))
    ..registerFactory(() => SignUpBloc(sl()))
    ..registerFactory(() => ForgotPasswordBloc(sl()));
}
