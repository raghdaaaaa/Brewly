import 'package:flutter/material.dart';

import '../constants.dart';
import '../dummy_data.dart';
import '../models/basket.dart';
import '../widgets/loading_indicator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.onBrowseMenu});

  // Called by the empty state button, so Main can switch to the Home tab.
  final VoidCallback onBrowseMenu;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Simple loading flag (a real API call will be used later).
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBasket();
  }

  Future<void> _loadBasket() async {
    // Fake network delay, so the spinner is visible.
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Subtotal of all the items.
  double get _subtotal {
    double sum = 0;
    for (final item in dummyBasketItems) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double get _deliveryFee => dummyDeliveryMethods.first.cost;

  double get _total => _subtotal + _deliveryFee;

  // Ask before removing everything.
  void _confirmClearCart() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('All items will be removed from your cart.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  dummyBasketItems.clear();
                });
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: errorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          // Only show the delete icon when there is something to delete.
          if (!_isLoading && dummyBasketItems.isNotEmpty)
            IconButton(
              tooltip: 'Clear cart',
              icon: const Icon(Icons.delete_outline, color: errorColor),
              onPressed: _confirmClearCart,
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : dummyBasketItems.isEmpty
              ? _buildEmptyState()
              : _buildCart(),
    );
  }

  // Empty cart.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: softSurfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: mutedTextColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a coffee or a pastry from the menu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: mutedTextColor),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: widget.onBrowseMenu,
                child: const Text('Browse menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cart with items.
  Widget _buildCart() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: dummyBasketItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildItemCard(dummyBasketItems[index]);
            },
          ),
        ),
        _buildSummary(),
      ],
    );
  }

  Widget _buildItemCard(BasketItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Small product image.
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 72,
              height: 72,
              child: Image.network(
                item.pictureUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: softSurfaceColor,
                    child: const Icon(
                      Icons.local_cafe,
                      size: 24,
                      color: mutedTextColor,
                    ),
                  );
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return Container(color: softSurfaceColor);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name, unit price, quantity and line total.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.price.toStringAsFixed(0)} EGP each',
                  style: const TextStyle(
                    fontSize: 12,
                    color: mutedTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStepper(item),
                    const Spacer(),
                    Text(
                      '${item.lineTotal.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Small − quantity + counter.
  Widget _buildStepper(BasketItem item) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: softSurfaceDeepColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStepButton(Icons.remove, () {
            if (item.quantity > 1) {
              setState(() {
                item.quantity--;
              });
            }
          }),
          SizedBox(
            width: 22,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          _buildStepButton(Icons.add, () {
            if (item.quantity < 10) {
              setState(() {
                item.quantity++;
              });
            }
          }),
        ],
      ),
    );
  }

  Widget _buildStepButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 28,
        height: 32,
        child: Icon(icon, size: 14, color: textColor),
      ),
    );
  }

  // Bottom summary + Checkout button.
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '${_subtotal.toStringAsFixed(0)} EGP'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Delivery',
            _deliveryFee == 0 ? 'Free' : '${_deliveryFee.toStringAsFixed(0)} EGP',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                '${_total.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, checkoutRoute);
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: mutedTextColor),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
