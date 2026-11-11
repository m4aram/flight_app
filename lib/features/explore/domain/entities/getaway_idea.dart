import 'package:equatable/equatable.dart';

enum GetawayType {
  timeLines('Time Lines', 'Best time of year to visit'),
  suggestedItinerary('Suggested Itinerary', 'Ready-made trip plans'),
  publicHoliday('Public Holiday', 'Plan around the holidays');

  const GetawayType(this.label, this.description);

  final String label;
  final String description;

  static GetawayType? fromName(String? name) {
    for (final type in values) {
      if (type.name == name) return type;
    }
    return null;
  }
}

class GetawayIdea extends Equatable {
  const GetawayIdea({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.destinationCode,
  });

  final String id;
  final GetawayType type;
  final String title;
  final String subtitle;

  /// Airport code used to open Flight Search, when the idea has a destination.
  final String? destinationCode;

  @override
  List<Object?> get props => [id, type, title, subtitle, destinationCode];
}
