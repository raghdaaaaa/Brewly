import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/product_service.dart';

/// Bottom sheet with the two sort values the API understands.
class SortSheet extends StatelessWidget {
  const SortSheet({super.key, required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Sort by', style: AppTextStyles.sectionHeading),
            const SizedBox(height: AppSpacing.sm),
            _SortOption(
              label: 'Price: low to high',
              value: ProductService.sortPriceAsc,
              selected: selected == ProductService.sortPriceAsc,
            ),
            _SortOption(
              label: 'Price: high to low',
              value: ProductService.sortPriceDesc,
              selected: selected == ProductService.sortPriceDesc,
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.value,
    required this.selected,
  });

  final String label;
  final String value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        height: AppSizes.buttonHeight,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: selected
                    ? AppTextStyles.subtitle
                    : AppTextStyles.bodyMuted,
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
