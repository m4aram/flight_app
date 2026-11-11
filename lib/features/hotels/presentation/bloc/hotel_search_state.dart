part of 'hotel_search_bloc.dart';

enum HotelSearchStatus { initial, loading, success, failure }

final class HotelSearchState extends Equatable {
  const HotelSearchState({
    this.cities = const [],
    this.city,
    this.checkIn,
    this.checkOut,
    this.guests = 2,
    this.rooms = 1,
    this.status = HotelSearchStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  /// Defaults: check-in tomorrow, check-out two nights later.
  factory HotelSearchState.initial() {
    final tomorrow = DateFormatter.today().add(const Duration(days: 1));
    return HotelSearchState(
      checkIn: tomorrow,
      checkOut: tomorrow.add(const Duration(days: 2)),
    );
  }

  final List<String> cities;
  final String? city;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;
  final int rooms;
  final HotelSearchStatus status;
  final List<Hotel> results;
  final String? errorMessage;

  /// `2 Guests in 1 Room`
  String get guestsLabel =>
      '$guests ${guests == 1 ? 'Guest' : 'Guests'} in '
      '$rooms ${rooms == 1 ? 'Room' : 'Rooms'}';

  HotelSearchCriteria toCriteria() => HotelSearchCriteria(
    city: city,
    checkIn: checkIn,
    checkOut: checkOut,
    guests: guests,
    rooms: rooms,
  );

  HotelSearchState copyWith({
    List<String>? cities,
    String? Function()? city,
    DateTime? Function()? checkIn,
    DateTime? Function()? checkOut,
    int? guests,
    int? rooms,
    HotelSearchStatus? status,
    List<Hotel>? results,
    String? errorMessage,
  }) {
    return HotelSearchState(
      cities: cities ?? this.cities,
      city: city != null ? city() : this.city,
      checkIn: checkIn != null ? checkIn() : this.checkIn,
      checkOut: checkOut != null ? checkOut() : this.checkOut,
      guests: guests ?? this.guests,
      rooms: rooms ?? this.rooms,
      status: status ?? HotelSearchStatus.initial,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    cities,
    city,
    checkIn,
    checkOut,
    guests,
    rooms,
    status,
    results,
    errorMessage,
  ];
}
