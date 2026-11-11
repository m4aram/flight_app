import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/widgets/field_tile.dart';
import '../bloc/flight_search_bloc.dart';
import 'airport_picker_sheet.dart';

/// Departure, destination and date(s) for one-way and round-trip.
class RouteForm extends StatelessWidget {
  const RouteForm({super.key, required this.isRoundTrip});

  final bool isRoundTrip;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FlightSearchBloc>();
    final state = context.watch<FlightSearchBloc>().state;

    return Column(
      children: [
        FieldTile(
          icon: Icons.flight_takeoff,
          label: AppStrings.departure,
          value: state.departure?.displayName ?? AppStrings.chooseDeparture,
          onTap: () async {
            final airport = await showAirportPicker(
              context,
              title: AppStrings.departure,
            );
            if (airport != null) bloc.add(DepartureAirportSelected(airport));
          },
        ),
        FieldTile(
          icon: Icons.flight_land,
          label: AppStrings.destination,
          value: state.destination?.displayName ?? AppStrings.chooseArrival,
          onTap: () async {
            final airport = await showAirportPicker(
              context,
              title: AppStrings.destination,
            );
            if (airport != null) bloc.add(DestinationAirportSelected(airport));
          },
        ),
        FieldRow(
          icon: Icons.calendar_month_outlined,
          child: Row(
            children: [
              Expanded(
                child: FieldValue(
                  label: AppStrings.departureDate,
                  value: _format(state.departureDate),
                  onTap: () async {
                    final date = await pickDate(
                      context,
                      initialDate: state.departureDate,
                    );
                    if (date != null) bloc.add(DepartureDateSelected(date));
                  },
                ),
              ),
              if (isRoundTrip) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: FieldValue(
                    label: AppStrings.returnDate,
                    value: _format(state.returnDate),
                    onTap: () async {
                      final date = await pickDate(
                        context,
                        initialDate: state.returnDate ?? state.departureDate,
                        firstDate: state.departureDate,
                      );
                      if (date != null) bloc.add(ReturnDateSelected(date));
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _format(DateTime? date) =>
      date == null ? AppStrings.selectDate : DateFormatter.short(date);
}
