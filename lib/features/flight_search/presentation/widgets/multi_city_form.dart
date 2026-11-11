import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/widgets/field_tile.dart';
import '../../domain/entities/flight_leg.dart';
import '../bloc/flight_search_bloc.dart';
import 'airport_picker_sheet.dart';

/// List of From | To | Date rows with "Add one more flight".
class MultiCityForm extends StatelessWidget {
  const MultiCityForm({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FlightSearchBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, leg) in state.legs.indexed)
          _LegRow(
            key: ValueKey('leg_$index'),
            index: index,
            leg: leg,
            canRemove: state.canRemoveLeg,
            previousDate: index > 0 ? state.legs[index - 1].date : null,
          ),
        if (state.canAddLeg)
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 4, bottom: 8),
            child: TextButton.icon(
              onPressed:
                  () => context.read<FlightSearchBloc>().add(const LegAdded()),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(AppStrings.addOneMoreFlight),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.link.copyWith(fontSize: 13),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
      ],
    );
  }
}

class _LegRow extends StatelessWidget {
  const _LegRow({
    super.key,
    required this.index,
    required this.leg,
    required this.canRemove,
    required this.previousDate,
  });

  final int index;
  final FlightLeg leg;
  final bool canRemove;
  final DateTime? previousDate;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FlightSearchBloc>();

    return FieldRow(
      icon: Icons.flight,
      child: Row(
        children: [
          Expanded(
            child: FieldValue(
              label: AppStrings.from,
              value: leg.from?.code ?? '--',
              onTap: () async {
                final airport = await showAirportPicker(
                  context,
                  title: '${AppStrings.from} (${index + 1})',
                );
                if (airport != null) bloc.add(LegFromSelected(index, airport));
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FieldValue(
              label: AppStrings.to,
              value: leg.to?.code ?? '--',
              onTap: () async {
                final airport = await showAirportPicker(
                  context,
                  title: '${AppStrings.to} (${index + 1})',
                );
                if (airport != null) bloc.add(LegToSelected(index, airport));
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FieldValue(
              label: AppStrings.date,
              value:
                  leg.date == null
                      ? AppStrings.selectDate
                      : DateFormatter.short(leg.date!),
              onTap: () async {
                final date = await pickDate(
                  context,
                  initialDate: leg.date ?? previousDate,
                  firstDate: previousDate,
                );
                if (date != null) bloc.add(LegDateSelected(index, date));
              },
            ),
          ),
          if (canRemove)
            IconButton(
              tooltip: 'Remove flight ${index + 1}',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onPressed: () => bloc.add(LegRemoved(index)),
            ),
        ],
      ),
    );
  }
}
