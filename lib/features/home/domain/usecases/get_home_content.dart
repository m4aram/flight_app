import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/home_content.dart';
import '../repositories/home_repository.dart';

class GetHomeContent implements UseCase<HomeContent, NoParams> {
  const GetHomeContent(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<HomeContent>> call(NoParams params) =>
      _repository.getHomeContent();
}
