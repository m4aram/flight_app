import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/pages/account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/explore/domain/entities/getaway_idea.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/explore/presentation/pages/getaway_page.dart';
import '../../features/flight_search/domain/entities/passenger_count.dart';
import '../../features/flight_search/domain/entities/trip_type.dart';
import '../../features/flight_search/presentation/pages/flight_results_page.dart';
import '../../features/flight_search/presentation/pages/flight_search_page.dart';
import '../../features/flight_search/presentation/pages/passengers_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/hotels/presentation/pages/hotel_bookings_page.dart';
import '../../features/hotels/presentation/pages/hotel_results_page.dart';
import '../../features/legal/presentation/pages/legal_page.dart';
import '../../features/main_shell/presentation/pages/main_shell_page.dart';
import '../../features/payment/presentation/pages/preferred_payment_page.dart';
import '../../features/profile/presentation/pages/personal_details_page.dart';
import '../../features/profile/presentation/pages/personal_info_page.dart';
import '../../features/profile/presentation/pages/travel_document_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/stories/presentation/pages/stories_page.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // ---------------- Tabs with bottom navigation ----------------
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                MainShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const ExplorePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stories,
                builder: (context, state) => const StoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const AccountPage(),
                routes: [
                  GoRoute(
                    path: AppRoutes.paymentTypesSegment,
                    builder: (context, state) => const PreferredPaymentPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ---------------- Full-screen pages ----------------
      GoRoute(
        path: AppRoutes.flightSearch,
        builder: (context, state) {
          final query = state.uri.queryParameters;
          return FlightSearchPage(
            tripType: TripType.fromName(query[AppRoutes.tripParam]),
            destinationCode: _sanitizeCode(query[AppRoutes.toParam]),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.passengers,
        builder: (context, state) {
          final extra = state.extra;
          return PassengersPage(
            initial:
                extra is PassengerCount && extra.isValid
                    ? extra
                    : const PassengerCount(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentTypes,
        builder: (context, state) => const PreferredPaymentPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.personalInfo,
        builder: (context, state) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: AppRoutes.personalDetails,
        builder: (context, state) => const PersonalDetailsPage(),
      ),
      GoRoute(
        path: AppRoutes.hotelBookings,
        builder:
            (context, state) => HotelBookingsPage(
              initialCity: _sanitizeText(
                state.uri.queryParameters[AppRoutes.cityParam],
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.flightResults,
        builder: (context, state) {
          final extra = state.extra;
          return FlightResultsPage(
            args: extra is FlightResultsArgs ? extra : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.hotelResults,
        builder: (context, state) {
          final extra = state.extra;
          return HotelResultsPage(
            args: extra is HotelResultsArgs ? extra : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.travelDocument,
        builder: (context, state) => const TravelDocumentPage(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder:
            (context, state) => const LegalPage(document: LegalDocument.terms),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder:
            (context, state) =>
                const LegalPage(document: LegalDocument.privacy),
      ),
      GoRoute(
        path: AppRoutes.getaway,
        builder:
            (context, state) => GetawayPage(
              type:
                  GetawayType.fromName(
                    state.uri.queryParameters[AppRoutes.typeParam],
                  ) ??
                  GetawayType.timeLines,
            ),
      ),
    ],
  );

  // Query parameters can come from deep links, so they are validated.

  static final RegExp _iataCode = RegExp(r'^[A-Za-z]{3}$');

  static String? _sanitizeCode(String? value) =>
      value != null && _iataCode.hasMatch(value) ? value.toUpperCase() : null;

  static String? _sanitizeText(String? value, {int maxLength = 60}) {
    final text = value?.trim();
    if (text == null || text.isEmpty || text.length > maxLength) return null;
    return text;
  }
}
