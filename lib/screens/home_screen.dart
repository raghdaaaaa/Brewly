import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_spacing.dart';
import '../models/address.dart';
import '../models/brand.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/product_page.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/basket_service.dart';
import '../services/dummy/dummy_data.dart';
import '../services/product_service.dart';
import '../widgets/app_header.dart';
import '../widgets/common/app_search_field.dart';
import '../widgets/home/delivery_card.dart';
import '../widgets/home/home_brands_section.dart';
import '../widgets/home/home_categories_section.dart';
import '../widgets/home/home_greeting.dart';
import '../widgets/home/home_popular_section.dart';
import '../widgets/home/promo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.productService,
    this.basketService,
  });

  final ProductService? productService;
  final BasketService? basketService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductService _productService =
      widget.productService ?? ProductService();
  late final BasketService _basketService =
      widget.basketService ?? BasketService();

  final _searchController = TextEditingController();
  final Set<int> _addingIds = {};

  late Future<List<Category>> _categoriesFuture;
  late Future<List<Brand>> _brandsFuture;
  late Future<ProductPage> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadBrands();
    _loadProducts();
    if (AuthService.instance.isLoggedIn &&
        AuthService.savedAddress.value == null) {
      AuthService.instance.getAddress().ignore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    _categoriesFuture = _productService.getCategories();
  }

  void _loadBrands() {
    _brandsFuture = _productService.getBrands();
  }

  void _loadProducts() {
    _productsFuture = _productService.getProducts(pageSize: 4);
  }

  String _firstName(User? user) {
    final displayName = user?.displayName.trim() ?? '';
    if (displayName.isEmpty) {
      return 'there';
    }
    return displayName.split(' ').first;
  }

  String _formatAddress(Address? address) {
    if (address == null) {
      return 'Add delivery address';
    }
    final parts = [
      address.street.trim(),
      address.city.trim(),
      address.country.trim(),
    ].where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return 'Add delivery address';
    }
    return parts.join(', ');
  }

  void _openProducts([Map<String, Object?>? arguments]) {
    Navigator.pushNamed(
      context,
      AppRoutes.productsListRoute,
      arguments: arguments,
    );
  }

  void _search(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }
    _openProducts({'search': query});
    _searchController.clear();
  }

  void _openCategory(Category category) {
    _openProducts({
      'categoryId': category.id,
      'categoryName': category.name,
    });
  }

  void _openBrand(Brand brand) {
    _openProducts({
      'brandId': brand.id,
      'brandName': brand.name,
    });
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      AppRoutes.detailsRoute,
      arguments: {'product': product, 'heroPrefix': 'home'},
    );
  }

  Future<void> _addToBasket(Product product) async {
    setState(() => _addingIds.add(product.id));
    try {
      await _basketService.addItem(productId: product.id);
      if (!mounted) {
        return;
      }
      _showMessage('${product.name} added to your order');
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() => _addingIds.remove(product.id));
      }
    }
  }

  Future<void> _claimPromo() async {
    await Clipboard.setData(const ClipboardData(text: 'BREW20'));
    if (!mounted) {
      return;
    }
    _showMessage('Promo code BREW20 copied');
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeaderTop(),
              const SizedBox(height: AppSpacing.lg),
              ValueListenableBuilder<User?>(
                valueListenable: AuthService.currentUserNotifier,
                builder: (context, user, child) {
                  return HomeGreeting(
                    name: _firstName(user),
                    points: dummyLoyaltyPoints,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              ValueListenableBuilder<Address?>(
                valueListenable: AuthService.savedAddress,
                builder: (context, address, child) {
                  return DeliveryCard(
                    address: _formatAddress(address),
                    onTap: () => Navigator.pushNamed(context, AppRoutes.addressRoute),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppSearchField(
                controller: _searchController,
                hint: 'Search specialty beans, croissants, coffee...',
                onSubmitted: _search,
                onFilterTap: () => _showMessage('Coming soon'),
              ),
              const SizedBox(height: AppSpacing.lg),
              PromoCard(onClaim: _claimPromo),
              const SizedBox(height: AppSpacing.lg),
              HomeCategoriesSection(
                future: _categoriesFuture,
                onRetry: () => setState(_loadCategories),
                onSeeAll: () => _openProducts(),
                onCategoryTap: _openCategory,
              ),
              const SizedBox(height: AppSpacing.lg),
              HomeBrandsSection(
                future: _brandsFuture,
                onRetry: () => setState(_loadBrands),
                onBrandTap: _openBrand,
              ),
              const SizedBox(height: AppSpacing.lg),
              HomePopularSection(
                future: _productsFuture,
                onRetry: () => setState(_loadProducts),
                onViewMenu: () => _openProducts(),
                onProductTap: _openProduct,
                onAddTap: _addToBasket,
                addingIds: _addingIds,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
