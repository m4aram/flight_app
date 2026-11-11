import 'package:equatable/equatable.dart';

class Hotel extends Equatable {
  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.imagePath,
    required this.stars,
    required this.reviewScore,
    required this.reviewsCount,
    required this.pricePerNight,
  });

  final String id;
  final String name;
  final String city;
  final String imagePath;
  final int stars;
  final double reviewScore;
  final int reviewsCount;
  final double pricePerNight;

  String get reviewLabel {
    if (reviewScore >= 9) return 'Exceptional';
    if (reviewScore >= 8) return 'Excellent';
    if (reviewScore >= 7) return 'Very good';
    return 'Good';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    city,
    imagePath,
    stars,
    reviewScore,
    reviewsCount,
    pricePerNight,
  ];
}
