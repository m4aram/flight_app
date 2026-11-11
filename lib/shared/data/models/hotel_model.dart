import '../../domain/entities/hotel.dart';

class HotelModel extends Hotel {
  const HotelModel({
    required super.id,
    required super.name,
    required super.city,
    required super.imagePath,
    required super.stars,
    required super.reviewScore,
    required super.reviewsCount,
    required super.pricePerNight,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      imagePath: json['image'] as String,
      stars: (json['stars'] as num).toInt(),
      reviewScore: (json['review_score'] as num).toDouble(),
      reviewsCount: (json['reviews_count'] as num).toInt(),
      pricePerNight: (json['price_per_night'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'image': imagePath,
    'stars': stars,
    'review_score': reviewScore,
    'reviews_count': reviewsCount,
    'price_per_night': pricePerNight,
  };
}
