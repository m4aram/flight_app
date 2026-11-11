import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/radio_row.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/payment_methods_bloc.dart';

/// Saves the preferred payment type and pops with its name (String).
class PreferredPaymentPage extends StatelessWidget {
  const PreferredPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => sl<PaymentMethodsBloc>()..add(const PaymentMethodsStarted()),
      child: const PreferredPaymentView(),
    );
  }
}

class PreferredPaymentView extends StatelessWidget {
  const PreferredPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PageAppBar(
        title: AppStrings.preferredPaymentTypes,
        actions: [
          BlocSelector<PaymentMethodsBloc, PaymentMethodsState, bool>(
            selector: (s) => s.saveStatus == PaymentSaveStatus.saving,
            builder:
                (context, isSaving) => IconButton(
                  tooltip: AppStrings.save,
                  icon: const Icon(Icons.check, color: AppColors.textPrimary),
                  onPressed:
                      isSaving
                          ? null
                          : () => context.read<PaymentMethodsBloc>().add(
                            const PaymentPreferenceSaved(),
                          ),
                ),
          ),
        ],
      ),
      body: BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
        listenWhen: (p, c) => p.saveStatus != c.saveStatus,
        listener: (context, state) {
          if (state.saveStatus == PaymentSaveStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.saveStatus == PaymentSaveStatus.saved) {
            Navigator.of(context).pop(state.selectedMethod?.name);
          }
        },
        builder: (context, state) {
          final bloc = context.read<PaymentMethodsBloc>();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _SearchField(onChanged: (q) => bloc.add(PaymentSearchChanged(q))),
              const SizedBox(height: 12),
              const Text(AppStrings.paymentHint, style: AppTextStyles.small),
              const SizedBox(height: 8),
              if (state.loadStatus == PaymentLoadStatus.loading)
                const LoadingView()
              else if (state.loadStatus == PaymentLoadStatus.failure)
                ErrorView(
                  message: state.errorMessage ?? '',
                  onRetry: () => bloc.add(const PaymentMethodsStarted()),
                )
              else if (state.visibleMethods.isEmpty)
                const EmptyView()
              else
                for (final method in state.visibleMethods)
                  RadioRow(
                    label: method.name,
                    selected: method.id == state.selectedId,
                    onTap: () => bloc.add(PaymentMethodSelected(method.id)),
                  ),
              if (state.canViewAll)
                Center(
                  child: TextButton(
                    onPressed: () => bloc.add(const PaymentViewAllPressed()),
                    child: const Text(
                      AppStrings.viewAll,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      maxLength: 40,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: AppStrings.searchPaymentTypes,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
        counterText: '',
        isDense: true,
        filled: true,
        fillColor: AppColors.primary,
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
