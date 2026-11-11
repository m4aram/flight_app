import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/trip_type.dart';

/// ONE-WAY | ROUND-TRIP | MULTI-CITY tabs under the app bar.
class TripTypeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TripTypeTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TripType selected;
  final ValueChanged<TripType> onChanged;

  static const double _height = 44;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  static String _label(TripType type) => switch (type) {
    TripType.oneWay => AppStrings.oneWay,
    TripType.roundTrip => AppStrings.roundTrip,
    TripType.multiCity => AppStrings.multiCity,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          for (final type in TripType.values)
            Expanded(
              child: _Tab(
                label: _label(type),
                isSelected: type == selected,
                onTap: () => onChanged(type),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
