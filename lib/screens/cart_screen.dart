import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/basket.dart';
import '../services/basket_service.dart';
import '../widgets/cart/cart_checkout_button.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/cart_summary_card.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.onBrowseMenu, this.basketService});

  final VoidCallback onBrowseMenu;
  final BasketService? basketService;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final BasketService _basketService =
      widget.basketService ?? BasketService();

  bool _isLoading = true;
  bool _isInternalUpdate = false;
  String? _errorMessage;
  List<BasketItem> _items = [];

  @override
  void initState() {
    super.initState();
    BasketService.itemCount.addListener(_onExternalBasketChanged);
    _loadBasket();
  }

  @override
  void dispose() {
    BasketService.itemCount.removeListener(_onExternalBasketChanged);
    super.dispose();
  }

  void _onExternalBasketChanged() {
    if (!mounted || _isInternalUpdate) return;
    _loadBasket(showSpinner: false);
  }

  Future<void> _loadBasket({bool showSpinner = true}) async {
    if (showSpinner && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    _isInternalUpdate = true;
    try {
      final basket = await _basketService.getBasket();
      if (!mounted) return;
      setState(() {
        _items = List.of(basket.items);
        _errorMessage = null;
        _isLoading = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not load your basket. Please try again.';
        _isLoading = false;
      });
    } finally {
      _isInternalUpdate = false;
    }
  }

  double get _subtotal {
    double sum = 0;
    for (final item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  Future<void> _updateQuantity(BasketItem item, int nextQuantity) async {
    if (nextQuantity < 0 || nextQuantity > 99) return;
    final previousQuantity = item.quantity;
    final previousIndex = _items.indexOf(item);
    setState(() {
      if (nextQuantity == 0) {
        _items.remove(item);
      } else {
        item.quantity = nextQuantity;
      }
    });
    _isInternalUpdate = true;
    try {
      final basket = await _basketService.updateItemQuantity(
        productId: item.productId,
        quantity: nextQuantity,
      );
      if (!mounted) return;
      setState(() {
        _items = List.of(basket.items);
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        if (nextQuantity == 0) {
          _items.insert(previousIndex, item);
        } else {
          item.quantity = previousQuantity;
        }
      });
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (nextQuantity == 0) {
          _items.insert(previousIndex, item);
        } else {
          item.quantity = previousQuantity;
        }
      });
      _showMessage('Could not update item quantity. Please try again.');
    } finally {
      _isInternalUpdate = false;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _confirmClearCart() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('All items will be removed from your cart.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                _isInternalUpdate = true;
                try {
                  await _basketService.clearBasket();
                  if (!mounted) return;
                  setState(() {
                    _items.clear();
                  });
                } on AppException catch (error) {
                  if (!mounted) return;
                  _showMessage(error.message);
                } catch (_) {
                  if (!mounted) return;
                  _showMessage('Could not clear cart. Please try again.');
                } finally {
                  _isInternalUpdate = false;
                }
              },
              child: const Text('Clear', style: AppTextStyles.dangerAction),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your Basket',
                      style: AppTextStyles.displayTitle,
                    ),
                  ),
                  if (!_isLoading && _errorMessage == null && _items.isNotEmpty)
                    IconButton(
                      tooltip: 'Clear cart',
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.errorColor,
                        size: 20,
                      ),
                      onPressed: _confirmClearCart,
                    ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const LoadingIndicator()
                  : _errorMessage != null
                  ? ErrorRetry(message: _errorMessage!, onRetry: _loadBasket)
                  : _items.isEmpty
                  ? EmptyView(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Your cart is empty',
                      message: 'Add a coffee or a pastry from the menu.',
                      actionLabel: 'Browse menu',
                      onAction: widget.onBrowseMenu,
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        AppSpacing.xxl,
                      ),
                      children: [
                        for (final item in _items) ...[
                          CartItemCard(
                            item: item,
                            onIncrease: () =>
                                _updateQuantity(item, item.quantity + 1),
                            onDecrease: () =>
                                _updateQuantity(item, item.quantity - 1),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        CartSummaryCard(subtotal: _subtotal),
                        const SizedBox(height: AppSpacing.lg),
                        CartCheckoutButton(
                          total: _subtotal,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.checkoutRoute,
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
