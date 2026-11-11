import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/cloud_band.dart';
import '../../../../core/widgets/plane_logo.dart';

/// Splash animation:
/// 1. Clouds come down from the top and settle at the bottom.
/// 2. The plane appears in the center, hovers, then flies off to the left.
/// 3. [onCompleted] is called once.
class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  static const Duration _duration = Duration(milliseconds: 3000);

  late final AnimationController _controller;

  // Clouds
  late final Animation<double> _topClouds;
  late final Animation<double> _bottomClouds;

  // Plane
  late final Animation<double> _planeAppear;
  late final Animation<double> _planeFly;

  // Title
  late final Animation<double> _titleOpacity;

  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);

    _topClouds = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );
    _bottomClouds = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.55, curve: Curves.easeOutCubic),
    );
    _planeAppear = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.4, curve: Curves.easeOutBack),
    );
    _planeFly = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.95, curve: Curves.easeInCubic),
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.5, curve: Curves.easeIn),
    );

    _controller
      ..addStatusListener(_onStatus)
      ..forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_completed && mounted) {
      _completed = true;
      widget.onCompleted();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const topCloudsHeight = 110.0;
    const bottomCloudsHeight = 130.0;

    return Semantics(
      label: AppStrings.appName,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Clouds slide down into place.
          final topY = -topCloudsHeight * (1 - _topClouds.value);
          final bottomY = -size.height * 0.35 * (1 - _bottomClouds.value);

          // Plane: scales in, then flies to the left and slightly up.
          final planeScale = _planeAppear.value.clamp(0.0, 1.2);
          final planeDx = -(size.width * 0.5 + 60) * _planeFly.value;
          final planeDy = -40 * _planeFly.value;

          return Stack(
            children: [
              Positioned(
                top: topY,
                left: 0,
                right: 0,
                child: const CloudBand(height: topCloudsHeight, inverted: true),
              ),
              Positioned(
                bottom: bottomY,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _bottomClouds.value.clamp(0.0, 1.0),
                  child: const CloudBand(height: bottomCloudsHeight),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(planeDx, planeDy),
                      child: Transform.scale(
                        scale: planeScale,
                        child: const PlaneIcon(size: 48),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Opacity(
                      opacity: _titleOpacity.value.clamp(0.0, 1.0),
                      child: const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
