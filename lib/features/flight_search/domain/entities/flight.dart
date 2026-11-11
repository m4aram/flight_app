import 'package:equatable/equatable.dart';

class Flight extends Equatable {
  const Flight({
    required this.id,
    required this.airline,
    required this.fromCode,
    required this.toCode,
    required this.departureTime,
    required this.durationMinutes,
    required this.price,
  });

  final String id;
  final String airline;
  final String fromCode;
  final String toCode;
  final DateTime departureTime;
  final int durationMinutes;
  final double price;

  @override
  List<Object?> get props => [
    id,
    airline,
    fromCode,
    toCode,
    departureTime,
    durationMinutes,
    price,
  ];
}
