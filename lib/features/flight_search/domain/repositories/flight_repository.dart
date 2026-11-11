import '../../../../core/utils/result.dart';
import '../entities/airport.dart';
import '../entities/flight.dart';
import '../entities/flight_search_criteria.dart';

abstract interface class FlightRepository {
  Future<Result<List<Airport>>> getAirports({String query = ''});

  Future<Result<List<Flight>>> searchFlights(FlightSearchCriteria criteria);
}
