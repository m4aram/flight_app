import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/hotel.dart';

enum ExploreItemType { popularDestinations, visaFreeCountries }

class ExploreItem extends Equatable {
  const ExploreItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final ExploreItemType type;
  final String title;
  final String subtitle;
  final String imagePath;

  @override
  List<Object?> get props => [type, title, subtitle, imagePath];
}

class HomeContent extends Equatable {
  const HomeContent({
    required this.exploreItems,
    required this.hotelsCity,
    required this.hotels,
  });

  final List<ExploreItem> exploreItems;
  final String hotelsCity;
  final List<Hotel> hotels;

  @override
  List<Object?> get props => [exploreItems, hotelsCity, hotels];
}
