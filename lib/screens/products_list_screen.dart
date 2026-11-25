import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/product.dart';
import '../models/product_page.dart';
import '../services/basket_service.dart';
import '../services/product_service.dart';
import '../widgets/products/current_order_bar.dart';
import '../widgets/products/products_list_controls.dart';
import '../widgets/products/products_results.dart';
import '../widgets/products/sort_sheet.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({
    super.key,
    this.initialSearch = '',
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.productService,
    this.basketService,
  });

  final String initialSearch;
  final int? categoryId;
  final String? categoryName;
  final int? brandId;
  final String? brandName;
  final ProductService? productService;
  final BasketService? basketService;

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  static const int _pageSize = 10;

  late final ProductService _productService =
      widget.productService ?? ProductService();
  late final BasketService _basketService =
      widget.basketService ?? BasketService();
  late final Listenable _basketListenable = Listenable.merge([
    BasketService.itemCount,
    BasketService.total,
  ]);

  final _searchController = TextEditingController();
  final List<Product> _products = [];
  final Set<int> _addingIds = {};

  late Future<ProductPage> _pageFuture;
  late String _sort;

  int? _categoryId;
  String? _categoryName;
  int? _brandId;
  String? _brandName;

  int _total = 0;
  int _page = 1;
  int _pageCount = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialSearch;
    _categoryId = widget.categoryId;
    _categoryName = widget.categoryName;
    _brandId = widget.brandId;
    _brandName = widget.brandName;
    _sort = ProductService.sortPriceAsc;
    _pageFuture = _loadFirstPage();
    _basketService.getBasket().ignore();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<ProductPage> _loadFirstPage() {
    _products.clear();
    _total = 0;
    _page = 1;
    _pageCount = 1;
    return _fetchPage(1);
  }

  Future<ProductPage> _fetchPage(int pageIndex) async {
    final page = await _productService.getProducts(
      pageIndex: pageIndex,
      pageSize: _pageSize,
      search: _searchController.text,
      sort: _sort,
      brandId: _brandId,
      categoryId: _categoryId,
    );
    if (mounted) {
      setState(() {
        if (pageIndex == 1) {
          _products
            ..clear()
            ..addAll(page.products);
        } else {
          _products.addAll(page.products);
        }
        _total = page.count;
        _page = pageIndex;
        _pageCount = page.count == 0 ? 1 : (page.count / _pageSize).ceil();
      });
    }
    return page;
  }

  void _reload() {
    FocusScope.of(context).unfocus();
    setState(() {
      _pageFuture = _loadFirstPage();
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _products.length >= _total) {
      return;
    }
    setState(() => _isLoadingMore = true);
    try {
      await _fetchPage(_page + 1);
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = error is AppException
          ? error.message
          : 'Could not load more products. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: 'Retry', onPressed: _loadMore),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _pickSort() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => SortSheet(selected: _sort),
    );
    if (!mounted) {
      return;
    }
    if (selected == null || selected == _sort) {
      return;
    }
    setState(() => _sort = selected);
    _reload();
  }

  void _clearCategory() {
    _categoryId = null;
    _categoryName = null;
    _reload();
  }

  void _clearBrand() {
    _brandId = null;
    _brandName = null;
    _reload();
  }

  void _clearFilters() {
    _searchController.clear();
    _categoryId = null;
    _categoryName = null;
    _brandId = null;
    _brandName = null;
    _reload();
  }

  void _openProduct(Product product) {
    Navigator.pushNamed(
      context,
      AppRoutes.detailsRoute,
      arguments: {'product': product, 'heroPrefix': 'list'},
    );
  }

  Future<void> _addToBasket(Product product) async {
    setState(() => _addingIds.add(product.id));
    try {
      await _basketService.addQuantity(product: product, quantity: 1);
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String get _sortLabel => _sort == ProductService.sortPriceDesc
      ? 'Price high to low'
      : 'Price low to high';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ProductsListControls(
              searchController: _searchController,
              categoryName: _categoryName,
              brandName: _brandName,
              title: _categoryName ?? _brandName ?? 'Products',
              sortLabel: _sortLabel,
              count: _total,
              onShare: () => _showMessage('Coming soon'),
              onSearch: (value) => _reload(),
              onClearCategory: _clearCategory,
              onClearBrand: _clearBrand,
              onLocationTap: () => _showMessage('Coming soon'),
              onRoastTap: () => _showMessage('Coming soon'),
              onSortTap: _pickSort,
            ),
            Expanded(
              child: ProductsResults(
                future: _pageFuture,
                products: _products,
                total: _total,
                page: _page,
                pageCount: _pageCount,
                isLoadingMore: _isLoadingMore,
                addingIds: _addingIds,
                onRetry: _reload,
                onLoadMore: _loadMore,
                onTap: _openProduct,
                onAdd: _addToBasket,
                onClearFilters: _clearFilters,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _basketListenable,
        builder: (context, child) {
          return CurrentOrderBar(
            total: BasketService.total.value,
            itemCount: BasketService.itemCount.value,
            onTap: () => _showMessage('Your basket is in the Cart tab.'),
          );
        },
      ),
    );
  }
}
