import '../../domain/entities/flight.dart';

class FlightModel extends Flight {
  const FlightModel({
    required super.id,
    required super.airline,
    required super.fromCode,
    required super.toCode,
    required super.departureTime,
    required super.durationMinutes,
    required super.price,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] as String,
      airline: json['airline'] as String,
      fromCode: json['from'] as String,
      toCode: json['to'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'airline': airline,
    'from': fromCode,
    'to': toCode,
    'departure_time': departureTime.toIso8601String(),
    'duration_minutes': durationMinutes,
    'price': price,
  };
}
