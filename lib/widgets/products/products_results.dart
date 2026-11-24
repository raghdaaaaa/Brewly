import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/product.dart';
import '../../models/product_page.dart';
import '../common/empty_view.dart';
import '../error_retry.dart';
import '../common/product_list_skeleton.dart';
import '../product_card.dart';
import '../product_thumbnail.dart';
import 'products_pagination.dart';

/// The FutureBuilder body of the Products List: loading, error, empty or the
/// cards plus the pagination footer.
class ProductsResults extends StatelessWidget {
  const ProductsResults({
    super.key,
    required this.future,
    required this.products,
    required this.total,
    required this.page,
    required this.pageCount,
    required this.isLoadingMore,
    required this.addingIds,
    required this.onRetry,
    required this.onLoadMore,
    required this.onTap,
    required this.onAdd,
    required this.onClearFilters,
  });

  final Future<ProductPage> future;
  final List<Product> products;
  final int total;
  final int page;
  final int pageCount;
  final bool isLoadingMore;
  final Set<int> addingIds;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final ValueChanged<Product> onTap;
  final ValueChanged<Product> onAdd;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductPage>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProductListSkeleton(count: 4);
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          return ErrorRetry(
            message: error is AppException
                ? error.message
                : 'Could not load the products. Please try again.',
            onRetry: onRetry,
          );
        }
        if (products.isEmpty) {
          return EmptyView(
            icon: Icons.search_off_rounded,
            title: 'No roasts found',
            message: 'Try another search or clear the active filters.',
            actionLabel: 'Clear filters',
            onAction: onClearFilters,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          itemCount: products.length + 1,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index == products.length) {
              return ProductsPagination(
                loaded: products.length,
                total: total,
                page: page,
                pageCount: pageCount,
                isLoadingMore: isLoadingMore,
                onLoadMore: onLoadMore,
              );
            }
            final product = products[index];
            return ProductCard(
              product: product,
              tagTone: ProductTagTone.accent,
              brandUppercase: true,
              heroPrefix: 'list',
              isAdding: addingIds.contains(product.id),
              onTap: () => onTap(product),
              onAddTap: () => onAdd(product),
            );
          },
        );
      },
    );
  }
}
