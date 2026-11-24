import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../common/network_image_box.dart';

/// The large product photo with the local favorite button on top.
class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({
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
    return SizedBox(
      height: AppSizes.detailsHeroHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: '${heroPrefix}_product_${product.id}',
              child: NetworkImageBox(
                url: product.pictureUrl,
                radius: AppRadius.xl,
                iconSize: 48,
              ),
            ),
          ),
          Positioned(
            top: AppSizes.detailsFavoriteInset,
            right: AppSizes.detailsFavoriteInset,
            child: Container(
              width: AppSizes.detailsFavoriteButton,
              height: AppSizes.detailsFavoriteButton,
              decoration: const BoxDecoration(
                color: AppColors.cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowBlack10,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onFavoriteTap,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        key: ValueKey<bool>(isFavorite),
                        size: AppSizes.detailsFavoriteIcon,
                        color: isFavorite
                            ? AppColors.primaryColor
                            : AppColors.textColor,
                      ),
                    ),
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
