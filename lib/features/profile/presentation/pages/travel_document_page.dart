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
import '../../domain/entities/travel_document.dart';
import '../bloc/travel_document_bloc.dart';

/// Travel document form. Pops with `true` after a successful save.
class TravelDocumentPage extends StatelessWidget {
  const TravelDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => sl<TravelDocumentBloc>()..add(const TravelDocumentRequested()),
      child: const TravelDocumentView(),
    );
  }
}

class TravelDocumentView extends StatelessWidget {
  const TravelDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PageAppBar(title: AppStrings.travelDocuments),
      body: BlocConsumer<TravelDocumentBloc, TravelDocumentState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == TravelDocumentStatus.failure) {
            context.showMessage(state.errorMessage ?? '', isError: true);
          } else if (state.status == TravelDocumentStatus.saved) {
            context.showMessage(AppStrings.saved);
            Navigator.of(context).pop(true);
          }
        },
        buildWhen:
            (p, c) =>
                p.status == TravelDocumentStatus.initial ||
                p.status == TravelDocumentStatus.loading,
        builder: (context, state) {
          if (state.status == TravelDocumentStatus.initial ||
              state.status == TravelDocumentStatus.loading) {
            return const LoadingView();
          }
          return _DocumentForm(initial: state.document);
        },
      ),
    );
  }
}

class _DocumentForm extends StatefulWidget {
  const _DocumentForm({required this.initial});

  final TravelDocument? initial;

  @override
  State<_DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<_DocumentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _number;
  late DocumentType _type;
  String? _country;
  DateTime? _expiry;
  String? _pickerError;

  @override
  void initState() {
    super.initState();
    final d = widget.initial;
    _number = TextEditingController(text: d?.number);
    _type = d?.type ?? DocumentType.passport;
    _country = d?.issuingCountry;
    _expiry = d?.expiryDate;
  }

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  Future<void> _pickCountry() async {
    final value = await showSelectionSheet<String>(
      context: context,
      title: AppStrings.issuingCountry,
      items: Countries.nationalities,
      labelOf: (c) => c,
      selected: _country,
    );
    if (value != null && mounted) {
      setState(() {
        _country = value;
        _pickerError = null;
      });
    }
  }

  Future<void> _pickExpiry() async {
    final tomorrow = DateFormatter.today().add(const Duration(days: 1));
    final date = await pickDate(
      context,
      initialDate: _expiry,
      firstDate: tomorrow,
      lastDate: tomorrow.add(const Duration(days: 365 * 15)),
    );
    if (date != null && mounted) {
      setState(() {
        _expiry = date;
        _pickerError = null;
      });
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isTextValid = _formKey.currentState?.validate() ?? false;

    String? pickerError;
    if (_country == null) {
      pickerError = 'Please choose the issuing country';
    } else if (_expiry == null) {
      pickerError = 'Please select the expiry date';
    }
    setState(() => _pickerError = pickerError);
    if (!isTextValid || pickerError != null) return;

    context.read<TravelDocumentBloc>().add(
      TravelDocumentSubmitted(
        TravelDocument(
          type: _type,
          number: _number.text,
          issuingCountry: _country!,
          expiryDate: _expiry!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select(
      (TravelDocumentBloc b) => b.state.status == TravelDocumentStatus.saving,
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            AppStrings.travelDocuments,
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 6),
          const Text(
            AppStrings.travelDocumentsHint,
            style: AppTextStyles.small,
          ),
          const SizedBox(height: 16),
          const Text(AppStrings.documentType, style: AppTextStyles.caption),
          Row(
            children: [
              for (final type in DocumentType.values) ...[
                RadioRow(
                  label: type.label,
                  dense: true,
                  selected: _type == type,
                  onTap: () => setState(() => _type = type),
                ),
                const SizedBox(width: 24),
              ],
            ],
          ),
          TextFormField(
            controller: _number,
            validator: Validators.documentNumber,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            enableSuggestions: false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
              LengthLimitingTextInputFormatter(20),
            ],
            style: AppTextStyles.fieldValue,
            decoration: const InputDecoration(
              labelText: AppStrings.documentNumber,
              labelStyle: AppTextStyles.small,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          PickerField(
            label: AppStrings.issuingCountry,
            value: _country ?? 'Select country',
            icon: Icons.keyboard_arrow_down,
            onTap: _pickCountry,
          ),
          PickerField(
            label: AppStrings.expiryDate,
            value:
                _expiry == null ? 'Select date' : DateFormatter.full(_expiry!),
            icon: Icons.calendar_today_outlined,
            onTap: _pickExpiry,
          ),
          if (_pickerError != null) ...[
            const SizedBox(height: 8),
            Text(
              _pickerError!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppStrings.documentSecureNote,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
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
