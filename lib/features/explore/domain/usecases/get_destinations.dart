import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/destination.dart';
import '../repositories/explore_repository.dart';

/// [params] is the search text; an empty string returns popular destinations.
class GetDestinations implements UseCase<List<Destination>, String> {
  const GetDestinations(this._repository);

  static const int maxQueryLength = 60;

  final ExploreRepository _repository;

  @override
  Future<Result<List<Destination>>> call(String params) {
    var query = params.trim();
    if (query.length > maxQueryLength) {
      query = query.substring(0, maxQueryLength);
    }
    return _repository.getDestinations(query: query);
  }
}
