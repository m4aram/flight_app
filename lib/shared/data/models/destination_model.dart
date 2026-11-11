import '../../domain/entities/destination.dart';

class DestinationModel extends Destination {
  const DestinationModel({
    required super.id,
    required super.name,
    required super.country,
    required super.airportCode,
    required super.imagePath,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      airportCode: json['airport_code'] as String,
      imagePath: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'airport_code': airportCode,
    'image': imagePath,
  };
}
