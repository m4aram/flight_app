import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/data/datasources/catalog_local_data_source.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._catalog);

  static const String featuredCity = 'Istanbul';

  final CatalogLocalDataSource _catalog;

  @override
  Future<Result<HomeContent>> getHomeContent() {
    return guard(() async {
      final hotels = await _catalog.getHotels(city: featuredCity);
      return HomeContent(
        exploreItems: const [
          ExploreItem(
            type: ExploreItemType.popularDestinations,
            title: AppStrings.popularDestinations,
            subtitle: AppStrings.checkFares,
            imagePath: AppAssets.explorePopular,
          ),
          ExploreItem(
            type: ExploreItemType.visaFreeCountries,
            title: 'Visa free Countries',
            subtitle: 'Travel without a visa',
            imagePath: AppAssets.exploreVisaFree,
          ),
        ],
        hotelsCity: featuredCity,
        hotels: hotels,
      );
    });
  }
}
