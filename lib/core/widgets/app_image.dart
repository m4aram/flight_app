import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Local image with rounded corners and a safe placeholder if missing.
class AppImage extends StatelessWidget {
  const AppImage(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.semanticLabel,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        errorBuilder:
            (context, error, stackTrace) => Container(
              width: width,
              height: height,
              color: AppColors.primaryLight,
              alignment: Alignment.center,
              child: const Icon(Icons.image_outlined, color: AppColors.primary),
            ),
      ),
    );
  }
}
