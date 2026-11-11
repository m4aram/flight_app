import 'package:equatable/equatable.dart';

class Destination extends Equatable {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.airportCode,
    required this.imagePath,
  });

  final String id;
  final String name;
  final String country;
  final String airportCode;
  final String imagePath;

  @override
  List<Object?> get props => [id, name, country, airportCode, imagePath];
}
