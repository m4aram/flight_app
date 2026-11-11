import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/getaway_idea.dart';
import '../bloc/getaway_bloc.dart';

class GetawayPage extends StatelessWidget {
  const GetawayPage({super.key, required this.type});

  final GetawayType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GetawayBloc>()..add(GetawayRequested(type)),
      child: _GetawayView(type: type),
    );
  }
}

class _GetawayView extends StatelessWidget {
  const _GetawayView({required this.type});

  final GetawayType type;

  static IconData iconFor(GetawayType type) => switch (type) {
    GetawayType.timeLines => Icons.timeline,
    GetawayType.suggestedItinerary => Icons.map_outlined,
    GetawayType.publicHoliday => Icons.celebration_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: type.label),
      body: BlocBuilder<GetawayBloc, GetawayState>(
        builder: (context, state) {
          return switch (state.status) {
            GetawayStatus.initial ||
            GetawayStatus.loading => const LoadingView(),
            GetawayStatus.failure => ErrorView(
              message: state.errorMessage ?? '',
              onRetry:
                  () => context.read<GetawayBloc>().add(GetawayRequested(type)),
            ),
            GetawayStatus.loaded =>
              state.ideas.isEmpty
                  ? const EmptyView()
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.ideas.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Text(
                          type.description,
                          style: AppTextStyles.small,
                        );
                      }
                      return _IdeaTile(
                        idea: state.ideas[index - 1],
                        icon: iconFor(type),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }
}

class _IdeaTile extends StatelessWidget {
  const _IdeaTile({required this.idea, required this.icon});

  final GetawayIdea idea;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final code = idea.destinationCode;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(idea.title, style: AppTextStyles.bodyBold),
        subtitle: Text(idea.subtitle, style: AppTextStyles.small),
        trailing:
            code == null
                ? null
                : const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
        onTap:
            code == null
                ? null
                : () => context.push(AppRoutes.flightSearchFor(to: code)),
      ),
    );
  }
}
