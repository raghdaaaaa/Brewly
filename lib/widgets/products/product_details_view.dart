import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../common/empty_view.dart';
import '../error_retry.dart';
import '../loading_indicator.dart';
import 'product_details_content.dart';
import 'product_details_top_bar.dart';
import 'product_purchase_bar.dart';

/// Full layout of the Product Details screen: fixed header, scrollable body
/// and the bottom purchase bar.
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
    required this.product,
    required this.productFuture,
    required this.heroPrefix,
    required this.quantity,
    required this.isFavorite,
    required this.isAdding,
    required this.onShare,
    required this.onRetry,
    required this.onClose,
    required this.onFavoriteTap,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAdd,
  });

  final Product? product;
  final Future<Product>? productFuture;
  final String heroPrefix;
  final int quantity;
  final bool isFavorite;
  final bool isAdding;
  final VoidCallback onShare;
  final VoidCallback onRetry;
  final VoidCallback onClose;
  final VoidCallback onFavoriteTap;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final loaded = product;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: ProductDetailsTopBar(onShare: onShare),
            ),
            Expanded(
              child: loaded != null
                  ? ProductDetailsContent(
                      product: loaded,
                      heroPrefix: heroPrefix,
                      isFavorite: isFavorite,
                      onFavoriteTap: onFavoriteTap,
                    )
                  : FutureBuilder<Product>(
                      future: productFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LoadingIndicator();
                        }
                        if (snapshot.hasError) {
                          final error = snapshot.error;
                          return ErrorRetry(
                            message: error is AppException
                                ? error.message
                                : 'Could not load this product. Please try again.',
                            onRetry: onRetry,
                          );
                        }
                        final product = snapshot.data;
                        if (product == null) {
                          return EmptyView(
                            icon: Icons.local_cafe_outlined,
                            title: 'Product not found',
                            message:
                                'Open a product from the menu to see its details.',
                            actionLabel: 'Go back',
                            onAction: onClose,
                          );
                        }
                        return ProductDetailsContent(
                          product: product,
                          heroPrefix: heroPrefix,
                          isFavorite: isFavorite,
                          onFavoriteTap: onFavoriteTap,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: loaded == null
          ? null
          : ProductPurchaseBar(
              quantity: quantity,
              total: loaded.price * quantity,
              isAdding: isAdding,
              onDecrease: onDecrease,
              onIncrease: onIncrease,
              onAdd: onAdd,
            ),
    );
  }
}
