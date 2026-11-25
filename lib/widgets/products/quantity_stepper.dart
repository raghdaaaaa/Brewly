import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.quantityStepperWidth,
      height: AppSizes.purchaseBarHeight,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack10,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: quantity > 1 ? onDecrease : null,
          ),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  '$quantity',
                  key: ValueKey<int>(quantity),
                  maxLines: 1,
                  style: AppTextStyles.detailsQuantity,
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: quantity < 99 ? onIncrease : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return SizedBox(
      width: AppSizes.headerAction,
      height: AppSizes.purchaseBarHeight,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: enabled
                ? AppColors.textColor
                : AppColors.mutedTextColor.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
