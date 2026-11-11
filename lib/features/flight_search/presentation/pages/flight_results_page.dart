import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/flight.dart';

/// Data passed to the results page through the router.
class FlightResultsArgs {
  const FlightResultsArgs({required this.title, required this.flights});

  final String title;
  final List<Flight> flights;
}

class FlightResultsPage extends StatelessWidget {
  const FlightResultsPage({super.key, required this.args});

  final FlightResultsArgs? args;

  @override
  Widget build(BuildContext context) {
    final flights = args?.flights ?? const <Flight>[];
    final sorted = [...flights]..sort((a, b) => a.price.compareTo(b.price));

    return Scaffold(
      appBar: PageAppBar(title: args?.title ?? AppStrings.searchResults),
      body:
          sorted.isEmpty
              ? const EmptyView(message: AppStrings.noFlights)
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: sorted.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text(
                      '${sorted.length} flights · cheapest first',
                      style: AppTextStyles.small,
                    );
                  }
                  return _FlightCard(flight: sorted[index - 1]);
                },
              ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  const _FlightCard({required this.flight});

  final Flight flight;

  static String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String _duration(int minutes) => '${minutes ~/ 60}h ${minutes % 60}m';

  @override
  Widget build(BuildContext context) {
    final arrival = flight.departureTime.add(
      Duration(minutes: flight.durationMinutes),
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.showMessage(AppStrings.bookingNeedsBackend),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flight, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(flight.airline, style: AppTextStyles.bodyBold),
                  ),
                  Text(
                    '\$${flight.price.toStringAsFixed(0)}',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Endpoint(
                    time: _time(flight.departureTime),
                    code: flight.fromCode,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _duration(flight.durationMinutes),
                          style: AppTextStyles.caption,
                        ),
                        const Divider(color: AppColors.divider),
                        const Text('Direct', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  _Endpoint(time: _time(arrival), code: flight.toCode),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormatter.short(flight.departureTime),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({required this.time, required this.code});

  final String time;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(time, style: AppTextStyles.sectionTitle),
          Text(code, style: AppTextStyles.small),
        ],
      ),
    );
  }
}
