import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/field_tile.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../domain/entities/cabin_class.dart';
import '../../domain/entities/passenger_count.dart';
import '../../domain/entities/trip_type.dart';
import '../bloc/flight_search_bloc.dart';
import '../widgets/multi_city_form.dart';
import 'flight_results_page.dart';
import '../widgets/route_form.dart';
import '../widgets/trip_type_tab_bar.dart';

class FlightSearchPage extends StatelessWidget {
  const FlightSearchPage({
    super.key,
    this.tripType = TripType.roundTrip,
    this.destinationCode,
  });

  final TripType tripType;
  final String? destinationCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<FlightSearchBloc>()..add(
                FlightSearchStarted(
                  tripType: tripType,
                  destinationCode: destinationCode,
                ),
              ),
      child: const FlightSearchView(),
    );
  }
}

class FlightSearchView extends StatelessWidget {
  const FlightSearchView({super.key});

  /// `SAH → IST` or `SAH → AMM → IST` for multi-city.
  static String _resultsTitle(FlightSearchState state) {
    final legs = state.toCriteria().legs;
    final codes = <String>[
      if (legs.isNotEmpty && legs.first.from != null) legs.first.from!.code,
      for (final leg in legs)
        if (leg.to != null) leg.to!.code,
    ];
    return codes.join(' → ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PageAppBar(
        title: AppStrings.flightSearch,
        bottom: TripTypeTabBar(
          selected: context.select((FlightSearchBloc b) => b.state.tripType),
          onChanged:
              (type) =>
                  context.read<FlightSearchBloc>().add(TripTypeChanged(type)),
        ),
      ),
      body: BlocListener<FlightSearchBloc, FlightSearchState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case FlightSearchStatus.failure:
              context.showMessage(state.errorMessage ?? '', isError: true);
            case FlightSearchStatus.success:
              context.push(
                AppRoutes.flightResults,
                extra: FlightResultsArgs(
                  title: _resultsTitle(state),
                  flights: state.results,
                ),
              );
            case FlightSearchStatus.initial || FlightSearchStatus.loading:
              break;
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocSelector<FlightSearchBloc, FlightSearchState, TripType>(
                  selector: (state) => state.tripType,
                  builder:
                      (context, tripType) =>
                          tripType == TripType.multiCity
                              ? const MultiCityForm()
                              : RouteForm(
                                isRoundTrip: tripType == TripType.roundTrip,
                              ),
                ),
                const _CommonFields(),
                const SizedBox(height: 32),
                const _SearchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Passengers, cabin class and payment type (shared by all trip types).
class _CommonFields extends StatelessWidget {
  const _CommonFields();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FlightSearchBloc>();
    final state = context.watch<FlightSearchBloc>().state;

    return Column(
      children: [
        FieldTile(
          icon: Icons.people_outline,
          label: AppStrings.passengers,
          value: state.passengers.label,
          onTap: () async {
            final result = await context.push<PassengerCount>(
              AppRoutes.passengers,
              extra: state.passengers,
            );
            if (result != null) bloc.add(PassengersChanged(result));
          },
        ),
        FieldTile(
          icon: Icons.airline_seat_recline_normal,
          label: AppStrings.cabinClass,
          value: state.cabinClass.label,
          onTap: () async {
            final result = await showSelectionSheet<CabinClass>(
              context: context,
              title: AppStrings.cabinClass,
              items: CabinClass.values,
              labelOf: (c) => c.label,
              selected: state.cabinClass,
            );
            if (result != null) bloc.add(CabinClassChanged(result));
          },
        ),
        FieldTile(
          icon: Icons.credit_card,
          label: AppStrings.paymentTypes,
          value: state.paymentType,
          onTap: () async {
            final result = await context.push<String>(AppRoutes.paymentTypes);
            if (result != null && result.isNotEmpty) {
              bloc.add(PaymentTypeChanged(result));
            }
          },
        ),
      ],
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (FlightSearchBloc b) => b.state.status == FlightSearchStatus.loading,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: PrimaryButton(
        label: AppStrings.searchFlights,
        isLoading: isLoading,
        onPressed:
            () => context.read<FlightSearchBloc>().add(
              const FlightSearchSubmitted(),
            ),
      ),
    );
  }
}
