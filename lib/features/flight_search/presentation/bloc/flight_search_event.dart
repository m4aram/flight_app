part of 'flight_search_bloc.dart';

sealed class FlightSearchEvent extends Equatable {
  const FlightSearchEvent();

  @override
  List<Object?> get props => [];
}

final class FlightSearchStarted extends FlightSearchEvent {
  const FlightSearchStarted({
    this.tripType = TripType.roundTrip,
    this.destinationCode,
  });

  final TripType tripType;

  /// Optional IATA code to pre-fill the destination (e.g. from Explore).
  final String? destinationCode;

  @override
  List<Object?> get props => [tripType, destinationCode];
}

final class TripTypeChanged extends FlightSearchEvent {
  const TripTypeChanged(this.tripType);

  final TripType tripType;

  @override
  List<Object?> get props => [tripType];
}

final class DepartureAirportSelected extends FlightSearchEvent {
  const DepartureAirportSelected(this.airport);

  final Airport airport;

  @override
  List<Object?> get props => [airport];
}

final class DestinationAirportSelected extends FlightSearchEvent {
  const DestinationAirportSelected(this.airport);

  final Airport airport;

  @override
  List<Object?> get props => [airport];
}

final class DepartureDateSelected extends FlightSearchEvent {
  const DepartureDateSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class ReturnDateSelected extends FlightSearchEvent {
  const ReturnDateSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class PassengersChanged extends FlightSearchEvent {
  const PassengersChanged(this.passengers);

  final PassengerCount passengers;

  @override
  List<Object?> get props => [passengers];
}

final class CabinClassChanged extends FlightSearchEvent {
  const CabinClassChanged(this.cabinClass);

  final CabinClass cabinClass;

  @override
  List<Object?> get props => [cabinClass];
}

final class PaymentTypeChanged extends FlightSearchEvent {
  const PaymentTypeChanged(this.paymentType);

  final String paymentType;

  @override
  List<Object?> get props => [paymentType];
}

final class LegFromSelected extends FlightSearchEvent {
  const LegFromSelected(this.index, this.airport);

  final int index;
  final Airport airport;

  @override
  List<Object?> get props => [index, airport];
}

final class LegToSelected extends FlightSearchEvent {
  const LegToSelected(this.index, this.airport);

  final int index;
  final Airport airport;

  @override
  List<Object?> get props => [index, airport];
}

final class LegDateSelected extends FlightSearchEvent {
  const LegDateSelected(this.index, this.date);

  final int index;
  final DateTime date;

  @override
  List<Object?> get props => [index, date];
}

final class LegAdded extends FlightSearchEvent {
  const LegAdded();
}

final class LegRemoved extends FlightSearchEvent {
  const LegRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class FlightSearchSubmitted extends FlightSearchEvent {
  const FlightSearchSubmitted();
}
