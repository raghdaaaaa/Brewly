import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/category.dart';
import '../services/product_service.dart';
import '../widgets/app_header.dart';
import '../widgets/common/app_search_field.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/explore/explore_categories_grid.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, this.productService});

  final ProductService? productService;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ProductService _productService =
      widget.productService ?? ProductService();

  final _searchController = TextEditingController();

  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    _categoriesFuture = _productService.getCategories();
  }

  void _search(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.productsListRoute,
      arguments: {'search': query},
    );
    _searchController.clear();
  }

  void _openCategory(Category category) {
    Navigator.pushNamed(
      context,
      AppRoutes.productsListRoute,
      arguments: {
        'categoryId': category.id,
        'categoryName': category.name,
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            const AppHeaderTop(),
            const SizedBox(height: AppSpacing.lg),
            const Text('Explore Brewly', style: AppTextStyles.screenTitle),
            const SizedBox(height: AppSpacing.lg),
            AppSearchField(
              controller: _searchController,
              hint: 'Search categories, roast styles, roasters..',
              onSubmitted: _search,
              onFilterTap: () => _showMessage('Coming soon'),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Categories', style: AppTextStyles.sectionHeading),
            const SizedBox(height: AppSpacing.md),
            FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }
                if (snapshot.hasError) {
                  return ErrorRetry(
                    message: 'Could not load the categories.',
                    onRetry: () => setState(_loadCategories),
                  );
                }
                final categories = snapshot.data ?? [];
                if (categories.isEmpty) {
                  return const EmptyView(
                    icon: Icons.grid_view_rounded,
                    title: 'Nothing to explore yet',
                    message: 'New categories will appear here soon.',
                  );
                }
                return ExploreCategoriesGrid(
                  categories: categories,
                  onTap: _openCategory,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
