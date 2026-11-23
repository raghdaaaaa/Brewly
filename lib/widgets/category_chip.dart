import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// One selectable category pill.
/// The color change is animated with AnimatedContainer.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppRadius.pill),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.chipLabelSelected
              : AppTextStyles.chipLabel,
        ),
      ),
    );
  }
}
