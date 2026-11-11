import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/domain/entities/hotel.dart';
import '../../../../shared/widgets/hotel_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/stories_bloc.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StoriesBloc>()..add(const StoriesStarted()),
      child: const StoriesView(),
    );
  }
}

class StoriesView extends StatefulWidget {
  const StoriesView({super.key});

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  bool _isSearching = false;

  void _toggleSearch() {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      context.read<StoriesBloc>().add(const StoriesSearchChanged(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title:
              _isSearching
                  ? TextField(
                    autofocus: true,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      hintText: 'Search stories',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged:
                        (q) => context.read<StoriesBloc>().add(
                          StoriesSearchChanged(q),
                        ),
                  )
                  : const Text(
                    AppStrings.stories,
                    style: AppTextStyles.heading,
                  ),
          actions: [
            IconButton(
              tooltip: _isSearching ? 'Close search' : 'Search',
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: AppColors.primary,
              ),
              onPressed: _toggleSearch,
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.divider,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: AppStrings.latest),
              Tab(text: AppStrings.bookmarks),
            ],
          ),
        ),
        body: BlocConsumer<StoriesBloc, StoriesState>(
          listenWhen:
              (p, c) =>
                  c.errorMessage != null && p.errorMessage != c.errorMessage,
          listener:
              (context, state) =>
                  context.showMessage(state.errorMessage!, isError: true),
          builder: (context, state) {
            if (state.status == StoriesStatus.failure) {
              return ErrorView(
                message: state.errorMessage ?? '',
                onRetry:
                    () =>
                        context.read<StoriesBloc>().add(const StoriesStarted()),
              );
            }
            if (state.status != StoriesStatus.loaded) {
              return const LoadingView();
            }
            return TabBarView(
              children: [
                _HotelsGrid(hotels: state.filteredStories, state: state),
                const _BookmarksTab(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookmarksTab extends StatelessWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select(
      (AuthBloc b) => b.state.isAuthenticated,
    );
    if (!isAuthenticated) return const _LoginPrompt();

    final state = context.watch<StoriesBloc>().state;
    final hotels = state.bookmarkedStories;
    if (hotels.isEmpty) {
      return const EmptyView(message: AppStrings.noBookmarks);
    }
    return _HotelsGrid(hotels: hotels, state: state);
  }
}

class _HotelsGrid extends StatelessWidget {
  const _HotelsGrid({required this.hotels, required this.state});

  final List<Hotel> hotels;
  final StoriesState state;

  @override
  Widget build(BuildContext context) {
    if (hotels.isEmpty) return const EmptyView();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hotels.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 215,
      ),
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return HotelCard(
          hotel: hotel,
          isBookmarked: state.bookmarkIds.contains(hotel.id),
          onBookmarkTap: () {
            final isAuthenticated =
                context.read<AuthBloc>().state.isAuthenticated;
            if (isAuthenticated) {
              context.read<StoriesBloc>().add(StoryBookmarkToggled(hotel.id));
            } else {
              context.push(AppRoutes.login);
            }
          },
          onTap:
              () => context.push(AppRoutes.hotelBookingsFor(city: hotel.city)),
        );
      },
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppStrings.login, style: AppTextStyles.heading),
            const SizedBox(height: 8),
            const Text(AppStrings.loginToBookmark, style: AppTextStyles.small),
            const SizedBox(height: 20),
            PrimaryButton(
              label: AppStrings.login,
              width: 200,
              onPressed: () => context.push(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}
