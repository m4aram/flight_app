import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.stars, this.size = 12});

  static const int maxStars = 5;

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    final filled = stars.clamp(0, maxStars);
    return Semantics(
      label: '$filled of $maxStars stars',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          maxStars,
          (i) => Icon(
            i < filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: size,
            color: AppColors.star,
          ),
        ),
      ),
    );
  }
}
