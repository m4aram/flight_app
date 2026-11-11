import 'package:get_it/get_it.dart';

import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_home_content.dart';
import 'presentation/bloc/home_bloc.dart';

void initHomeFeature(GetIt sl) {
  sl
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetHomeContent(sl()))
    ..registerFactory(() => HomeBloc(sl()));
}
