import 'package:get_it/get_it.dart';

import 'data/datasources/settings_local_data_source.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/settings_usecases.dart';
import 'presentation/bloc/settings_bloc.dart';

void initAccountFeature(GetIt sl) {
  sl
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetSettings(sl()))
    ..registerLazySingleton(() => SaveSettings(sl()))
    ..registerFactory(
      () => SettingsBloc(getSettings: sl(), saveSettings: sl()),
    );
}
