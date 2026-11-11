import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/airport.dart';
import '../repositories/flight_repository.dart';

class GetAirports implements UseCase<List<Airport>, String> {
  const GetAirports(this._repository);

  static const int maxQueryLength = 60;

  final FlightRepository _repository;

  /// [params] is the search text (city, airport name or code).
  @override
  Future<Result<List<Airport>>> call(String params) {
    var query = params.trim();
    if (query.length > maxQueryLength) {
      query = query.substring(0, maxQueryLength);
    }
    return _repository.getAirports(query: query);
  }
}
