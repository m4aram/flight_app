import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/account_header.dart';
import '../widgets/account_tile.dart';
import '../widgets/settings_row.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: BlocListener<SettingsBloc, SettingsState>(
          listenWhen:
              (p, c) =>
                  c.errorMessage != null && p.errorMessage != c.errorMessage,
          listener:
              (context, state) =>
                  context.showMessage(state.errorMessage!, isError: true),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder:
                    (context, auth) => AccountHeader(
                      user: auth.user,
                      onLoginTap: () => context.push(AppRoutes.login),
                      onLogoutTap:
                          () => context.read<AuthBloc>().add(
                            const AuthLogoutRequested(),
                          ),
                    ),
              ),
              const SizedBox(height: 8),
              const _SectionTitle(AppStrings.myProfile),
              AccountTile(
                icon: Icons.person_outline,
                label: AppStrings.personalInfo,
                onTap: () => context.push(AppRoutes.personalInfo),
              ),
              AccountTile(
                icon: Icons.credit_card,
                label: AppStrings.preferredPaymentMethod,
                onTap: () => context.push(AppRoutes.accountPaymentTypes),
              ),
              const _SectionTitle(AppStrings.myTrips),
              AccountTile(
                icon: Icons.apartment,
                label: AppStrings.hotelBookings,
                onTap: () => context.push(AppRoutes.hotelBookings),
              ),
              AccountTile(
                icon: Icons.group_add_outlined,
                label: AppStrings.addEditTraveler,
                onTap: () => context.push(AppRoutes.personalDetails),
              ),
              const _SectionTitle(AppStrings.setting),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: SettingsRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: AppTextStyles.sectionTitle),
    );
  }
}
