import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/flight.dart';
import '../entities/flight_search_criteria.dart';
import '../entities/trip_type.dart';
import '../repositories/flight_repository.dart';

/// Validates the search form and then asks the repository for flights.
class SearchFlights implements UseCase<List<Flight>, FlightSearchCriteria> {
  const SearchFlights(this._repository);

  final FlightRepository _repository;

  @override
  Future<Result<List<Flight>>> call(FlightSearchCriteria params) async {
    final error = validate(params);
    if (error != null) return Failed(ValidationFailure(error));
    return _repository.searchFlights(params);
  }

  /// Returns an error message, or `null` when the criteria is valid.
  static String? validate(FlightSearchCriteria c) {
    if (c.legs.isEmpty) return 'Please add your flight details';

    if (c.tripType == TripType.multiCity && c.legs.length < 2) {
      return 'Multi-city trips need at least 2 flights';
    }

    for (final (index, leg) in c.legs.indexed) {
      final prefix =
          c.tripType == TripType.multiCity ? 'Flight ${index + 1}: ' : '';
      if (leg.from == null) return '${prefix}Please choose a departure';
      if (leg.to == null) return '${prefix}Please choose a destination';
      if (leg.from == leg.to) {
        return '${prefix}Departure and destination must be different';
      }
      if (leg.date == null) return '${prefix}Please select a date';
      if (index > 0) {
        final previous = c.legs[index - 1].date;
        if (previous != null && leg.date!.isBefore(previous)) {
          return '${prefix}Date must be after the previous flight';
        }
      }
    }

    if (c.tripType == TripType.roundTrip) {
      if (c.returnDate == null) return 'Please select a return date';
      if (c.returnDate!.isBefore(c.legs.first.date!)) {
        return 'Return date must be after the departure date';
      }
    }

    if (!c.passengers.isValid) return 'Invalid number of passengers';

    return null;
  }
}
