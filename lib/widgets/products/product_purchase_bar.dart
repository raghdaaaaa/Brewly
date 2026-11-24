import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'quantity_stepper.dart';

/// The fixed bottom bar with the quantity stepper and the add-to-cart button.
class ProductPurchaseBar extends StatelessWidget {
  const ProductPurchaseBar({
    super.key,
    required this.quantity,
    required this.total,
    required this.isAdding,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAdd,
  });

  final int quantity;
  final double total;
  final bool isAdding;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border(top: BorderSide(color: AppColors.borderColor)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack05,
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            QuantityStepper(
              quantity: quantity,
              onDecrease: onDecrease,
              onIncrease: onIncrease,
            ),
            const SizedBox(width: AppSizes.purchaseBarGap),
            Expanded(
              child: _AddToCartButton(
                total: total,
                isAdding: isAdding,
                onTap: onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.total,
    required this.isAdding,
    required this.onTap,
  });

  final double total;
  final bool isAdding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
        color: isAdding
            ? AppColors.primaryColor.withValues(alpha: 0.75)
            : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isAdding ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: SizedBox(
            height: AppSizes.purchaseBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAdding)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons.shopping_bag_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      isAdding
                          ? 'Adding...'
                          : 'Add to cart · ${Formatters.price(total)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.detailsAddToCart,
                    ),
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
