import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// A band of fluffy clouds drawn with [CustomPainter].
///
/// By default the clouds sit at the bottom of the box (flat side down).
/// Set [inverted] to hang them from the top edge.
class CloudBand extends StatelessWidget {
  const CloudBand({
    super.key,
    this.height = 70,
    this.inverted = false,
    this.frontColor = AppColors.cloud,
    this.backColor = AppColors.cloudBack,
  });

  final double height;
  final bool inverted;
  final Color frontColor;
  final Color backColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: CloudPainter(
          inverted: inverted,
          frontColor: frontColor,
          backColor: backColor,
        ),
      ),
    );
  }
}

class CloudPainter extends CustomPainter {
  const CloudPainter({
    required this.inverted,
    required this.frontColor,
    required this.backColor,
  });

  final bool inverted;
  final Color frontColor;
  final Color backColor;

  /// (x position as a fraction of width, radius as a fraction of height)
  static const List<(double, double)> _backBumps = [
    (0.05, 0.42),
    (0.20, 0.55),
    (0.36, 0.40),
    (0.52, 0.58),
    (0.68, 0.44),
    (0.84, 0.56),
    (0.99, 0.42),
  ];

  static const List<(double, double)> _frontBumps = [
    (-0.02, 0.40),
    (0.12, 0.46),
    (0.28, 0.36),
    (0.44, 0.48),
    (0.60, 0.36),
    (0.76, 0.46),
    (0.92, 0.38),
    (1.04, 0.44),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas.save();
    if (inverted) {
      canvas
        ..translate(0, size.height)
        ..scale(1, -1);
    }

    _drawLayer(
      canvas,
      size,
      bumps: _backBumps,
      color: backColor,
      baseline: 0.55,
    );
    _drawLayer(
      canvas,
      size,
      bumps: _frontBumps,
      color: frontColor,
      baseline: 0.75,
    );

    canvas.restore();
  }

  void _drawLayer(
    Canvas canvas,
    Size size, {
    required List<(double, double)> bumps,
    required Color color,
    required double baseline,
  }) {
    final paint =
        Paint()
          ..color = color
          ..isAntiAlias = true;
    final baseY = size.height * baseline;

    canvas.drawRect(Rect.fromLTRB(0, baseY, size.width, size.height), paint);

    for (final (dx, r) in bumps) {
      canvas.drawCircle(Offset(size.width * dx, baseY), size.height * r, paint);
    }
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) =>
      oldDelegate.inverted != inverted ||
      oldDelegate.frontColor != frontColor ||
      oldDelegate.backColor != backColor;
}
