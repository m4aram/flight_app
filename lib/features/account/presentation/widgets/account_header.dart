import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/domain/entities/user.dart';

/// Blue header: login call-to-action, or the user's name when logged in.
class AccountHeader extends StatelessWidget {
  const AccountHeader({
    super.key,
    required this.user,
    required this.onLoginTap,
    required this.onLogoutTap,
  });

  final User? user;
  final VoidCallback onLoginTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final isLoggedIn = user != null;

    return Container(
      padding: EdgeInsets.fromLTRB(24, topInset + 24, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.headerTop, AppColors.primary],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            isLoggedIn
                ? 'Hello, ${user!.displayName}'
                : AppStrings.accountHeadline,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isLoggedIn ? user!.email : AppStrings.accountSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: isLoggedIn ? AppStrings.logout : AppStrings.login,
            width: 120,
            height: 36,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: isLoggedIn ? onLogoutTap : onLoginTap,
          ),
        ],
      ),
    );
  }
}
