import '../../domain/entities/getaway_idea.dart';

/// Mock travel inspiration. Replace with an API call when available.
abstract interface class GetawayLocalDataSource {
  Future<List<GetawayIdea>> getIdeas(GetawayType type);
}

class GetawayLocalDataSourceImpl implements GetawayLocalDataSource {
  const GetawayLocalDataSourceImpl({
    this.latency = const Duration(milliseconds: 250),
  });

  final Duration latency;

  @override
  Future<List<GetawayIdea>> getIdeas(GetawayType type) async {
    await Future<void>.delayed(latency);
    return _ideas.where((i) => i.type == type).toList();
  }

  static const List<GetawayIdea> _ideas = [
    // Time lines: best season per destination
    GetawayIdea(
      id: 'tl_istanbul',
      type: GetawayType.timeLines,
      title: 'Istanbul',
      subtitle: 'Apr - May and Sep - Nov: mild weather, fewer crowds',
      destinationCode: 'IST',
    ),
    GetawayIdea(
      id: 'tl_dubai',
      type: GetawayType.timeLines,
      title: 'Dubai',
      subtitle: 'Nov - Mar: warm days, cool evenings',
      destinationCode: 'DXB',
    ),
    GetawayIdea(
      id: 'tl_muscat',
      type: GetawayType.timeLines,
      title: 'Muscat',
      subtitle: 'Oct - Apr: perfect for beaches and the old town',
      destinationCode: 'MCT',
    ),
    GetawayIdea(
      id: 'tl_cairo',
      type: GetawayType.timeLines,
      title: 'Cairo',
      subtitle: 'Oct - Apr: comfortable for visiting the pyramids',
      destinationCode: 'CAI',
    ),
    GetawayIdea(
      id: 'tl_amman',
      type: GetawayType.timeLines,
      title: 'Amman',
      subtitle: 'Mar - May: spring, great for Petra day trips',
      destinationCode: 'AMM',
    ),

    // Suggested itineraries
    GetawayIdea(
      id: 'it_istanbul',
      type: GetawayType.suggestedItinerary,
      title: '3 days in Istanbul',
      subtitle: 'Sultanahmet, a Bosphorus cruise and the Grand Bazaar',
      destinationCode: 'IST',
    ),
    GetawayIdea(
      id: 'it_jordan',
      type: GetawayType.suggestedItinerary,
      title: '5 days in Jordan',
      subtitle: 'Amman, Petra, Wadi Rum and the Dead Sea',
      destinationCode: 'AMM',
    ),
    GetawayIdea(
      id: 'it_dubai',
      type: GetawayType.suggestedItinerary,
      title: 'Weekend in Dubai',
      subtitle: 'Downtown, Old Dubai souks and a desert safari',
      destinationCode: 'DXB',
    ),
    GetawayIdea(
      id: 'it_oman',
      type: GetawayType.suggestedItinerary,
      title: '4 days in Oman',
      subtitle: 'Muscat, Nizwa fort and Wahiba Sands',
      destinationCode: 'MCT',
    ),

    // Public holidays (fixed-date holidays only)
    GetawayIdea(
      id: 'ph_new_year',
      type: GetawayType.publicHoliday,
      title: "New Year's Day",
      subtitle: '1 January: a long weekend for a short city break',
      destinationCode: 'IST',
    ),
    GetawayIdea(
      id: 'ph_unity',
      type: GetawayType.publicHoliday,
      title: 'Yemen Unity Day',
      subtitle: '22 May: a good time for a nearby getaway',
      destinationCode: 'MCT',
    ),
    GetawayIdea(
      id: 'ph_revolution',
      type: GetawayType.publicHoliday,
      title: '26 September Revolution Day',
      subtitle: 'Autumn weather is great in Amman',
      destinationCode: 'AMM',
    ),
    GetawayIdea(
      id: 'ph_independence',
      type: GetawayType.publicHoliday,
      title: '30 November Independence Day',
      subtitle: 'Winter sun in Dubai',
      destinationCode: 'DXB',
    ),
  ];
}
