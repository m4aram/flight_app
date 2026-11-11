enum TripType {
  oneWay,
  roundTrip,
  multiCity;

  static TripType fromName(String? name, {TripType fallback = roundTrip}) {
    for (final type in values) {
      if (type.name == name) return type;
    }
    return fallback;
  }
}
