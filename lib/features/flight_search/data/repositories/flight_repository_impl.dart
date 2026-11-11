import '../../../../core/utils/result.dart';
import '../../domain/entities/airport.dart';
import '../../domain/entities/flight.dart';
import '../../domain/entities/flight_search_criteria.dart';
import '../../domain/entities/flight_leg.dart';
import '../../domain/entities/trip_type.dart';
import '../../domain/repositories/flight_repository.dart';
import '../datasources/flight_remote_data_source.dart';

class FlightRepositoryImpl implements FlightRepository {
  const FlightRepositoryImpl(this._remote);

  final FlightRemoteDataSource _remote;

  @override
  Future<Result<List<Airport>>> getAirports({String query = ''}) {
    return guard(() => _remote.getAirports(query: query));
  }

  @override
  Future<Result<List<Flight>>> searchFlights(FlightSearchCriteria criteria) {
    return guard(() async {
      final legs = [...criteria.legs];

      // A round trip is searched as two legs: outbound + return.
      if (criteria.tripType == TripType.roundTrip) {
        final outbound = criteria.legs.first;
        legs.add(
          FlightLeg(
            from: outbound.to,
            to: outbound.from,
            date: criteria.returnDate,
          ),
        );
      }

      final results = await Future.wait(
        legs.map(
          (leg) =>
              _remote.searchFlights(leg: leg, seats: criteria.passengers.seats),
        ),
      );
      return results.expand((flights) => flights).toList();
    });
  }
}
