import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/field_tile.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../bloc/hotel_search_bloc.dart';
import '../widgets/guests_rooms_sheet.dart';
import 'hotel_results_page.dart';

class HotelBookingsPage extends StatelessWidget {
  const HotelBookingsPage({super.key, this.initialCity});

  final String? initialCity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<HotelSearchBloc>()..add(HotelSearchStarted(city: initialCity)),
      child: const HotelBookingsView(),
    );
  }
}

class HotelBookingsView extends StatelessWidget {
  const HotelBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.hotelBookings),
      body: BlocConsumer<HotelSearchBloc, HotelSearchState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == HotelSearchStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.status == HotelSearchStatus.success) {
            context.push(
              AppRoutes.hotelResults,
              extra: HotelResultsArgs(
                city: state.city ?? '',
                subtitle:
                    '${_format(state.checkIn)} - ${_format(state.checkOut)}'
                    ' · ${state.guestsLabel}',
                hotels: state.results,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<HotelSearchBloc>();
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TonightBanner(
                    onTap: () => bloc.add(const HotelTonightSelected()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      children: [
                        FieldTile(
                          icon: Icons.location_on_outlined,
                          label: AppStrings.destination,
                          value: state.city ?? AppStrings.chooseLocation,
                          onTap: () async {
                            if (state.cities.isEmpty) return;
                            final city = await showSelectionSheet<String>(
                              context: context,
                              title: AppStrings.chooseLocation,
                              items: state.cities,
                              labelOf: (c) => c,
                              selected: state.city,
                            );
                            if (city != null) bloc.add(HotelCitySelected(city));
                          },
                        ),
                        FieldRow(
                          icon: Icons.calendar_month_outlined,
                          child: Row(
                            children: [
                              Expanded(
                                child: FieldValue(
                                  label: AppStrings.checkIn,
                                  value: _format(state.checkIn),
                                  onTap: () async {
                                    final date = await pickDate(
                                      context,
                                      initialDate: state.checkIn,
                                    );
                                    if (date != null) {
                                      bloc.add(HotelCheckInSelected(date));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FieldValue(
                                  label: AppStrings.checkOut,
                                  value: _format(state.checkOut),
                                  onTap: () async {
                                    final first = (state.checkIn ??
                                            DateFormatter.today())
                                        .add(const Duration(days: 1));
                                    final date = await pickDate(
                                      context,
                                      initialDate: state.checkOut,
                                      firstDate: first,
                                      lastDate: first.add(
                                        const Duration(days: 365),
                                      ),
                                    );
                                    if (date != null) {
                                      bloc.add(HotelCheckOutSelected(date));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        FieldTile(
                          icon: Icons.people_outline,
                          label: AppStrings.guestsAndRooms,
                          value: state.guestsLabel,
                          onTap: () async {
                            final result = await showGuestsRoomsSheet(
                              context,
                              guests: state.guests,
                              rooms: state.rooms,
                            );
                            if (result != null) {
                              bloc.add(
                                HotelGuestsRoomsChanged(
                                  guests: result.guests,
                                  rooms: result.rooms,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: PrimaryButton(
                            label: AppStrings.searchHotels,
                            isLoading:
                                state.status == HotelSearchStatus.loading,
                            onPressed:
                                () => bloc.add(const HotelSearchSubmitted()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static String _format(DateTime? date) =>
      date == null ? AppStrings.selectDate : DateFormatter.short(date);
}

class _TonightBanner extends StatelessWidget {
  const _TonightBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.near_me, color: AppColors.primary, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.needPlaceTonight,
                  style: AppTextStyles.bodyBold,
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
