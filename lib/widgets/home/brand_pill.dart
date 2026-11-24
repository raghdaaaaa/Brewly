import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/brand.dart';

/// One roaster pill in the Home featured row.
class BrandPill extends StatelessWidget {
  const BrandPill({
    super.key,
    required this.brand,
    required this.isSelected,
    required this.onTap,
  });

  final Brand brand;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.headerAction,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : AppColors.cardColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.pill),
                ),
                boxShadow: isSelected
                    ? null
                    : const [
                        BoxShadow(
                          color: AppColors.searchShadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    brand.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? AppTextStyles.chipStrong
                        : AppTextStyles.chipSoft,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
