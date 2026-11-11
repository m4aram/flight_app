import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/destination.dart';
import '../entities/getaway_idea.dart';

abstract interface class ExploreRepository {
  Future<Result<List<Destination>>> getDestinations({String query = ''});

  Future<Result<List<GetawayIdea>>> getGetawayIdeas(GetawayType type);
}
