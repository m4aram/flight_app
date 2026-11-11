import 'package:equatable/equatable.dart';

class HotelSearchCriteria extends Equatable {
  const HotelSearchCriteria({
    required this.city,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
  });

  static const int maxRooms = 8;
  static const int maxGuestsPerRoom = 4;

  final String? city;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int guests;
  final int rooms;

  @override
  List<Object?> get props => [city, checkIn, checkOut, guests, rooms];
}
