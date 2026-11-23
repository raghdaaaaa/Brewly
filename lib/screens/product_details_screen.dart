import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // How many items the user wants to add.
  int _quantity = 1;

  void _addToCart(Product product) {
    // Dummy add for now. The basket service call comes later.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity × ${product.name} added to cart'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The product is passed from Home with Navigator.pushNamed arguments.
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final product = arguments is Product ? arguments : null;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Detail')),
        body: const Center(
          child: Text(
            'Product not found',
            style: AppTextStyles.bodyLargeMuted,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image (same tag as the Home card).
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: AspectRatio(
                aspectRatio: 358 / 269,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: Image.network(
                    product.pictureUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.softSurfaceColor,
                        child: const Icon(
                          Icons.local_cafe,
                          size: 48,
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
              ),
            ),
            const SizedBox(height: 20),

            // Brand.
            Text(
              product.brandName.toUpperCase(),
              style: AppTextStyles.brandCaps,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Name + price.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.pageTitle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  '${product.price.toStringAsFixed(0)} EGP',
                  style: AppTextStyles.priceLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Category pill.
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              decoration: const BoxDecoration(
                color: AppColors.softSurfaceColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadius.pill),
                ),
              ),
              child: Text(
                product.categoryName,
                style: AppTextStyles.tag,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Description.
            const Text(
              'About this item',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.description,
              style: AppTextStyles.description,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Quantity counter.
            Row(
              children: [
                const Text(
                  'Quantity',
                  style: AppTextStyles.subtitle,
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.softSurfaceDeepColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove, size: 18),
                        color: AppColors.textColor,
                        disabledColor: AppColors.borderColor,
                      ),
                      // Animated number.
                      SizedBox(
                        width: 28,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Text(
                            '$_quantity',
                            key: ValueKey(_quantity),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _quantity < 10
                            ? () {
                                setState(() {
                                  _quantity++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add, size: 18),
                        color: AppColors.textColor,
                        disabledColor: AppColors.borderColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Sticky bottom bar with the total and the main button.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total', style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(
                    '${(product.price * _quantity).toStringAsFixed(0)} EGP',
                    style: AppTextStyles.priceTotal,
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _addToCart(product),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 18),
                      SizedBox(width: AppSpacing.sm),
                      // Flexible + ellipsis so the label never overflows.
                      Flexible(
                        child: Text(
                          'Add to cart',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
