import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/airport.dart';
import '../bloc/airport_picker_bloc.dart';

/// Opens a searchable list of airports and returns the chosen one.
Future<Airport?> showAirportPicker(
  BuildContext context, {
  required String title,
}) {
  return showModalBottomSheet<Airport>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (_) => BlocProvider(
          create:
              (_) =>
                  sl<AirportPickerBloc>()..add(const AirportQueryChanged('')),
          child: _AirportPickerSheet(title: title),
        ),
  );
}

class _AirportPickerSheet extends StatelessWidget {
  const _AirportPickerSheet({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(title, style: AppTextStyles.sectionTitle),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                autofocus: true,
                maxLength: 60,
                textInputAction: TextInputAction.search,
                onChanged:
                    (q) => context.read<AirportPickerBloc>().add(
                      AirportQueryChanged(q),
                    ),
                decoration: InputDecoration(
                  hintText: AppStrings.searchAirports,
                  counterText: '',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AirportPickerBloc, AirportPickerState>(
                builder: (context, state) {
                  if (state.status == AirportPickerStatus.failure) {
                    return ErrorView(message: state.errorMessage ?? '');
                  }
                  if (state.airports.isEmpty) {
                    return state.status == AirportPickerStatus.loaded
                        ? const EmptyView()
                        : const LoadingView();
                  }
                  return ListView.separated(
                    itemCount: state.airports.length,
                    separatorBuilder:
                        (_, _) =>
                            const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (context, index) {
                      final airport = state.airports[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.local_airport,
                          color: AppColors.primary,
                        ),
                        title: Text(
                          airport.displayName,
                          style: AppTextStyles.bodyBold,
                        ),
                        subtitle: Text(
                          '${airport.name}, ${airport.country}',
                          style: AppTextStyles.small,
                        ),
                        onTap: () => Navigator.of(context).pop(airport),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
