import 'package:get_it/get_it.dart';

import 'data/datasources/flight_remote_data_source.dart';
import 'data/repositories/flight_repository_impl.dart';
import 'domain/repositories/flight_repository.dart';
import 'domain/usecases/get_airports.dart';
import 'domain/usecases/search_flights.dart';
import 'presentation/bloc/airport_picker_bloc.dart';
import 'presentation/bloc/flight_search_bloc.dart';

void initFlightSearchFeature(GetIt sl) {
  sl
    ..registerLazySingleton<FlightRemoteDataSource>(
      () => const FakeFlightRemoteDataSource(),
    )
    ..registerLazySingleton<FlightRepository>(() => FlightRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetAirports(sl()))
    ..registerLazySingleton(() => SearchFlights(sl()))
    ..registerFactory(
      () => FlightSearchBloc(searchFlights: sl(), getAirports: sl()),
    )
    ..registerFactory(() => AirportPickerBloc(sl()));
}
