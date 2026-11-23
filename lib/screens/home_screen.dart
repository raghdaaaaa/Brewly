import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/product.dart';
import '../services/dummy/dummy_data.dart';
import '../widgets/app_header.dart';
import '../widgets/common/product_grid.dart';
import '../widgets/category_chip.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchFormKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchText = '';

  // Favorite products (local only, not saved on the server).
  final Set<int> _favoriteIds = {};

  // The future used by the FutureBuilder.
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fake "network" call, so the loading spinner is visible.
  // It will be replaced by the product service later.
  Future<List<Product>> _loadProducts() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return dummyProducts;
  }

  void _retry() {
    setState(() {
      _productsFuture = _loadProducts();
    });
  }

  // Category + search filter, done locally on the dummy list.
  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.categoryName == _selectedCategory;
      final matchesSearch = _searchText.isEmpty ||
          product.name.toLowerCase().contains(_searchText.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _search() {
    if (_searchFormKey.currentState!.validate()) {
      setState(() {
        _searchText = _searchController.text.trim();
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _toggleFavorite(int productId) {
    setState(() {
      if (_favoriteIds.contains(productId)) {
        _favoriteIds.remove(productId);
      } else {
        _favoriteIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            const AppHeaderTop(),
            const SizedBox(height: AppSpacing.md),
            _buildGreeting(),
            const SizedBox(height: AppSpacing.xl),
            _buildSearchField(),
            const SizedBox(height: AppSpacing.xl),
            _buildCategories(),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Popular Right Now',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildProductGrid(),
            const SizedBox(height: AppSpacing.lg),
            Align(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.productsListRoute);
                },
                child: const Text('See all products', style: AppTextStyles.link),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Greeting + avatar.
  Widget _buildGreeting() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good evening, Omar ðŸ‘‹',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.pageTitle,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'What would you like today?',
                style: AppTextStyles.bodySubtle,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('OE', style: AppTextStyles.avatarInitials),
          ),
        ),
      ],
    );
  }

  // Search form (validation: not empty).
  Widget _buildSearchField() {
    return Form(
      key: _searchFormKey,
      child: TextFormField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (_) => _search(),
        style: AppTextStyles.input,
        decoration: InputDecoration(
          hintText: 'Search coffee, pastry...',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.mutedTextColor,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              size: 18,
              color: AppColors.primaryColor,
            ),
            onPressed: _search,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Type something to search';
          }
          return null;
        },
      ),
    );
  }

  // Horizontal category chips.
  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dummyCategories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = dummyCategories[index];
          return CategoryChip(
            label: category.name,
            isSelected: _selectedCategory == category.name,
            onTap: () {
              setState(() {
                _selectedCategory = category.name;
              });
            },
          );
        },
      ),
    );
  }

  // The product grid, with loading and error states.
  Widget _buildProductGrid() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        // 1. Loading.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 200, child: LoadingIndicator());
        }

        // 2. Error.
        if (snapshot.hasError) {
          return SizedBox(
            height: 220,
            child: ErrorRetry(
              message: 'Could not load the menu. Check your connection.',
              onRetry: _retry,
            ),
          );
        }

        // 3. Data.
        final visibleProducts = _filterProducts(snapshot.data ?? []);
        return ProductGrid(
          products: visibleProducts,
          favorites: _favoriteIds,
          onFavoriteTap: _toggleFavorite,
          onTap: (product) {
            Navigator.pushNamed(
              context,
              AppRoutes.detailsRoute,
              arguments: {'product': product, 'heroPrefix': 'home'},
            );
          },
        );
      },
    );
  }
}
