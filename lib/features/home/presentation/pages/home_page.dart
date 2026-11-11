import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/widgets/hotel_card.dart';
import '../../domain/entities/home_content.dart';
import '../bloc/home_bloc.dart';
import '../widgets/explore_card.dart';
import '../widgets/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                onFlightsTap: () => context.push(AppRoutes.flightSearch),
                onHotelsTap: () => context.push(AppRoutes.hotelBookings),
              ),
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return switch (state.status) {
                  HomeStatus.initial || HomeStatus.loading =>
                    const SliverToBoxAdapter(child: LoadingView()),
                  HomeStatus.failure => SliverToBoxAdapter(
                    child: ErrorView(
                      message: state.errorMessage ?? '',
                      onRetry:
                          () =>
                              context.read<HomeBloc>().add(const HomeStarted()),
                    ),
                  ),
                  HomeStatus.loaded => _HomeBody(content: state.content!),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.content});

  final HomeContent content;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      sliver: SliverList.list(
        children: [
          const Text(AppStrings.explore, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                for (final (index, item) in content.exploreItems.indexed) ...[
                  if (index > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ExploreCard(
                      item: item,
                      onTap: () => context.go(AppRoutes.explore),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${AppStrings.hotelsIn} ${content.hotelsCity}',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 12),
          if (content.hotels.isEmpty)
            const EmptyView()
          else
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: content.hotels.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final hotel = content.hotels[index];
                  return SizedBox(
                    width: 160,
                    child: HotelCard(
                      hotel: hotel,
                      onTap:
                          () => context.push(
                            AppRoutes.hotelBookingsFor(city: hotel.city),
                          ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
