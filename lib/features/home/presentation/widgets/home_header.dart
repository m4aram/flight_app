import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/cloud_band.dart';
import '../../../../core/widgets/plane_logo.dart';
import 'category_card.dart';

/// Blue sky header with clouds, the plane logo and the
/// Flights / Hotels category cards.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onFlightsTap,
    required this.onHotelsTap,
  });

  final VoidCallback onFlightsTap;
  final VoidCallback onHotelsTap;

  static const double _skyHeight = 240;
  static const double _totalHeight = 300;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: _totalHeight + topInset,
      child: Stack(
        children: [
          Container(
            height: _skyHeight + topInset,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.headerTop, AppColors.primary],
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CloudBand(height: 70, inverted: true),
          ),
          Positioned(
            top: topInset + 70,
            left: 0,
            right: 0,
            child: const Center(child: PlaneLogo(iconSize: 40, fontSize: 24)),
          ),
          Positioned(
            top: _skyHeight + topInset - 80,
            left: 0,
            right: 0,
            child: const CloudBand(height: 90),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Row(
              children: [
                Expanded(
                  child: CategoryCard(
                    icon: Icons.flight,
                    label: AppStrings.flights,
                    onTap: onFlightsTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CategoryCard(
                    icon: Icons.apartment,
                    label: AppStrings.hotels,
                    onTap: onHotelsTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
