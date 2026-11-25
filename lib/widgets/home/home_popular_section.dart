import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../../models/product_page.dart';
import '../../services/dummy/dummy_data.dart';
import '../common/empty_view.dart';
import '../error_retry.dart';
import '../common/product_list_skeleton.dart';
import '../common/section_header.dart';
import '../product_card.dart';

/// "Popular Right Now" header and the product cards from the API.
class HomePopularSection extends StatelessWidget {
  const HomePopularSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onViewMenu,
    required this.onProductTap,
    required this.onAddTap,
    required this.addingIds,
  });

  final Future<ProductPage> future;
  final VoidCallback onRetry;
  final VoidCallback onViewMenu;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onAddTap;
  final Set<int> addingIds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Popular Right Now',
          actionLabel: 'View Menu',
          onActionTap: onViewMenu,
        ),
        const SizedBox(height: AppSpacing.md),
        FutureBuilder<ProductPage>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ProductListSkeleton(
                count: 3,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
              );
            }
            if (snapshot.hasError) {
              return ErrorRetry(
                message: 'Could not load the menu. Check your connection.',
                onRetry: onRetry,
              );
            }
            final products = snapshot.data?.products ?? [];
            if (products.isEmpty) {
              return EmptyView(
                icon: Icons.local_cafe_outlined,
                title: 'The counter is empty',
                message: 'No products are available right now.',
                actionLabel: 'Try again',
                onAction: onRetry,
              );
            }
            return Column(
              children: [
                for (var index = 0; index < products.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == products.length - 1 ? 0 : AppSpacing.md,
                    ),
                    child: ProductCard(
                      product: products[index],
                      rating: homeRatings[index % homeRatings.length],
                      heroPrefix: 'home',
                      isAdding: addingIds.contains(products[index].id),
                      onTap: () => onProductTap(products[index]),
                      onAddTap: () => onAddTap(products[index]),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
