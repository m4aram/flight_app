import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../entities/hotel_search_criteria.dart';

abstract interface class HotelRepository {
  Future<Result<List<String>>> getCities();

  Future<Result<List<Hotel>>> searchHotels(HotelSearchCriteria criteria);
}
