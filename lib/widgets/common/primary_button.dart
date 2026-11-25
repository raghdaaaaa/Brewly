import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// While [isLoading] is true the button keeps its size and colour, hides the
/// arrow and shows a small white spinner instead.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.iconAsset = AppAssets.ctaArrow,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryShadow25,
              blurRadius: 6,
              spreadRadius: -1,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.primaryShadow20,
              blurRadius: 4,
              spreadRadius: -2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.cardColor,
            disabledBackgroundColor: AppColors.primaryColor,
            disabledForegroundColor: AppColors.cardColor,
            minimumSize: const Size(0, AppSizes.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.cardColor),
                    ),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.buttonLabel,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      SizedBox(
                        width: 13.333,
                        height: 13.333,
                        child: SvgPicture.asset(iconAsset),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
