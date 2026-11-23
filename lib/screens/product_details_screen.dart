import 'package:flutter/material.dart';

import '../core/app_colors.dart';
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
    // Dummy add for now. The POST /api/Basket call comes later.
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
            style: TextStyle(fontSize: 16, color: mutedTextColor),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image (same tag as the Home card).
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 358 / 269,
                child: Hero(
                  tag: 'product_${product.id}',
                  child: Image.network(
                    product.pictureUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: softSurfaceColor,
                        child: const Icon(
                          Icons.local_cafe,
                          size: 48,
                          color: mutedTextColor,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Container(color: softSurfaceColor);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Brand.
            Text(
              product.brandName.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: mutedTextColor,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            // Name + price.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${product.price.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category pill.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: softSurfaceColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                product.categoryName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: mutedTextColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Description.
            const Text(
              'About this item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: mutedTextColor,
              ),
            ),
            const SizedBox(height: 24),

            // Quantity counter.
            Row(
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: softSurfaceDeepColor,
                    borderRadius: BorderRadius.circular(14),
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
                        color: textColor,
                        disabledColor: borderColor,
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
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
                        color: textColor,
                        disabledColor: borderColor,
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: textColor.withValues(alpha: 0.06),
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
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: mutedTextColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(product.price * _quantity).toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _addToCart(product),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 18),
                      SizedBox(width: 8),
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
