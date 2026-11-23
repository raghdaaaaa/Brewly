import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../product_card.dart';

/// 2-column product grid shared by Home, Explore and Products List.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.favorites,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final List<Product> products;
  final Set<int> favorites;
  final ValueChanged<int> onFavoriteTap;
  final void Function(Product product) onTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Icon(
            Icons.search_off,
            size: 40,
            color: AppColors.mutedTextColor,
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: AppSizes.productGridHeight,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          isFavorite: favorites.contains(product.id),
          onFavoriteTap: () => onFavoriteTap(product.id),
          onTap: () => onTap(product),
        );
      },
    );
  }
}
