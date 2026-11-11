import 'package:equatable/equatable.dart';

class Airport extends Equatable {
  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });

  /// IATA code, e.g. `SAH`.
  final String code;
  final String name;
  final String city;
  final String country;

  /// `Sanaa (SAH)` as shown in the design.
  String get displayName => '$city ($code)';

  @override
  List<Object?> get props => [code, name, city, country];
}
