import 'package:equatable/equatable.dart';

import 'airport.dart';

/// One segment of a trip: from -> to on a date.
class FlightLeg extends Equatable {
  const FlightLeg({this.from, this.to, this.date});

  final Airport? from;
  final Airport? to;
  final DateTime? date;

  bool get isComplete => from != null && to != null && date != null;

  FlightLeg copyWith({
    Airport? Function()? from,
    Airport? Function()? to,
    DateTime? Function()? date,
  }) {
    return FlightLeg(
      from: from != null ? from() : this.from,
      to: to != null ? to() : this.to,
      date: date != null ? date() : this.date,
    );
  }

  @override
  List<Object?> get props => [from, to, date];
}
