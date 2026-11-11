import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/page_app_bar.dart';

enum LegalDocument { terms, privacy }

/// Static legal text.
///
/// IMPORTANT: this is a placeholder template. Replace it with text reviewed
/// by a lawyer before publishing the app.
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.document});

  final LegalDocument document;

  static const List<(String, String)> _terms = [
    (
      'Using Flight',
      'By creating an account or using the app, you agree to these terms. '
          'If you do not agree, please do not use the app.',
    ),
    (
      'Your account',
      'You are responsible for keeping your login details safe and for all '
          'activity under your account. Tell us right away if you think your '
          'account was used without your permission.',
    ),
    (
      'Bookings',
      'Flights and hotels are provided by third-party partners. Prices and '
          'availability can change until a booking is confirmed. Each partner '
          'has its own rules for changes, cancellations and refunds.',
    ),
    (
      'Acceptable use',
      'Do not misuse the app, try to access it in unauthorized ways, or use '
          'it for anything unlawful.',
    ),
    (
      'Changes',
      'We may update these terms. We will let you know about important '
          'changes inside the app.',
    ),
  ];

  static const List<(String, String)> _privacy = [
    (
      'What we collect',
      'Account details (name, email), traveller details you choose to save '
          '(date of birth, nationality, travel documents) and your app '
          'preferences.',
    ),
    (
      'How we use it',
      'To sign you in, fill in booking forms faster and show you relevant '
          'results. We do not sell your personal data.',
    ),
    (
      'How we protect it',
      'Your session and travel documents are stored encrypted on your '
          'device. Data sent to our servers is encrypted in transit.',
    ),
    (
      'Your choices',
      'You can edit your saved details at any time from the Account tab, '
          'or log out to remove your session from this device.',
    ),
    (
      'Contact',
      'If you have questions about your data, contact our support team.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isTerms = document == LegalDocument.terms;
    final sections = isTerms ? _terms : _privacy;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PageAppBar(
        title: isTerms ? AppStrings.termsTitle : AppStrings.privacyTitle,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final (title, body) = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.sectionTitle),
              const SizedBox(height: 6),
              Text(body, style: AppTextStyles.body.copyWith(height: 1.6)),
            ],
          );
        },
      ),
    );
  }
}
