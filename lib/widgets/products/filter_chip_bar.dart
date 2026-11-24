import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The horizontal filter pills above the Products List results.
class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    super.key,
    this.categoryName,
    this.brandName,
    required this.onClearCategory,
    required this.onClearBrand,
    required this.onLocationTap,
    required this.onRoastTap,
  });

  final String? categoryName;
  final String? brandName;
  final VoidCallback onClearCategory;
  final VoidCallback onClearBrand;
  final VoidCallback onLocationTap;
  final VoidCallback onRoastTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          if (categoryName != null) ...[
            _FilterChip(
              label: 'Category: $categoryName',
              isSelected: true,
              trailingIcon: Icons.close_rounded,
              onTap: onClearCategory,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (brandName != null) ...[
            _FilterChip(
              label: 'Brand: $brandName',
              isSelected: true,
              trailingIcon: Icons.close_rounded,
              onTap: onClearBrand,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          _FilterChip(
            label: 'Zamalek',
            leadingIcon: Icons.location_on_outlined,
            onTap: onLocationTap,
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Roast: Light to Medium',
            onTap: onRoastTap,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : AppColors.textColor;

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
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : AppColors.cardColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.pill),
                ),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 13, color: foreground),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    label,
                    maxLines: 1,
                    style: (isSelected
                            ? AppTextStyles.chipStrong
                            : AppTextStyles.chipSoft)
                        .copyWith(color: foreground),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(trailingIcon, size: 13, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
