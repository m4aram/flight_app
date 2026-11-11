import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/hotel_repository.dart';

class GetHotelCities implements UseCase<List<String>, NoParams> {
  const GetHotelCities(this._repository);

  final HotelRepository _repository;

  @override
  Future<Result<List<String>>> call(NoParams params) => _repository.getCities();
}
