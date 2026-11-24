import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/category.dart';
import '../common/network_image_box.dart';

/// One circular category image with its name, used in the Home row.
class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    super.key,
    required this.category,
    required this.onTap,
  });

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.categoryCircle,
              height: AppSizes.categoryCircle,
              decoration: const BoxDecoration(
                color: AppColors.cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: NetworkImageBox(
                url: category.pictureUrl ?? '',
                width: AppSizes.categoryCircle,
                height: AppSizes.categoryCircle,
                radius: AppRadius.pill,
                iconSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.categoryName,
            ),
          ],
        ),
      ),
    );
  }
}
