import 'package:equatable/equatable.dart';

import 'cabin_class.dart';
import 'flight_leg.dart';
import 'passenger_count.dart';
import 'trip_type.dart';

class FlightSearchCriteria extends Equatable {
  const FlightSearchCriteria({
    required this.tripType,
    required this.legs,
    required this.passengers,
    required this.cabinClass,
    this.returnDate,
    this.paymentType,
  });

  final TripType tripType;

  /// One-way / round-trip: exactly one leg. Multi-city: 2 or more.
  final List<FlightLeg> legs;
  final DateTime? returnDate;
  final PassengerCount passengers;
  final CabinClass cabinClass;
  final String? paymentType;

  @override
  List<Object?> get props => [
    tripType,
    legs,
    returnDate,
    passengers,
    cabinClass,
    paymentType,
  ];
}
