import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../domain/usecases/stories_usecases.dart';

// ---------------- Events ----------------

sealed class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object?> get props => [];
}

final class StoriesStarted extends StoriesEvent {
  const StoriesStarted();
}

final class StoriesSearchChanged extends StoriesEvent {
  const StoriesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class StoryBookmarkToggled extends StoriesEvent {
  const StoryBookmarkToggled(this.hotelId);

  final String hotelId;

  @override
  List<Object?> get props => [hotelId];
}

// ---------------- State ----------------

enum StoriesStatus { initial, loading, loaded, failure }

final class StoriesState extends Equatable {
  const StoriesState({
    this.status = StoriesStatus.initial,
    this.stories = const [],
    this.bookmarkIds = const {},
    this.query = '',
    this.errorMessage,
  });

  final StoriesStatus status;
  final List<Hotel> stories;
  final Set<String> bookmarkIds;
  final String query;
  final String? errorMessage;

  List<Hotel> get filteredStories {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return stories;
    return stories
        .where(
          (h) =>
              h.name.toLowerCase().contains(q) ||
              h.city.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Hotel> get bookmarkedStories =>
      filteredStories.where((h) => bookmarkIds.contains(h.id)).toList();

  StoriesState copyWith({
    StoriesStatus? status,
    List<Hotel>? stories,
    Set<String>? bookmarkIds,
    String? query,
    String? errorMessage,
  }) {
    return StoriesState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      bookmarkIds: bookmarkIds ?? this.bookmarkIds,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    stories,
    bookmarkIds,
    query,
    errorMessage,
  ];
}

// ---------------- Bloc ----------------

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc({
    required GetStories getStories,
    required GetBookmarks getBookmarks,
    required ToggleBookmark toggleBookmark,
  }) : _getStories = getStories,
       _getBookmarks = getBookmarks,
       _toggleBookmark = toggleBookmark,
       super(const StoriesState()) {
    on<StoriesStarted>(_onStarted);
    on<StoriesSearchChanged>(
      (event, emit) => emit(state.copyWith(query: event.query)),
    );
    on<StoryBookmarkToggled>(_onBookmarkToggled);
  }

  final GetStories _getStories;
  final GetBookmarks _getBookmarks;
  final ToggleBookmark _toggleBookmark;

  Future<void> _onStarted(
    StoriesStarted event,
    Emitter<StoriesState> emit,
  ) async {
    emit(state.copyWith(status: StoriesStatus.loading));
    final storiesResult = await _getStories(const NoParams());
    final bookmarksResult = await _getBookmarks(const NoParams());
    final bookmarks = bookmarksResult.fold((_) => <String>{}, (ids) => ids);

    storiesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: StoriesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (stories) => emit(
        state.copyWith(
          status: StoriesStatus.loaded,
          stories: stories,
          bookmarkIds: bookmarks,
        ),
      ),
    );
  }

  Future<void> _onBookmarkToggled(
    StoryBookmarkToggled event,
    Emitter<StoriesState> emit,
  ) async {
    final result = await _toggleBookmark(event.hotelId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (ids) => emit(state.copyWith(bookmarkIds: Set.unmodifiable(ids))),
    );
  }
}
