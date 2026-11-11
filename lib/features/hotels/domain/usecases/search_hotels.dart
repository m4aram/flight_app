import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../entities/hotel_search_criteria.dart';
import '../repositories/hotel_repository.dart';

class SearchHotels implements UseCase<List<Hotel>, HotelSearchCriteria> {
  const SearchHotels(this._repository);

  final HotelRepository _repository;

  @override
  Future<Result<List<Hotel>>> call(HotelSearchCriteria params) async {
    final error = validate(params);
    if (error != null) return Failed(ValidationFailure(error));
    return _repository.searchHotels(params);
  }

  static String? validate(HotelSearchCriteria c) {
    if (c.city == null || c.city!.trim().isEmpty) {
      return 'Please choose a location';
    }
    if (c.checkIn == null) return 'Please select a check-in date';
    if (c.checkOut == null) return 'Please select a check-out date';
    if (!c.checkOut!.isAfter(c.checkIn!)) {
      return 'Check-out must be after check-in';
    }
    if (c.rooms < 1 || c.rooms > HotelSearchCriteria.maxRooms) {
      return 'Invalid number of rooms';
    }
    if (c.guests < c.rooms) return 'Each room needs at least one guest';
    if (c.guests > c.rooms * HotelSearchCriteria.maxGuestsPerRoom) {
      return 'Too many guests for ${c.rooms} room(s)';
    }
    return null;
  }
}
