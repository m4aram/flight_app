import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_image.dart';
import '../../domain/entities/home_content.dart';

class ExploreCard extends StatelessWidget {
  const ExploreCard({super.key, required this.item, required this.onTap});

  final ExploreItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppImage(
              item.imagePath,
              width: double.infinity,
              borderRadius: BorderRadius.circular(8),
              semanticLabel: item.title,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyBold.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.link,
          ),
        ],
      ),
    );
  }
}
