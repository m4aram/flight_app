import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/getaway_idea.dart';
import '../repositories/explore_repository.dart';

class GetGetawayIdeas implements UseCase<List<GetawayIdea>, GetawayType> {
  const GetGetawayIdeas(this._repository);

  final ExploreRepository _repository;

  @override
  Future<Result<List<GetawayIdea>>> call(GetawayType params) =>
      _repository.getGetawayIdeas(params);
}
