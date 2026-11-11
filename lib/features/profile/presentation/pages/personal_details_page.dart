import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/countries.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/date_picker.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/page_app_bar.dart';
import '../../../../core/widgets/picker_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/radio_row.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

/// Personal details form. Pops with `true` after a successful save.
class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileRequested()),
      child: const PersonalDetailsView(),
    );
  }
}

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.personalInfo),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.status == ProfileStatus.saved) {
            context.showMessage('Saved');
            Navigator.of(context).pop(true);
          }
        },
        buildWhen:
            (p, c) =>
                // Build the form once the stored profile is known.
                p.status == ProfileStatus.initial ||
                p.status == ProfileStatus.loading,
        builder: (context, state) {
          if (state.status == ProfileStatus.initial ||
              state.status == ProfileStatus.loading) {
            return const LoadingView();
          }
          return _ProfileForm(initial: state.profile);
        },
      ),
    );
  }
}

class _ProfileForm extends StatefulWidget {
  const _ProfileForm({required this.initial});

  final Profile? initial;

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  Gender? _gender;
  DateTime? _dateOfBirth;
  String? _nationality;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _firstName = TextEditingController(text: p?.firstName);
    _lastName = TextEditingController(text: p?.lastName);
    _email = TextEditingController(text: p?.email);
    _gender = p?.gender;
    _dateOfBirth = p?.dateOfBirth;
    _nationality = p?.nationality;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final today = DateFormatter.today();
    final date = await pickDate(
      context,
      initialDate: _dateOfBirth ?? DateTime(today.year - 25),
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (date != null && mounted) setState(() => _dateOfBirth = date);
  }

  Future<void> _pickNationality() async {
    final value = await showSelectionSheet<String>(
      context: context,
      title: AppStrings.nationality,
      items: Countries.nationalities,
      labelOf: (c) => c,
      selected: _nationality,
    );
    if (value != null && mounted) setState(() => _nationality = value);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ProfileBloc>().add(
      ProfileSubmitted(
        Profile(
          firstName: _firstName.text,
          lastName: _lastName.text,
          email: _email.text,
          gender: _gender,
          dateOfBirth: _dateOfBirth,
          nationality: _nationality,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select(
      (ProfileBloc b) => b.state.status == ProfileStatus.saving,
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            AppStrings.personalDetails,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 6),
          const Text(
            AppStrings.personalDetailsHint,
            style: AppTextStyles.small,
          ),
          const SizedBox(height: 16),
          _UnderlineField(
            controller: _firstName,
            label: AppStrings.firstName,
            validator: (v) => Validators.name(v, field: AppStrings.firstName),
            textInputAction: TextInputAction.next,
            maxLength: Validators.maxNameLength,
          ),
          _UnderlineField(
            controller: _lastName,
            label: AppStrings.lastName,
            validator: (v) => Validators.name(v, field: AppStrings.lastName),
            textInputAction: TextInputAction.next,
            maxLength: Validators.maxNameLength,
          ),
          const SizedBox(height: 12),
          const Text(AppStrings.gender, style: AppTextStyles.caption),
          Row(
            children: [
              RadioRow(
                label: AppStrings.male,
                dense: true,
                selected: _gender == Gender.male,
                onTap: () => setState(() => _gender = Gender.male),
              ),
              const SizedBox(width: 32),
              RadioRow(
                label: AppStrings.female,
                dense: true,
                selected: _gender == Gender.female,
                onTap: () => setState(() => _gender = Gender.female),
              ),
            ],
          ),
          PickerField(
            label: AppStrings.dateOfBirth,
            value:
                _dateOfBirth == null
                    ? 'Select date'
                    : DateFormatter.full(_dateOfBirth!),
            icon: Icons.calendar_today_outlined,
            onTap: _pickDateOfBirth,
          ),
          PickerField(
            label: AppStrings.nationality,
            value: _nationality ?? 'Select nationality',
            icon: Icons.keyboard_arrow_down,
            onTap: _pickNationality,
          ),
          const SizedBox(height: 24),
          const Text(
            AppStrings.contactInformation,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 6),
          const Text(AppStrings.contactHint, style: AppTextStyles.small),
          _UnderlineField(
            controller: _email,
            label: AppStrings.email,
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLength: Validators.maxEmailLength,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: AppStrings.save,
            isLoading: isSaving,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      style: AppTextStyles.fieldValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.small,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder:
              (context, value, _) =>
                  value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                        tooltip: 'Clear',
                        icon: const Icon(
                          Icons.cancel,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: controller.clear,
                      ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
