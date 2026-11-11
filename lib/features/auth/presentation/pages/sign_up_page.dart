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
import '../bloc/auth_bloc.dart';
import '../bloc/sign_up_bloc.dart';
import '../widgets/auth_text_field.dart';

/// Pops with `true` after the account is created and the user is logged in.
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignUpBloc>(),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.signUp),
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == SignUpStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.status == SignUpStatus.success &&
              state.user != null) {
            context.read<AuthBloc>().add(AuthLoggedIn(state.user!));
            context.showMessage(AppStrings.accountCreated);
            Navigator.of(context).pop(true);
          }
        },
        child: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: AutofillGroup(child: _SignUpForm()),
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignUpBloc>();
    final state = context.watch<SignUpBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(AppStrings.createAccount, style: AppTextStyles.heading),
        const SizedBox(height: 6),
        const Text(AppStrings.createAccountHint, style: AppTextStyles.small),
        const SizedBox(height: 24),
        AuthTextField(
          hint: AppStrings.fullName,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          errorText: state.nameError,
          maxLength: Validators.maxNameLength,
          onChanged: (v) => bloc.add(SignUpNameChanged(v)),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hint: AppStrings.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: state.emailError,
          maxLength: Validators.maxEmailLength,
          onChanged: (v) => bloc.add(SignUpEmailChanged(v)),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hint: AppStrings.password,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          errorText: state.passwordError,
          maxLength: 128,
          onChanged: (v) => bloc.add(SignUpPasswordChanged(v)),
          suffixIcon: IconButton(
            tooltip: state.obscurePassword ? 'Show password' : 'Hide password',
            icon: Icon(
              state.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () => bloc.add(const SignUpPasswordVisibilityToggled()),
          ),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hint: AppStrings.confirmPassword,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.done,
          errorText: state.confirmError,
          maxLength: 128,
          onChanged: (v) => bloc.add(SignUpConfirmChanged(v)),
          onSubmitted: (_) => bloc.add(const SignUpSubmitted()),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: AppStrings.signUp,
          borderRadius: 6,
          isLoading: state.status == SignUpStatus.submitting,
          onPressed: () {
            FocusScope.of(context).unfocus();
            bloc.add(const SignUpSubmitted());
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.haveAccount, style: AppTextStyles.small),
            InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(AppStrings.login, style: AppTextStyles.link),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
