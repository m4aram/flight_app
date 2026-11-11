import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

/// The plane icon with the "Flight" word under it (splash + home header).
class PlaneLogo extends StatelessWidget {
  const PlaneLogo({
    super.key,
    this.iconSize = 44,
    this.fontSize = 26,
    this.color = Colors.white,
  });

  final double iconSize;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlaneIcon(size: iconSize, color: color),
        const SizedBox(height: 6),
        Text(
          AppStrings.appName,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Plane pointing to the left (the direction it flies in the splash).
class PlaneIcon extends StatelessWidget {
  const PlaneIcon({super.key, this.size = 44, this.color = Colors.white});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 2,
      child: Icon(Icons.flight, size: size, color: color),
    );
  }
}
