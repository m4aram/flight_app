import 'package:flight_app/features/flight_search/domain/entities/airport.dart';
import 'package:flight_app/features/flight_search/domain/entities/cabin_class.dart';
import 'package:flight_app/features/flight_search/domain/entities/flight_leg.dart';
import 'package:flight_app/features/flight_search/domain/entities/flight_search_criteria.dart';
import 'package:flight_app/features/flight_search/domain/entities/passenger_count.dart';
import 'package:flight_app/features/flight_search/domain/entities/trip_type.dart';
import 'package:flight_app/features/flight_search/domain/usecases/search_flights.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------- Test data (Arrange helpers) ----------

const sanaa = Airport(
  code: 'SAH',
  name: 'Sanaa International Airport',
  city: 'Sanaa',
  country: 'Yemen',
);

const amman = Airport(
  code: 'AMM',
  name: 'Queen Alia International Airport',
  city: 'Amman',
  country: 'Jordan',
);

final departureDay = DateTime(2026, 12, 1);
final returnDay = DateTime(2026, 12, 10);

/// Builds a round-trip search. Each test passes exactly what it wants to check.
FlightSearchCriteria roundTrip({
  required Airport? from,
  required Airport? to,
  required DateTime? date,
  required DateTime? returnDate,
}) {
  return FlightSearchCriteria(
    tripType: TripType.roundTrip,
    legs: [FlightLeg(from: from, to: to, date: date)],
    returnDate: returnDate,
    passengers: const PassengerCount(),
    cabinClass: CabinClass.economy,
  );
}

void main() {
  group('SearchFlights.validate', () {
    test('returns null when everything is filled correctly', () {
      // Arrange
      final criteria = roundTrip(
        from: sanaa,
        to: amman,
        date: departureDay,
        returnDate: returnDay,
      );

      // Act
      final result = SearchFlights.validate(criteria);

      // Assert: null means "no error"
      expect(result, isNull);
    });

    test('returns an error when departure and destination are the same', () {
      final criteria = roundTrip(
        from: sanaa,
        to: sanaa,
        date: departureDay,
        returnDate: returnDay,
      );

      final result = SearchFlights.validate(criteria);

      expect(result, 'Departure and destination must be different');
    });

    test('returns an error when departure is missing', () {
      final criteria = roundTrip(
        from: null,
        to: sanaa,
        date: departureDay,
        returnDate: returnDay,
      );

      final result = SearchFlights.validate(criteria);

      expect(result, 'Please choose a departure');
    });

    test('returns an error when return is before departure', () {
      final criteria = roundTrip(
        from: sanaa,
          to: amman,
          date: returnDay,
          returnDate: departureDay
      );

      final result = SearchFlights.validate(criteria);

      expect(result, 'Return date must be after the departure date');
    });

    test('returns an error when  not select a return date', () {
      final criteria = roundTrip(
          from: sanaa,
          to: amman,
          date: returnDay,
          returnDate: null,      );

      final result = SearchFlights.validate(criteria);

      expect(result, 'Please select a return date');
    });

    test('allows departure and return on the same day', () {
      final criteria = roundTrip(
        from: sanaa,
        to: amman,
        date: departureDay,
        returnDate: departureDay,
      );

      final result = SearchFlights.validate(criteria);

      expect(result, isNull);
    });






  });
}