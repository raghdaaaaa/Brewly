import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/category.dart';
import 'category_tile.dart';

/// Two-column categories grid used by Explore.
class ExploreCategoriesGrid extends StatelessWidget {
  const ExploreCategoriesGrid({
    super.key,
    required this.categories,
    required this.onTap,
  });

  final List<Category> categories;
  final ValueChanged<Category> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: AppSizes.categoryTileHeight,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryTile(
          category: category,
          onTap: () => onTap(category),
        );
      },
    );
  }
}
