import 'package:flutter/material.dart';

import '../constants.dart';
import '../dummy_data.dart';
import '../models/product.dart';
import '../widgets/category_chip.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';

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
  // It will be replaced by ApiService.getProducts() later.
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildGreeting(),
            const SizedBox(height: 20),
            _buildSearchField(),
            const SizedBox(height: 20),
            _buildCategories(),
            const SizedBox(height: 24),
            const Text(
              'Popular Right Now',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildProductGrid(),
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
                'Good evening, Omar 👋',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'What would you like today?',
                style: TextStyle(
                  fontSize: 13,
                  color: mutedTextColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'OE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
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
        style: const TextStyle(fontSize: 14, color: textColor),
        decoration: InputDecoration(
          hintText: 'Search coffee, pastry...',
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: mutedTextColor,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              size: 18,
              color: primaryColor,
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
        separatorBuilder: (context, index) => const SizedBox(width: 8),
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

        if (visibleProducts.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.70,
          ),
          itemBuilder: (context, index) {
            final product = visibleProducts[index];
            return ProductCard(
              product: product,
              isFavorite: _favoriteIds.contains(product.id),
              onFavoriteTap: () => _toggleFavorite(product.id),
              onTap: () {
                // Pass the product to the Details screen as an argument.
                Navigator.pushNamed(
                  context,
                  detailsRoute,
                  arguments: product,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(
            Icons.search_off,
            size: 40,
            color: mutedTextColor,
          ),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
                _searchText = '';
                _searchController.clear();
              });
            },
            child: const Text(
              'Clear filters',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
