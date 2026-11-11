import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/widgets/destination_card.dart';
import '../bloc/explore_bloc.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/getaway_chips.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreBloc>()..add(const ExploreStarted()),
      child: const ExploreView(),
    );
  }
}

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.explore,
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 12),
                    ExploreSearchBar(
                      onChanged:
                          (q) => context.read<ExploreBloc>().add(
                            ExploreQueryChanged(q),
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.popularDestinations,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const _DestinationsGrid(),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: AppStrings.planYourGetaway,
                      subtitle: AppStrings.planYourGetawayHint,
                    ),
                    SizedBox(height: 12),
                    GetawayChips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationsGrid extends StatelessWidget {
  const _DestinationsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state.status == ExploreStatus.failure) {
          return SliverToBoxAdapter(
            child: ErrorView(
              message: state.errorMessage ?? '',
              onRetry:
                  () => context.read<ExploreBloc>().add(const ExploreStarted()),
            ),
          );
        }
        if (state.destinations.isEmpty) {
          return SliverToBoxAdapter(
            child:
                state.status == ExploreStatus.loaded
                    ? const EmptyView()
                    : const LoadingView(),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.builder(
            itemCount: state.destinations.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final destination = state.destinations[index];
              return DestinationCard(
                destination: destination,
                onTap:
                    () => context.push(
                      AppRoutes.flightSearchFor(to: destination.airportCode),
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
