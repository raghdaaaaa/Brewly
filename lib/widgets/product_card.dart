import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';

/// One product inside the Home grid.
/// The heart is local only: Home keeps the list of favorite ids.
///
/// [heroPrefix] disambiguates Hero tags when two grids (e.g. Home and Explore)
/// are alive in the same [IndexedStack] at the same time.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
    this.heroPrefix = 'home',
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;
  /// Prefix that makes the Hero tag unique across tabs.
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + favorite heart.
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: '${heroPrefix}_product_${product.id}',
                    child: Image.network(
                      product.pictureUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.softSurfaceColor,
                          child: const Icon(
                            Icons.local_cafe,
                            size: 32,
                            color: AppColors.mutedTextColor,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }
                        return Container(color: AppColors.softSurfaceColor);
                      },
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: AppSpacing.xxl,
                        height: AppSpacing.xxl,
                        decoration: const BoxDecoration(
                          color: AppColors.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(isFavorite),
                            size: 18,
                            color: isFavorite
                                ? AppColors.errorColor
                                : AppColors.mutedTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Name and price below image.
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)} EGP',
                    style: AppTextStyles.priceMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
