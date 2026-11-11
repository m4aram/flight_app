import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Row with an icon, title/subtitle and the blue `- | +` buttons.
/// Used by the passengers page and the guests & rooms sheet.
class CounterRow extends StatelessWidget {
  const CounterRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onIncrement,
    required this.onDecrement,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// `null` disables the button.
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          _CounterButtons(
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            title: title,
          ),
        ],
      ),
    );
  }
}

class _CounterButtons extends StatelessWidget {
  const _CounterButtons({
    required this.onIncrement,
    required this.onDecrement,
    required this.title,
  });

  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(Icons.remove, onDecrement, 'Decrease $title'),
          Container(width: 1, height: 20, color: Colors.white54),
          _button(Icons.add, onIncrement, 'Increase $title'),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback? onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 32,
          child: Icon(
            icon,
            size: 18,
            color: onTap == null ? Colors.white54 : Colors.white,
          ),
        ),
      ),
    );
  }
}
