import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../common/app_search_field.dart';
import 'filter_chip_bar.dart';
import 'products_list_header.dart';
import 'sort_row.dart';

/// Header, search, filter chips and sort row of the Products List.
class ProductsListControls extends StatelessWidget {
  const ProductsListControls({
    super.key,
    required this.searchController,
    required this.categoryName,
    required this.brandName,
    required this.title,
    required this.sortLabel,
    required this.count,
    required this.onShare,
    required this.onSearch,
    required this.onClearCategory,
    required this.onClearBrand,
    required this.onLocationTap,
    required this.onRoastTap,
    required this.onSortTap,
  });

  final TextEditingController searchController;
  final String? categoryName;
  final String? brandName;
  final String title;
  final String sortLabel;
  final int count;
  final VoidCallback onShare;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearCategory;
  final VoidCallback onClearBrand;
  final VoidCallback onLocationTap;
  final VoidCallback onRoastTap;
  final VoidCallback onSortTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            0,
          ),
          child: ProductsListHeader(onShare: onShare, title: title),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            0,
          ),
          child: AppSearchField(
            controller: searchController,
            hint: 'Specialty Single Origin',
            showClear: true,
            onSubmitted: onSearch,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: FilterChipBar(
            categoryName: categoryName,
            brandName: brandName,
            onClearCategory: onClearCategory,
            onClearBrand: onClearBrand,
            onLocationTap: onLocationTap,
            onRoastTap: onRoastTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: SortRow(sortLabel: sortLabel, count: count, onTap: onSortTap),
        ),
      ],
    );
  }
}
