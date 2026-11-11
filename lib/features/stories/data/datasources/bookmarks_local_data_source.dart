import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/key_value_storage.dart';

abstract interface class BookmarksLocalDataSource {
  Set<String> getBookmarkIds();

  Future<void> saveBookmarkIds(Set<String> ids);
}

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  const BookmarksLocalDataSourceImpl(this._storage);

  final KeyValueStorage _storage;

  @override
  Set<String> getBookmarkIds() =>
      (_storage.getStringList(StorageKeys.bookmarks) ?? const []).toSet();

  @override
  Future<void> saveBookmarkIds(Set<String> ids) =>
      _storage.setStringList(StorageKeys.bookmarks, ids.toList());
}
