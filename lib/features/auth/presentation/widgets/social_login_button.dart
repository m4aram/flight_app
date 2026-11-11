import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      icon: icon,
      height: 40,
      borderRadius: 6,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
    );
  }
}
