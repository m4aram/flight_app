part of 'flight_search_bloc.dart';

enum FlightSearchStatus { initial, loading, success, failure }

final class FlightSearchState extends Equatable {
  const FlightSearchState({
    this.tripType = TripType.roundTrip,
    this.departure,
    this.destination,
    this.departureDate,
    this.returnDate,
    this.legs = const [FlightLeg(), FlightLeg(), FlightLeg()],
    this.passengers = const PassengerCount(),
    this.cabinClass = CabinClass.economy,
    this.paymentType = 'Visa',
    this.status = FlightSearchStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  static const int minLegs = 2;
  static const int maxLegs = 5;

  final TripType tripType;

  // One-way / round-trip fields
  final Airport? departure;
  final Airport? destination;
  final DateTime? departureDate;
  final DateTime? returnDate;

  // Multi-city legs
  final List<FlightLeg> legs;

  // Shared fields
  final PassengerCount passengers;
  final CabinClass cabinClass;
  final String paymentType;

  final FlightSearchStatus status;
  final List<Flight> results;
  final String? errorMessage;

  bool get canAddLeg => legs.length < maxLegs;
  bool get canRemoveLeg => legs.length > minLegs;

  FlightSearchCriteria toCriteria() {
    final isMultiCity = tripType == TripType.multiCity;
    return FlightSearchCriteria(
      tripType: tripType,
      legs:
          isMultiCity
              ? legs
              : [
                FlightLeg(
                  from: departure,
                  to: destination,
                  date: departureDate,
                ),
              ],
      returnDate: tripType == TripType.roundTrip ? returnDate : null,
      passengers: passengers,
      cabinClass: cabinClass,
      paymentType: paymentType,
    );
  }

  FlightSearchState copyWith({
    TripType? tripType,
    Airport? Function()? departure,
    Airport? Function()? destination,
    DateTime? Function()? departureDate,
    DateTime? Function()? returnDate,
    List<FlightLeg>? legs,
    PassengerCount? passengers,
    CabinClass? cabinClass,
    String? paymentType,
    FlightSearchStatus? status,
    List<Flight>? results,
    String? errorMessage,
  }) {
    return FlightSearchState(
      tripType: tripType ?? this.tripType,
      departure: departure != null ? departure() : this.departure,
      destination: destination != null ? destination() : this.destination,
      departureDate:
          departureDate != null ? departureDate() : this.departureDate,
      returnDate: returnDate != null ? returnDate() : this.returnDate,
      legs: legs ?? this.legs,
      passengers: passengers ?? this.passengers,
      cabinClass: cabinClass ?? this.cabinClass,
      paymentType: paymentType ?? this.paymentType,
      // Any edit resets the request status back to idle.
      status: status ?? FlightSearchStatus.initial,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    tripType,
    departure,
    destination,
    departureDate,
    returnDate,
    legs,
    passengers,
    cabinClass,
    paymentType,
    status,
    results,
    errorMessage,
  ];
}
