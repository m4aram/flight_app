import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension SnackBarX on BuildContext {
  void showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
        ),
      );
  }
}
