import 'package:get_it/get_it.dart';

import 'data/datasources/getaway_local_data_source.dart';
import 'data/repositories/explore_repository_impl.dart';
import 'domain/repositories/explore_repository.dart';
import 'domain/usecases/get_destinations.dart';
import 'domain/usecases/get_getaway_ideas.dart';
import 'presentation/bloc/explore_bloc.dart';
import 'presentation/bloc/getaway_bloc.dart';

void initExploreFeature(GetIt sl) {
  sl
    ..registerLazySingleton<GetawayLocalDataSource>(
      () => const GetawayLocalDataSourceImpl(),
    )
    ..registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImpl(catalog: sl(), getaways: sl()),
    )
    ..registerLazySingleton(() => GetDestinations(sl()))
    ..registerLazySingleton(() => GetGetawayIdeas(sl()))
    ..registerFactory(() => ExploreBloc(sl()))
    ..registerFactory(() => GetawayBloc(sl()));
}
