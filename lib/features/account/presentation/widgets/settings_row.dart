import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/selection_sheet.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_bloc.dart';

/// Language | Currency | Region boxes.
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    final settings = context.select((SettingsBloc b) => b.state.settings);

    return Row(
      children: [
        Expanded(
          child: _SettingBox(
            label: AppStrings.language,
            value: settings.language,
            onTap: () async {
              final value = await showSelectionSheet<String>(
                context: context,
                title: AppStrings.language,
                items: AppSettings.languages,
                labelOf: (l) => l,
                selected: settings.language,
              );
              if (value != null) {
                bloc.add(SettingsChanged(settings.copyWith(language: value)));
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SettingBox(
            label: AppStrings.currency,
            value: settings.currency,
            onTap: () async {
              final value = await showSelectionSheet<String>(
                context: context,
                title: AppStrings.currency,
                items: AppSettings.currencies,
                labelOf: (c) => c,
                selected: settings.currency,
              );
              if (value != null) {
                bloc.add(SettingsChanged(settings.copyWith(currency: value)));
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SettingBox(
            label: AppStrings.region,
            value: settings.region.flag,
            onTap: () async {
              final value = await showSelectionSheet<Region>(
                context: context,
                title: AppStrings.region,
                items: AppSettings.regions,
                labelOf: (r) => '${r.flag}  ${r.name}',
                selected: settings.region,
              );
              if (value != null) {
                bloc.add(
                  SettingsChanged(settings.copyWith(regionCode: value.code)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SettingBox extends StatelessWidget {
  const _SettingBox({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.link.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
