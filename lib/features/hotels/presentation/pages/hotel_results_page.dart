import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../../../shared/widgets/hotel_card.dart';

class HotelResultsArgs {
  const HotelResultsArgs({
    required this.city,
    required this.subtitle,
    required this.hotels,
  });

  final String city;

  /// e.g. `Sat, 10 Feb - Mon, 12 Feb · 2 Guests in 1 Room`
  final String subtitle;
  final List<Hotel> hotels;
}

class HotelResultsPage extends StatelessWidget {
  const HotelResultsPage({super.key, required this.args});

  final HotelResultsArgs? args;

  @override
  Widget build(BuildContext context) {
    final hotels = args?.hotels ?? const <Hotel>[];

    return Scaffold(
      appBar: PageAppBar(
        title:
            args == null
                ? AppStrings.searchResults
                : '${AppStrings.hotelsIn} ${args!.city}',
      ),
      body:
          hotels.isEmpty
              ? const EmptyView(message: AppStrings.noHotels)
              : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: Text(args!.subtitle, style: AppTextStyles.small),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid.builder(
                      itemCount: hotels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 215,
                          ),
                      itemBuilder:
                          (context, index) => HotelCard(
                            hotel: hotels[index],
                            onTap:
                                () => context.showMessage(
                                  AppStrings.bookingNeedsBackend,
                                ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}
