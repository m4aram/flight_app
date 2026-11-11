/// All route paths in one place.
abstract final class AppRoutes {
  static const String splash = '/';

  // Bottom navigation tabs
  static const String home = '/home';
  static const String explore = '/explore';
  static const String stories = '/stories';
  static const String account = '/account';

  // Nested under the Account tab (keeps the bottom bar visible)
  static const String paymentTypesSegment = 'payment-types';
  static const String accountPaymentTypes = '$account/$paymentTypesSegment';

  // Full-screen pages
  static const String flightSearch = '/flight-search';
  static const String passengers = '/passengers';
  static const String paymentTypes = '/payment-types';
  static const String login = '/login';
  static const String personalInfo = '/personal-info';
  static const String personalDetails = '/personal-details';
  static const String hotelBookings = '/hotel-bookings';
  static const String flightResults = '/flight-results';
  static const String hotelResults = '/hotel-results';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String travelDocument = '/travel-document';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String getaway = '/getaway';

  // Query parameter names
  static const String tripParam = 'trip';
  static const String toParam = 'to';
  static const String cityParam = 'city';
  static const String typeParam = 'type';

  /// `/flight-search?trip=roundTrip&to=IST`
  static String flightSearchFor({String? trip, String? to}) =>
      Uri(
        path: flightSearch,
        queryParameters: {
          if (trip != null) tripParam: trip,
          if (to != null) toParam: to,
        },
      ).toString();

  /// `/hotel-bookings?city=Istanbul`
  static String hotelBookingsFor({required String city}) =>
      Uri(path: hotelBookings, queryParameters: {cityParam: city}).toString();

  /// `/getaway?type=timeLines`
  static String getawayFor(String type) =>
      Uri(path: getaway, queryParameters: {typeParam: type}).toString();
}
