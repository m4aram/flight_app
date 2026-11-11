import 'package:equatable/equatable.dart';

enum PassengerType { adult, child, infant }

/// Number of travellers with the airline rules built in:
/// * at least 1 adult
/// * max 9 seats (adults + children)
/// * infants sit on an adult's lap, so infants <= adults
class PassengerCount extends Equatable {
  const PassengerCount({this.adults = 1, this.children = 0, this.infants = 0})
    : assert(adults >= 1),
      assert(children >= 0),
      assert(infants >= 0);

  static const int maxSeats = 9;

  final int adults;
  final int children;
  final int infants;

  int get seats => adults + children;
  int get total => seats + infants;

  bool get isValid =>
      adults >= 1 && seats <= maxSeats && infants <= adults && children >= 0;

  bool canIncrement(PassengerType type) => switch (type) {
    PassengerType.adult || PassengerType.child => seats < maxSeats,
    PassengerType.infant => infants < adults,
  };

  bool canDecrement(PassengerType type) => switch (type) {
    // Removing an adult must keep at least one and enough laps for infants.
    PassengerType.adult => adults > 1 && infants <= adults - 1,
    PassengerType.child => children > 0,
    PassengerType.infant => infants > 0,
  };

  PassengerCount increment(PassengerType type) {
    if (!canIncrement(type)) return this;
    return switch (type) {
      PassengerType.adult => copyWith(adults: adults + 1),
      PassengerType.child => copyWith(children: children + 1),
      PassengerType.infant => copyWith(infants: infants + 1),
    };
  }

  PassengerCount decrement(PassengerType type) {
    if (!canDecrement(type)) return this;
    return switch (type) {
      PassengerType.adult => copyWith(adults: adults - 1),
      PassengerType.child => copyWith(children: children - 1),
      PassengerType.infant => copyWith(infants: infants - 1),
    };
  }

  int countOf(PassengerType type) => switch (type) {
    PassengerType.adult => adults,
    PassengerType.child => children,
    PassengerType.infant => infants,
  };

  /// `1 Adult, 2 Children`
  String get label {
    final parts = <String>[
      '$adults ${adults == 1 ? 'Adult' : 'Adults'}',
      if (children > 0) '$children ${children == 1 ? 'Child' : 'Children'}',
      if (infants > 0) '$infants ${infants == 1 ? 'Infant' : 'Infants'}',
    ];
    return parts.join(', ');
  }

  PassengerCount copyWith({int? adults, int? children, int? infants}) {
    return PassengerCount(
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
    );
  }

  @override
  List<Object?> get props => [adults, children, infants];
}
