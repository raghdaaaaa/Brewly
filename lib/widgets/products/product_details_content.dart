import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import 'product_hero_image.dart';
import 'product_summary.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.heroPrefix,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final Product product;
  final String heroPrefix;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProductHeroImage(
            product: product,
            heroPrefix: heroPrefix,
            isFavorite: isFavorite,
            onFavoriteTap: onFavoriteTap,
          ),
          const SizedBox(height: AppSizes.detailsHeroContentGap),
          ProductSummary(product: product),
        ],
      ),
    );
  }
}
