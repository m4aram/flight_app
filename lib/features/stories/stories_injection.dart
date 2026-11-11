import 'package:get_it/get_it.dart';

import 'data/datasources/bookmarks_local_data_source.dart';
import 'data/repositories/stories_repository_impl.dart';
import 'domain/repositories/stories_repository.dart';
import 'domain/usecases/stories_usecases.dart';
import 'presentation/bloc/stories_bloc.dart';

void initStoriesFeature(GetIt sl) {
  sl
    ..registerLazySingleton<BookmarksLocalDataSource>(
      () => BookmarksLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<StoriesRepository>(
      () => StoriesRepositoryImpl(catalog: sl(), bookmarks: sl()),
    )
    ..registerLazySingleton(() => GetStories(sl()))
    ..registerLazySingleton(() => GetBookmarks(sl()))
    ..registerLazySingleton(() => ToggleBookmark(sl()))
    ..registerFactory(
      () => StoriesBloc(
        getStories: sl(),
        getBookmarks: sl(),
        toggleBookmark: sl(),
      ),
    );
}
