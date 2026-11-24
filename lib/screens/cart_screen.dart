import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/basket.dart';
import '../services/basket_service.dart';
import '../widgets/app_header.dart';
import '../widgets/cart/cart_checkout_button.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/cart_summary_card.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/loading_indicator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.onBrowseMenu,
    this.basketService,
  });

  /// Called by the empty state button to switch to the Home tab.
  final VoidCallback onBrowseMenu;
  final BasketService? basketService;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final BasketService _basketService =
      widget.basketService ?? BasketService();

  bool _isLoading = true;
  List<BasketItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadBasket();
  }

  Future<void> _loadBasket() async {
    try {
      final basket = await _basketService.getBasket();
      if (!mounted) return;
      setState(() {
        _items = basket.items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _isLoading = false;
      });
    }
  }

  double get _subtotal {
    double sum = 0;
    for (final item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  void _increaseQuantity(BasketItem item) {
    if (item.quantity >= 99) return;
    setState(() {
      item.quantity++;
    });
    _basketService.addItem(productId: item.id, quantity: item.quantity).ignore();
  }

  void _decreaseQuantity(BasketItem item) {
    if (item.quantity <= 1) return;
    setState(() {
      item.quantity--;
    });
    _basketService.addItem(productId: item.id, quantity: item.quantity).ignore();
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
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _items.clear();
                });
                _basketService.clearBasket().ignore();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppHeaderTop(),
            ),
            Expanded(
              child: _isLoading
                  ? const LoadingIndicator()
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
                            100,
                          ),
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Your Basket',
                                    style: AppTextStyles.displayTitle,
                                  ),
                                ),
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
                            const SizedBox(height: AppSpacing.md),
                            for (final item in _items) ...[
                              CartItemCard(
                                item: item,
                                onIncrease: () => _increaseQuantity(item),
                                onDecrease: () => _decreaseQuantity(item),
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
