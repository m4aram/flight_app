import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/travel_document_bloc.dart';

/// "Personal Info — 2 steps to go".
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const ProfileRequested()),
        ),
        BlocProvider(
          create:
              (_) =>
                  sl<TravelDocumentBloc>()
                    ..add(const TravelDocumentRequested()),
        ),
      ],
      child: const PersonalInfoView(),
    );
  }
}

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.personalInfo),
      body: Builder(
        builder: (context) {
          final isProfileDone = context.select(
            (ProfileBloc b) => b.state.profile?.isComplete ?? false,
          );
          final isDocumentDone = context.select(
            (TravelDocumentBloc b) => b.state.hasValidDocument,
          );
          final steps = (isProfileDone ? 0 : 1) + (isDocumentDone ? 0 : 1);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                steps == 0
                    ? AppStrings.allSet
                    : '$steps ${steps == 1 ? 'step' : 'steps'} to go',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 20),
              _StepCard(
                icon: Icons.person_outline,
                title: AppStrings.personalInfo,
                subtitle: AppStrings.personalInfoStepHint,
                isDone: isProfileDone,
                onTap: () async {
                  final bloc = context.read<ProfileBloc>();
                  final saved = await context.push<bool>(
                    AppRoutes.personalDetails,
                  );
                  if (saved ?? false) bloc.add(const ProfileRequested());
                },
              ),
              const SizedBox(height: 12),
              _StepCard(
                icon: Icons.badge_outlined,
                title: AppStrings.addTravelDocuments,
                subtitle: AppStrings.travelDocumentsStepHint,
                isDone: isDocumentDone,
                onTap: () async {
                  final bloc = context.read<TravelDocumentBloc>();
                  final saved = await context.push<bool>(
                    AppRoutes.travelDocument,
                  );
                  if (saved ?? false) bloc.add(const TravelDocumentRequested());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyBold),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              isDone
                  ? const Icon(Icons.check_circle, color: AppColors.success)
                  : const Text(AppStrings.setUp, style: AppTextStyles.link),
            ],
          ),
        ),
      ),
    );
  }
}
