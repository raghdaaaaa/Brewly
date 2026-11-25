import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';

class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({
    super.key,
    required this.total,
    required this.isPlacing,
    required this.onTap,
  });

  final double total;
  final bool isPlacing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryShadow25,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: isPlacing
            ? AppColors.primaryColor.withValues(alpha: 0.75)
            : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: InkWell(
          onTap: isPlacing ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Center(
            child: isPlacing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          'Place order · ${Formatters.price(total)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.buttonLabelBold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
