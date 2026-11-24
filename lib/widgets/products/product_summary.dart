import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';

/// Product name, large price and description under the photo.
class ProductSummary extends StatelessWidget {
  const ProductSummary({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.detailsProductName,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.detailsPriceMaxWidth,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      Formatters.amount(product.price),
                      style: AppTextStyles.detailsPrice,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Text(
                      'EGP',
                      style: AppTextStyles.detailsPriceCurrency,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.detailsNameDescriptionGap),
          child: Divider(height: 1, color: AppColors.borderColor),
        ),
        Text(
          product.description,
          style: AppTextStyles.detailsDescription,
        ),
      ],
    );
  }
}
