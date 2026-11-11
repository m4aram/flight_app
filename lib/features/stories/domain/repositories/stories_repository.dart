import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/hotel.dart';

abstract interface class StoriesRepository {
  Future<Result<List<Hotel>>> getStories();

  Future<Result<Set<String>>> getBookmarkIds();

  /// Adds or removes [hotelId] and returns the updated set.
  Future<Result<Set<String>>> toggleBookmark(String hotelId);
}
