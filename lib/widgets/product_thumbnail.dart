import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import 'common/network_image_box.dart';

enum ProductTagTone {
  dark,

  accent,
}

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({
    super.key,
    required this.product,
    this.tone = ProductTagTone.dark,
    this.heroPrefix = 'home',
  });

  final Product product;
  final ProductTagTone tone;

  /// Keeps the Hero tag unique across tabs that are alive at the same time.
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.productCardImage,
      height: AppSizes.productCardImage,
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: '${heroPrefix}_product_${product.id}',
              child: NetworkImageBox(
                url: product.pictureUrl,
                radius: AppRadius.sm,
              ),
            ),
          ),
          if (product.categoryName.isNotEmpty)
            Positioned(
              left: AppSpacing.xs,
              right: AppSpacing.xs,
              bottom: AppSpacing.xs,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: tone == ProductTagTone.dark
                        ? AppColors.tagDarkColor
                        : AppColors.tagAccentColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.pill),
                    ),
                  ),
                  child: Text(
                    product.categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.productTag.copyWith(
                      color: tone == ProductTagTone.dark
                          ? Colors.white
                          : AppColors.textColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
