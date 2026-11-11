import '../../domain/entities/flight_leg.dart';
import '../models/airport_model.dart';
import '../models/flight_model.dart';

/// Contract for the flights API.
abstract interface class FlightRemoteDataSource {
  Future<List<AirportModel>> getAirports({String query = ''});

  Future<List<FlightModel>> searchFlights({
    required FlightLeg leg,
    required int seats,
  });
}

/// Mock implementation until a real backend is available.
/// Replace it with an HTTP implementation and update the DI binding.
class FakeFlightRemoteDataSource implements FlightRemoteDataSource {
  const FakeFlightRemoteDataSource({
    this.latency = const Duration(milliseconds: 600),
  });

  final Duration latency;

  static const List<String> _airlines = [
    'Yemenia',
    'Royal Jordanian',
    'Turkish Airlines',
    'Oman Air',
    'Emirates',
  ];

  @override
  Future<List<AirportModel>> getAirports({String query = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final airports = _airports.map(AirportModel.fromJson);
    final q = query.toLowerCase();
    if (q.isEmpty) return airports.toList();

    return airports
        .where(
          (a) =>
              a.code.toLowerCase().contains(q) ||
              a.city.toLowerCase().contains(q) ||
              a.name.toLowerCase().contains(q) ||
              a.country.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<List<FlightModel>> searchFlights({
    required FlightLeg leg,
    required int seats,
  }) async {
    await Future<void>.delayed(latency);
    final from = leg.from!.code;
    final to = leg.to!.code;
    final date = leg.date!;
    final seed = (from + to).codeUnits.fold<int>(0, (a, b) => a + b);
    final count = 3 + seed % 4;

    return List.generate(count, (i) {
      final airline = _airlines[(seed + i) % _airlines.length];
      return FlightModel(
        id: '$from-$to-${date.millisecondsSinceEpoch}-$i',
        airline: airline,
        fromCode: from,
        toCode: to,
        departureTime: DateTime(date.year, date.month, date.day, 6 + i * 3),
        durationMinutes: 90 + (seed % 5) * 30 + i * 15,
        price: (180 + (seed % 7) * 25 + i * 40).toDouble(),
      );
    });
  }

  static const List<Map<String, dynamic>> _airports = [
    {
      'code': 'SAH',
      'name': 'Sanaa International Airport',
      'city': 'Sanaa',
      'country': 'Yemen',
    },
    {
      'code': 'ADE',
      'name': 'Aden International Airport',
      'city': 'Aden',
      'country': 'Yemen',
    },
    {
      'code': 'AMM',
      'name': 'Queen Alia International Airport',
      'city': 'Amman',
      'country': 'Jordan',
    },
    {
      'code': 'CAI',
      'name': 'Cairo International Airport',
      'city': 'Cairo',
      'country': 'Egypt',
    },
    {
      'code': 'DXB',
      'name': 'Dubai International Airport',
      'city': 'Dubai',
      'country': 'United Arab Emirates',
    },
    {
      'code': 'IST',
      'name': 'Istanbul Airport',
      'city': 'Istanbul',
      'country': 'Turkey',
    },
    {
      'code': 'JFK',
      'name': 'John F. Kennedy International Airport',
      'city': 'New York',
      'country': 'United States',
    },
    {
      'code': 'MCT',
      'name': 'Muscat International Airport',
      'city': 'Muscat',
      'country': 'Oman',
    },
    {
      'code': 'RUH',
      'name': 'King Khalid International Airport',
      'city': 'Riyadh',
      'country': 'Saudi Arabia',
    },
    {
      'code': 'JED',
      'name': 'King Abdulaziz International Airport',
      'city': 'Jeddah',
      'country': 'Saudi Arabia',
    },
    {
      'code': 'DOH',
      'name': 'Hamad International Airport',
      'city': 'Doha',
      'country': 'Qatar',
    },
    {
      'code': 'LHR',
      'name': 'Heathrow Airport',
      'city': 'London',
      'country': 'United Kingdom',
    },
  ];
}
