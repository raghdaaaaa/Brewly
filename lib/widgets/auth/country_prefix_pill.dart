import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The approved country code shown beside the Egyptian phone number field.
class CountryPrefixPill extends StatelessWidget {
  const CountryPrefixPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Egypt country code plus 20',
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 72,
          minHeight: AppSizes.inputHeight,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.softSurfaceColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        child: const Text('+20', style: AppTextStyles.prefixLabel),
      ),
    );
  }
}
