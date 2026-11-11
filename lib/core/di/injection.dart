import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/account/account_injection.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/explore/explore_injection.dart';
import '../../features/flight_search/flight_search_injection.dart';
import '../../features/home/home_injection.dart';
import '../../features/hotels/hotels_injection.dart';
import '../../features/payment/payment_injection.dart';
import '../../features/profile/profile_injection.dart';
import '../../features/stories/stories_injection.dart';
import '../../shared/data/datasources/catalog_local_data_source.dart';
import '../storage/key_value_storage.dart';
import '../storage/secure_storage.dart';

/// Service locator.
final GetIt sl = GetIt.instance;

/// Registers all dependencies. Call once before `runApp`.
///
/// Rules:
/// * data sources, repositories, use cases -> lazy singletons
/// * blocs -> factories (a fresh instance per screen)
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerLazySingleton<KeyValueStorage>(() => SharedPrefsStorage(prefs))
    ..registerLazySingleton<SecureStorage>(
      () => const SecureStorageImpl(FlutterSecureStorage()),
    )
    ..registerLazySingleton<CatalogLocalDataSource>(
      () => const CatalogLocalDataSourceImpl(),
    );

  initAuthFeature(sl);
  initAccountFeature(sl);
  initHomeFeature(sl);
  initExploreFeature(sl);
  initFlightSearchFeature(sl);
  initHotelsFeature(sl);
  initPaymentFeature(sl);
  initProfileFeature(sl);
  initStoriesFeature(sl);
}
