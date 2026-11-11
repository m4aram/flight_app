import '../../domain/entities/airport.dart';

class AirportModel extends Airport {
  const AirportModel({
    required super.code,
    required super.name,
    required super.city,
    required super.country,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      code: json['code'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'city': city,
    'country': country,
  };
}
