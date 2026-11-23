import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import '../services/dummy/dummy_data.dart';
import '../widgets/app_header.dart';
import '../widgets/common/product_grid.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final Set<int> _favoriteIds = {};

  void _toggleFavorite(int productId) {
    setState(() {
      if (_favoriteIds.contains(productId)) {
        _favoriteIds.remove(productId);
      } else {
        _favoriteIds.add(productId);
      }
    });
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      AppRoutes.detailsRoute,
      arguments: {'product': product, 'heroPrefix': 'list'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          children: [
            const AppHeaderTop(),
            const SizedBox(height: AppSpacing.md),
            const Text('Products', style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.md),
            ProductGrid(
              products: dummyProducts,
              favorites: _favoriteIds,
              onFavoriteTap: _toggleFavorite,
              onTap: _openProduct,
              heroPrefix: 'list',
            ),
          ],
        ),
      ),
    );
  }
}
