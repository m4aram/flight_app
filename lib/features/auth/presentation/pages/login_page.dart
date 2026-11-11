import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _onSuccess(BuildContext context, LoginState state) {
    final user = state.user;
    if (user == null) return;
    context.read<AuthBloc>().add(AuthLoggedIn(user));
    _closeLogin(context);
  }

  static void _closeLogin(BuildContext context) {
    if (context.canPop()) {
      context.pop(true);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.login),
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.status == LoginStatus.success) {
            _onSuccess(context, state);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SignUpPrompt(
                    onSignUpTap: () async {
                      final created = await context.push<bool>(
                        AppRoutes.signUp,
                      );
                      if ((created ?? false) && context.mounted) {
                        _closeLogin(context);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  const _LoginForm(),
                  const SizedBox(height: 20),
                  const Text(
                    AppStrings.or,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small,
                  ),
                  const SizedBox(height: 16),
                  SocialLoginButton(
                    label: AppStrings.signInApple,
                    icon: const Icon(
                      Icons.apple,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: AppColors.apple,
                    onPressed:
                        () =>
                            context.showMessage(AppStrings.socialNeedsBackend),
                  ),
                  const SizedBox(height: 10),
                  SocialLoginButton(
                    label: AppStrings.loginFacebook,
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: AppColors.facebook,
                    onPressed:
                        () =>
                            context.showMessage(AppStrings.socialNeedsBackend),
                  ),
                  const SizedBox(height: 10),
                  SocialLoginButton(
                    label: AppStrings.loginGoogle,
                    icon: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: AppColors.google,
                    onPressed:
                        () =>
                            context.showMessage(AppStrings.socialNeedsBackend),
                  ),
                  const SizedBox(height: 24),
                  const _TermsText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();
    final state = context.watch<LoginBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          hint: AppStrings.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: state.emailError,
          maxLength: 254,
          onChanged: (v) => bloc.add(LoginEmailChanged(v)),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hint: AppStrings.password,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          errorText: state.passwordError,
          maxLength: 128,
          onChanged: (v) => bloc.add(LoginPasswordChanged(v)),
          onSubmitted: (_) => bloc.add(const LoginSubmitted()),
          suffixIcon: IconButton(
            tooltip: state.obscurePassword ? 'Show password' : 'Hide password',
            icon: Icon(
              state.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () => bloc.add(const LoginPasswordVisibilityToggled()),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.forgotPassword),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.primary,
            ),
            child: const Text(
              AppStrings.forgotPassword,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: AppStrings.login,
          borderRadius: 6,
          isLoading: state.status == LoginStatus.submitting,
          onPressed: () {
            FocusScope.of(context).unfocus();
            bloc.add(const LoginSubmitted());
          },
        ),
      ],
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt({required this.onSignUpTap});

  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.noAccount, style: AppTextStyles.small),
        InkWell(
          onTap: onSignUpTap,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(AppStrings.signUp, style: AppTextStyles.link),
          ),
        ),
      ],
    );
  }
}

class _TermsText extends StatefulWidget {
  const _TermsText();

  @override
  State<_TermsText> createState() => _TermsTextState();
}

class _TermsTextState extends State<_TermsText> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap =
        TapGestureRecognizer()..onTap = () => context.push(AppRoutes.terms);
    _privacyTap =
        TapGestureRecognizer()..onTap = () => context.push(AppRoutes.privacy);
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(color: AppColors.primary, fontSize: 11);
    return Text.rich(
      TextSpan(
        style: AppTextStyles.caption,
        children: [
          const TextSpan(text: AppStrings.termsPrefix),
          TextSpan(
            text: AppStrings.termsOfUse,
            style: linkStyle,
            recognizer: _termsTap,
          ),
          const TextSpan(text: ' | '),
          TextSpan(
            text: AppStrings.privacyPolicy,
            style: linkStyle,
            recognizer: _privacyTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
