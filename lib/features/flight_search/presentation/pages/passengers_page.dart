import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/counter_row.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../domain/entities/passenger_count.dart';
import '../bloc/passengers_bloc.dart';

/// Returns the updated [PassengerCount] when the check icon is pressed.
class PassengersPage extends StatelessWidget {
  const PassengersPage({super.key, this.initial = const PassengerCount()});

  final PassengerCount initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PassengersBloc(initial),
      child: const PassengersView(),
    );
  }
}

class PassengersView extends StatelessWidget {
  const PassengersView({super.key});

  static String _title(PassengerType type, int count) => switch (type) {
    PassengerType.adult => '$count ${count == 1 ? 'Adult' : 'Adults'}',
    PassengerType.child => '$count ${count == 1 ? 'Child' : 'Children'}',
    PassengerType.infant => '$count ${count == 1 ? 'Infant' : 'Infants'}',
  };

  static String _subtitle(PassengerType type) => switch (type) {
    PassengerType.adult => '(12+ years)',
    PassengerType.child => '(2-11 years)',
    PassengerType.infant => '(Under 2)',
  };

  static IconData _icon(PassengerType type) => switch (type) {
    PassengerType.adult => Icons.person_outline,
    PassengerType.child => Icons.child_care_outlined,
    PassengerType.infant => Icons.baby_changing_station_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PageAppBar(
        title: AppStrings.passengers,
        actions: [
          IconButton(
            tooltip: 'Done',
            icon: const Icon(Icons.check, color: AppColors.textPrimary),
            onPressed:
                () => Navigator.of(
                  context,
                ).pop(context.read<PassengersBloc>().state),
          ),
        ],
      ),
      body: BlocBuilder<PassengersBloc, PassengerCount>(
        builder: (context, count) {
          final bloc = context.read<PassengersBloc>();
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              for (final type in PassengerType.values)
                CounterRow(
                  icon: _icon(type),
                  title: _title(type, count.countOf(type)),
                  subtitle: _subtitle(type),
                  onIncrement:
                      count.canIncrement(type)
                          ? () => bloc.add(PassengerIncremented(type))
                          : null,
                  onDecrement:
                      count.canDecrement(type)
                          ? () => bloc.add(PassengerDecremented(type))
                          : null,
                ),
            ],
          );
        },
      ),
    );
  }
}
