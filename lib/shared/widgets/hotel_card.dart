import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/rating_stars.dart';
import '../domain/entities/hotel.dart';

/// Hotel card used on Home ("Hotels in Istanbul") and Stories.
class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    this.onTap,
    this.isBookmarked,
    this.onBookmarkTap,
    this.imageHeight = 100,
  });

  final Hotel hotel;
  final VoidCallback? onTap;

  /// When not null, a bookmark button is shown on the image.
  final bool? isBookmarked;
  final VoidCallback? onBookmarkTap;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AppImage(
                  hotel.imagePath,
                  height: imageHeight,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(8),
                  semanticLabel: hotel.name,
                ),
                if (isBookmarked != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: _BookmarkButton(
                      isBookmarked: isBookmarked!,
                      onTap: onBookmarkTap,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  RatingStars(stars: hotel.stars),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _ScoreBadge(score: hotel.reviewScore),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${hotel.reviewLabel} (${hotel.reviewsCount})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(AppStrings.checkFares, style: AppTextStyles.link),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        score.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.isBookmarked, required this.onTap});

  final bool isBookmarked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: AppColors.primary,
            semanticLabel: isBookmarked ? 'Remove bookmark' : 'Bookmark',
          ),
        ),
      ),
    );
  }
}
