import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/getaway_idea.dart';

/// "Time Lines", "Suggested Itinerary", "Public Holiday" chips.
class GetawayChips extends StatelessWidget {
  const GetawayChips({super.key});

  static IconData _icon(GetawayType type) => switch (type) {
    GetawayType.timeLines => Icons.timeline,
    GetawayType.suggestedItinerary => Icons.map_outlined,
    GetawayType.publicHoliday => Icons.celebration_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final type in GetawayType.values)
          ActionChip(
            avatar: Icon(_icon(type), size: 16, color: AppColors.primary),
            label: Text(type.label),
            labelStyle: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.divider),
            shape: const StadiumBorder(),
            onPressed: () => context.push(AppRoutes.getawayFor(type.name)),
          ),
      ],
    );
  }
}
