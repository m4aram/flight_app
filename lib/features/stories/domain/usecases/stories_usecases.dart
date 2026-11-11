import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../repositories/stories_repository.dart';

class GetStories implements UseCase<List<Hotel>, NoParams> {
  const GetStories(this._repository);

  final StoriesRepository _repository;

  @override
  Future<Result<List<Hotel>>> call(NoParams params) => _repository.getStories();
}

class GetBookmarks implements UseCase<Set<String>, NoParams> {
  const GetBookmarks(this._repository);

  final StoriesRepository _repository;

  @override
  Future<Result<Set<String>>> call(NoParams params) =>
      _repository.getBookmarkIds();
}

class ToggleBookmark implements UseCase<Set<String>, String> {
  const ToggleBookmark(this._repository);

  final StoriesRepository _repository;

  /// [params] is the hotel id.
  @override
  Future<Result<Set<String>>> call(String params) =>
      _repository.toggleBookmark(params);
}
