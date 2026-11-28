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

// Replace everything from `class _LoginForm` down to (not including)
// `class _SignUpPrompt` in login_page.dart with this code.

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    // No watch here: each child listens only to what it needs.
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(),
        SizedBox(height: 12),
        _PasswordField(),
        _ForgotPasswordLink(),
        SizedBox(height: 8),
        _LoginButton(),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when the email error changes, not on every letter.
    final error = context.select((LoginBloc b) => b.state.emailError);

    return AuthTextField(
      hint: AppStrings.email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      errorText: error,
      maxLength: 254,
      onChanged: (v) => context.read<LoginBloc>().add(LoginEmailChanged(v)),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    // A record compares by value, so this rebuilds only when one of the two changes.
    final (error, obscure) = context.select(
          (LoginBloc b) => (b.state.passwordError, b.state.obscurePassword),
    );
    final bloc = context.read<LoginBloc>();

    return AuthTextField(
      hint: AppStrings.password,
      obscureText: obscure,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      errorText: error,
      maxLength: 128,
      onChanged: (v) => bloc.add(LoginPasswordChanged(v)),
      onSubmitted: (_) => bloc.add(const LoginSubmitted()),
      suffixIcon: IconButton(
        tooltip: obscure ? 'Show password' : 'Hide password',
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () => bloc.add(const LoginPasswordVisibilityToggled()),
      ),
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when loading starts or stops.
    final isLoading = context.select(
          (LoginBloc b) => b.state.status == LoginStatus.submitting,
    );

    return PrimaryButton(
      label: AppStrings.login,
      borderRadius: 6,
      isLoading: isLoading,
      onPressed: () {
        FocusScope.of(context).unfocus();
        context.read<LoginBloc>().add(const LoginSubmitted());
      },
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
