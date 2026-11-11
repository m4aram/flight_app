import 'package:flutter/material.dart';

/// All colors used across the app, taken from the UI design.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF3D9DF3);
  static const Color primaryDark = Color(0xFF2B86DB);
  static const Color primaryLight = Color(0xFFE3F1FE);
  static const Color headerTop = Color(0xFF8CC8FA);

  // Clouds
  static const Color cloud = Colors.white;
  static const Color cloudBack = Color(0xFFD6EAFD);

  // Surfaces
  static const Color background = Color(0xFFF5F6F8);
  static const Color surface = Colors.white;
  static const Color divider = Color(0xFFE5E5EA);
  static const Color inputFill = Color(0xFFF1F2F4);

  // Text
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF8C8C91);
  static const Color textOnPrimary = Colors.white;

  // Social buttons
  static const Color apple = Color(0xFF1D1D1F);
  static const Color facebook = Color(0xFF7DBCF7);
  static const Color google = Color(0xFFD9D9D9);

  // States
  static const Color star = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF2E7D32);
  static const Color shadow = Color(0x14000000);
}
