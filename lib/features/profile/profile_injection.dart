import 'package:get_it/get_it.dart';

import 'data/datasources/profile_local_data_source.dart';
import 'data/datasources/travel_document_local_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/travel_document_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/repositories/travel_document_repository.dart';
import 'domain/usecases/profile_usecases.dart';
import 'domain/usecases/travel_document_usecases.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/travel_document_bloc.dart';

void initProfileFeature(GetIt sl) {
  sl
    ..registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetProfile(sl()))
    ..registerLazySingleton(() => SaveProfile(sl()))
    ..registerFactory(() => ProfileBloc(getProfile: sl(), saveProfile: sl()))
    ..registerLazySingleton<TravelDocumentLocalDataSource>(
      () => TravelDocumentLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<TravelDocumentRepository>(
      () => TravelDocumentRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetTravelDocument(sl()))
    ..registerLazySingleton(() => SaveTravelDocument(sl()))
    ..registerFactory(
      () => TravelDocumentBloc(getDocument: sl(), saveDocument: sl()),
    );
}
