import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/formatters.dart';
import '../models/product.dart';
import 'product_thumbnail.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddTap,
    this.heroPrefix = 'home',
    this.rating,
    this.tagTone = ProductTagTone.dark,
    this.brandUppercase = false,
    this.isAdding = false,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddTap;
  final String heroPrefix;
  final double? rating;
  final ProductTagTone tagTone;
  final bool brandUppercase;
  final bool isAdding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppSizes.productCardMinHeight,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ProductThumbnail(
                  product: product,
                  tone: tagTone,
                  heroPrefix: heroPrefix,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _CardDetails(
                    product: product,
                    rating: rating,
                    brandUppercase: brandUppercase,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _AddButton(isLoading: isAdding, onTap: onAddTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardDetails extends StatelessWidget {
  const _CardDetails({
    required this.product,
    required this.rating,
    required this.brandUppercase,
  });

  final Product product;
  final double? rating;
  final bool brandUppercase;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.brandChipColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.pill),
                  ),
                ),
                child: Text(
                  brandUppercase
                      ? product.brandName.toUpperCase()
                      : product.brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: brandUppercase
                      ? AppTextStyles.brandChipCaps
                      : AppTextStyles.brandChip,
                ),
              ),
            ),
            if (rating != null) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.starColor,
              ),
              const SizedBox(width: 2),
              Text(
                rating!.toStringAsFixed(1),
                style: AppTextStyles.rating,
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.productName,
        ),
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            product.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.productDescription,
          ),
        ],
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.amount(product.price),
                style: AppTextStyles.priceCard,
              ),
              const SizedBox(width: 3),
              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'EGP',
                  style: AppTextStyles.priceCurrency,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.headerAction,
      height: AppSizes.headerAction,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Container(
              width: AppSizes.addButton,
              height: AppSizes.addButton,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryShadow25,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.add_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
