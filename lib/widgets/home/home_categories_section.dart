import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/category.dart';
import '../error_retry.dart';
import '../loading_indicator.dart';
import '../common/section_header.dart';
import 'category_circle.dart';

/// "Categories" header and the horizontal circle row from the API.
class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onSeeAll,
    required this.onCategoryTap,
  });

  final Future<List<Category>> future;
  final VoidCallback onRetry;
  final VoidCallback onSeeAll;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Categories',
          actionLabel: 'See all',
          onActionTap: onSeeAll,
        ),
        const SizedBox(height: AppSpacing.sm),
        FutureBuilder<List<Category>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.hasError) {
              return ErrorRetry(
                message: 'Could not load the categories.',
                onRetry: onRetry,
              );
            }
            final categories = snapshot.data ?? [];
            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < categories.length; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.md),
                    CategoryCircle(
                      category: categories[index],
                      onTap: () => onCategoryTap(categories[index]),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
