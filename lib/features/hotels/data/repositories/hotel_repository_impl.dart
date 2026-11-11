import '../../../../core/utils/result.dart';
import '../../../../shared/data/datasources/catalog_local_data_source.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../domain/entities/hotel_search_criteria.dart';
import '../../domain/repositories/hotel_repository.dart';

class HotelRepositoryImpl implements HotelRepository {
  const HotelRepositoryImpl(this._catalog);

  final CatalogLocalDataSource _catalog;

  @override
  Future<Result<List<String>>> getCities() => guard(_catalog.getHotelCities);

  @override
  Future<Result<List<Hotel>>> searchHotels(HotelSearchCriteria criteria) {
    return guard(() => _catalog.getHotels(city: criteria.city));
  }
}
