import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/product.dart';

/// One product inside the Home grid.
/// The heart is local only: Home keeps the list of favorite ids.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + favorite heart.
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      // The same tag is used on the Details screen.
                      tag: 'product_${product.id}',
                      child: Image.network(
                        product.pictureUrl,
                        fit: BoxFit.cover,
                        // Gray box with an icon if the image cannot load.
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: softSurfaceColor,
                            child: const Icon(
                              Icons.local_cafe,
                              size: 32,
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
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: cardColor,
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
                            // The key makes AnimatedSwitcher animate the change.
                            key: ValueKey(isFavorite),
                            size: 18,
                            color: isFavorite ? errorColor : mutedTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Name and price.
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.price.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
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
