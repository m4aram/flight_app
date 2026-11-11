import 'package:get_it/get_it.dart';

import 'data/repositories/hotel_repository_impl.dart';
import 'domain/repositories/hotel_repository.dart';
import 'domain/usecases/get_hotel_cities.dart';
import 'domain/usecases/search_hotels.dart';
import 'presentation/bloc/hotel_search_bloc.dart';

void initHotelsFeature(GetIt sl) {
  sl
    ..registerLazySingleton<HotelRepository>(() => HotelRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetHotelCities(sl()))
    ..registerLazySingleton(() => SearchHotels(sl()))
    ..registerFactory(
      () => HotelSearchBloc(getHotelCities: sl(), searchHotels: sl()),
    );
}
