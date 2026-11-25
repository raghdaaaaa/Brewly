import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/basket_service.dart';
import '../services/product_service.dart';
import '../widgets/products/product_details_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    this.product,
    this.productId,
    this.heroPrefix = 'home',
    this.productService,
    this.basketService,
  });

  /// The product passed by Home / Products List through the named route.
  final Product? product;

  /// Used when only the id is available; the screen then loads the product.
  final int? productId;

  /// Keeps the Hero tag unique to the screen the product was opened from.
  final String heroPrefix;

  final ProductService? productService;
  final BasketService? basketService;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductService _productService =
      widget.productService ?? ProductService();
  late final BasketService _basketService =
      widget.basketService ?? BasketService();

  Product? _product;
  Future<Product>? _productFuture;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    if (_product == null && widget.productId != null) {
      _productFuture = _fetchProduct();
    }
  }

  Future<Product> _fetchProduct() async {
    final product = await _productService.getProduct(widget.productId!);
    if (mounted) {
      setState(() => _product = product);
    }
    return product;
  }

  void _retryLoad() {
    if (widget.productId == null) {
      return;
    }
    setState(() {
      _product = null;
      _productFuture = _fetchProduct();
    });
  }

  void _toggleFavorite() => setState(() => _isFavorite = !_isFavorite);

  void _decreaseQuantity() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
  }

  void _increaseQuantity() {
    if (_quantity >= 99) return;
    setState(() => _quantity++);
  }

  void _share() => _showMessage('Share is not available yet');

  Future<void> _addToCart() async {
    final product = _product;
    if (product == null || _isAdding) {
      return;
    }
    if (!AuthService.instance.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please log in to add items to your cart.'),
          action: SnackBarAction(
            label: 'Log in',
            onPressed: () {
              if (!mounted) {
                return;
              }
              Navigator.of(context).pushNamed(AppRoutes.loginRoute);
            },
          ),
        ),
      );
      return;
    }

    setState(() => _isAdding = true);
    try {
      await _basketService.addQuantity(product: product, quantity: _quantity);
      if (!mounted) {
        return;
      }
      _showMessage('Added to cart');
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMessage('Could not add this item. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _close() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    return ProductDetailsView(
      product: _product,
      productFuture: _productFuture,
      heroPrefix: widget.heroPrefix,
      quantity: _quantity,
      isFavorite: _isFavorite,
      isAdding: _isAdding,
      onShare: _share,
      onRetry: _retryLoad,
      onClose: _close,
      onFavoriteTap: _toggleFavorite,
      onDecrease: _decreaseQuantity,
      onIncrease: _increaseQuantity,
      onAdd: _addToCart,
    );
  }
}
