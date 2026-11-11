import '../../../../core/utils/result.dart';
import '../../../../shared/data/datasources/catalog_local_data_source.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../domain/repositories/stories_repository.dart';
import '../datasources/bookmarks_local_data_source.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  const StoriesRepositoryImpl({
    required CatalogLocalDataSource catalog,
    required BookmarksLocalDataSource bookmarks,
  }) : _catalog = catalog,
       _bookmarks = bookmarks;

  final CatalogLocalDataSource _catalog;
  final BookmarksLocalDataSource _bookmarks;

  @override
  Future<Result<List<Hotel>>> getStories() => guard(_catalog.getHotels);

  @override
  Future<Result<Set<String>>> getBookmarkIds() =>
      guard(() async => _bookmarks.getBookmarkIds());

  @override
  Future<Result<Set<String>>> toggleBookmark(String hotelId) {
    return guard(() async {
      final ids = _bookmarks.getBookmarkIds();
      if (!ids.remove(hotelId)) ids.add(hotelId);
      await _bookmarks.saveBookmarkIds(ids);
      return ids;
    });
  }
}
