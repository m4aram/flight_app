import '../../../core/constants/app_assets.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';

/// Source of hotels and destinations shared by several features.
///
/// It currently serves mock JSON. To connect a real API, add a remote
/// data source with the same methods and switch the binding in DI.
abstract interface class CatalogLocalDataSource {
  Future<List<HotelModel>> getHotels({String? city});

  Future<List<DestinationModel>> getDestinations({String query = ''});

  Future<List<String>> getHotelCities();
}

class CatalogLocalDataSourceImpl implements CatalogLocalDataSource {
  const CatalogLocalDataSourceImpl({
    this.latency = const Duration(milliseconds: 300),
  });

  final Duration latency;

  @override
  Future<List<HotelModel>> getHotels({String? city}) async {
    await Future<void>.delayed(latency);
    final hotels = _hotels.map(HotelModel.fromJson);
    if (city == null || city.trim().isEmpty) return hotels.toList();

    final normalized = city.trim().toLowerCase();
    return hotels.where((h) => h.city.toLowerCase() == normalized).toList();
  }

  @override
  Future<List<DestinationModel>> getDestinations({String query = ''}) async {
    await Future<void>.delayed(latency);
    final destinations = _destinations.map(DestinationModel.fromJson);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return destinations.toList();

    return destinations
        .where(
          (d) =>
              d.name.toLowerCase().contains(q) ||
              d.country.toLowerCase().contains(q) ||
              d.airportCode.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<List<String>> getHotelCities() async {
    await Future<void>.delayed(latency);
    return _cities;
  }

  static const List<String> _cities = [
    'Istanbul',
    'Cancún',
    'Cappadocia',
    'Kalkan',
    'Amman',
    'Muscat',
    'Dubai',
    'Cairo',
    'New York',
  ];

  static const List<Map<String, dynamic>> _hotels = [
    {
      'id': 'regal_airport',
      'name': 'Regal airport hotel',
      'city': 'Istanbul',
      'image': AppAssets.hotelRegalAirport,
      'stars': 4,
      'review_score': 8.6,
      'reviews_count': 1240,
      'price_per_night': 95,
    },
    {
      'id': 'bosphorus_house',
      'name': 'Bosphorus house hotel',
      'city': 'Istanbul',
      'image': AppAssets.hotelBosphorusHouse,
      'stars': 4,
      'review_score': 9.1,
      'reviews_count': 860,
      'price_per_night': 120,
    },
    {
      'id': 'san_cora_cancun',
      'name': 'San Cora Cancún',
      'city': 'Cancún',
      'image': AppAssets.hotelSanCoraCancun,
      'stars': 5,
      'review_score': 8.8,
      'reviews_count': 540,
      'price_per_night': 180,
    },
    {
      'id': 'babson_cave',
      'name': 'Babson Cave Hotel',
      'city': 'Cappadocia',
      'image': AppAssets.hotelBabsonCave,
      'stars': 4,
      'review_score': 9.3,
      'reviews_count': 410,
      'price_per_night': 140,
    },
    {
      'id': 'grand_kim',
      'name': 'Hotel Grand Kim',
      'city': 'Istanbul',
      'image': AppAssets.hotelGrandKim,
      'stars': 3,
      'review_score': 7.9,
      'reviews_count': 320,
      'price_per_night': 70,
    },
    {
      'id': 'happy_kalkan',
      'name': 'Happy Hotel Kalkan',
      'city': 'Kalkan',
      'image': AppAssets.hotelHappyKalkan,
      'stars': 3,
      'review_score': 8.2,
      'reviews_count': 290,
      'price_per_night': 85,
    },
  ];

  static const List<Map<String, dynamic>> _destinations = [
    {
      'id': 'new_york',
      'name': 'New York City',
      'country': 'United States',
      'airport_code': 'JFK',
      'image': AppAssets.destNewYork,
    },
    {
      'id': 'amman',
      'name': 'Amman',
      'country': 'Jordan',
      'airport_code': 'AMM',
      'image': AppAssets.destAmman,
    },
    {
      'id': 'muscat',
      'name': 'Muscat',
      'country': 'Oman',
      'airport_code': 'MCT',
      'image': AppAssets.destMuscat,
    },
    {
      'id': 'istanbul',
      'name': 'Istanbul',
      'country': 'Turkey',
      'airport_code': 'IST',
      'image': AppAssets.destIstanbul,
    },
    {
      'id': 'dubai',
      'name': 'Dubai',
      'country': 'United Arab Emirates',
      'airport_code': 'DXB',
      'image': AppAssets.destDubai,
    },
    {
      'id': 'cairo',
      'name': 'Cairo',
      'country': 'Egypt',
      'airport_code': 'CAI',
      'image': AppAssets.destCairo,
    },
  ];
}
