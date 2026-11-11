import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/forgot_password_bloc.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordBloc>(),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.resetPassword),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child:
                  state.status == ForgotPasswordStatus.sent
                      ? _SentView(email: state.email.trim())
                      : _RequestForm(state: state),
            ),
          );
        },
      ),
    );
  }
}

class _RequestForm extends StatelessWidget {
  const _RequestForm({required this.state});

  final ForgotPasswordState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ForgotPasswordBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.lock_reset, size: 56, color: AppColors.primary),
        const SizedBox(height: 16),
        const Text(
          AppStrings.forgotPassword,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.resetPasswordHint,
          textAlign: TextAlign.center,
          style: AppTextStyles.small,
        ),
        const SizedBox(height: 24),
        AuthTextField(
          hint: AppStrings.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          errorText: state.emailError,
          maxLength: Validators.maxEmailLength,
          onChanged: (v) => bloc.add(ForgotPasswordEmailChanged(v)),
          onSubmitted: (_) => bloc.add(const ForgotPasswordSubmitted()),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: AppStrings.sendResetLink,
          borderRadius: 6,
          isLoading: state.status == ForgotPasswordStatus.submitting,
          onPressed: () {
            FocusScope.of(context).unfocus();
            bloc.add(const ForgotPasswordSubmitted());
          },
        ),
      ],
    );
  }
}

class _SentView extends StatelessWidget {
  const _SentView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 56,
          color: AppColors.success,
        ),
        const SizedBox(height: 16),
        const Text(
          AppStrings.checkYourEmail,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading,
        ),
        const SizedBox(height: 8),
        Text(
          'If an account exists for $email, you will get a link to reset '
          'your password.',
          textAlign: TextAlign.center,
          style: AppTextStyles.small,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: AppStrings.backToLogin,
          borderRadius: 6,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
