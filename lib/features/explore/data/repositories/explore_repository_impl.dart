import '../../../../core/utils/result.dart';
import '../../../../shared/data/datasources/catalog_local_data_source.dart';
import '../../../../shared/domain/entities/destination.dart';
import '../../domain/entities/getaway_idea.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/getaway_local_data_source.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  const ExploreRepositoryImpl({
    required CatalogLocalDataSource catalog,
    required GetawayLocalDataSource getaways,
  }) : _catalog = catalog,
       _getaways = getaways;

  final CatalogLocalDataSource _catalog;
  final GetawayLocalDataSource _getaways;

  @override
  Future<Result<List<Destination>>> getDestinations({String query = ''}) {
    return guard(() => _catalog.getDestinations(query: query));
  }

  @override
  Future<Result<List<GetawayIdea>>> getGetawayIdeas(GetawayType type) {
    return guard(() => _getaways.getIdeas(type));
  }
}
