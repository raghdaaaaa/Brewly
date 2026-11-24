import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/address.dart';
import '../models/basket.dart';
import '../models/delivery_method.dart';
import '../models/order.dart';
import '../services/auth_service.dart';
import '../services/basket_service.dart';
import '../services/order_service.dart';
import '../widgets/checkout/checkout_summary_card.dart';
import '../widgets/checkout/checkout_top_bar.dart';
import '../widgets/checkout/delivery_address_card.dart';
import '../widgets/checkout/delivery_method_card.dart';
import '../widgets/checkout/place_order_button.dart';
import '../widgets/common/empty_view.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    this.orderService,
    this.basketService,
  });

  final OrderService? orderService;
  final BasketService? basketService;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final OrderService _orderService = widget.orderService ?? OrderService();
  late final BasketService _basketService =
      widget.basketService ?? BasketService();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController =
      TextEditingController();
  late final TextEditingController _lastNameController =
      TextEditingController();
  late final TextEditingController _streetController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _countryController =
      TextEditingController(text: 'Egypt');

  bool _saveAsDefault = true;
  bool _isLoading = true;
  bool _isPlacing = false;
  String? _errorMessage;

  Order? _createdOrder;
  CustomerBasket _basket = CustomerBasket.empty();
  List<DeliveryMethod> _methods = [];
  int? _selectedMethodId;

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  void _applySavedAddress(Address saved) {
    if (_firstNameController.text.isEmpty) {
      _firstNameController.text = saved.firstName;
    }
    if (_lastNameController.text.isEmpty) {
      _lastNameController.text = saved.lastName;
    }
    if (_streetController.text.isEmpty) {
      _streetController.text = saved.street;
    }
    if (_cityController.text.isEmpty) {
      _cityController.text = saved.city;
    }
    if (saved.country.isNotEmpty) {
      _countryController.text = saved.country;
    }
  }

  Future<void> _loadCheckoutData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final cachedAddress = AuthService.savedAddress.value;
    if (cachedAddress != null) {
      _applySavedAddress(cachedAddress);
    }
    try {
      final basketFuture = _basketService.getBasket();
      final methodsFuture = _orderService.getDeliveryMethods();
      final basket = await basketFuture;
      final methods = await methodsFuture;

      if (AuthService.instance.isLoggedIn) {
        try {
          final saved = await AuthService.instance.getAddress();
          if (saved != null && mounted) {
            _applySavedAddress(saved);
          }
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() {
        _basket = basket;
        _methods = methods;
        if (methods.isNotEmpty) {
          final hasSelected = methods.any((m) => m.id == _selectedMethodId);
          _selectedMethodId = hasSelected ? _selectedMethodId : methods.first.id;
        } else {
          _selectedMethodId = null;
        }
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
        _errorMessage = 'Could not load checkout details. Please try again.';
        _isLoading = false;
      });
    }
  }

  DeliveryMethod? get _selectedMethod {
    if (_methods.isEmpty) return null;
    return _methods.firstWhere(
      (m) => m.id == _selectedMethodId,
      orElse: () => _methods.first,
    );
  }

  double get _subtotal => _basket.total;

  double get _total => _subtotal + (_selectedMethod?.cost ?? 0);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate() || _isPlacing) {
      return;
    }

    final methodId = _selectedMethod?.id;
    if (methodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery method.')),
      );
      return;
    }

    setState(() => _isPlacing = true);

    final address = Address(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
    );

    try {
      var order = _createdOrder;
      if (order == null) {
        order = await _orderService.createOrder(
          deliveryMethodId: methodId,
          shippingAddress: address,
        );
        if (!mounted) return;
        setState(() => _createdOrder = order);

        if (_saveAsDefault && AuthService.instance.isLoggedIn) {
          try {
            await AuthService.instance.updateAddress(address);
          } catch (_) {}
        }
      }

      try {
        await _basketService.clearBasket();
      } on AppException catch (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Order created, but the basket could not be cleared: '
              '${error.message}',
            ),
          ),
        );
        return;
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order created, but the basket could not be cleared. '
              'Please retry.',
            ),
          ),
        );
        return;
      }

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.orderSuccessRoute,
        (route) => false,
        arguments: {
          'orderId': order.id,
          'total': order.total > 0 ? order.total : _total,
        },
      );
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not place your order. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod = _selectedMethod;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: CheckoutTopBar(),
            ),
            Expanded(
              child: _isLoading
                  ? const LoadingIndicator()
                  : _errorMessage != null
                      ? ErrorRetry(
                          message: _errorMessage!,
                          onRetry: _loadCheckoutData,
                        )
                      : _basket.items.isEmpty
                          ? EmptyView(
                              icon: Icons.shopping_bag_outlined,
                              title: 'Your cart is empty',
                              message: 'Add items to your cart before checking out.',
                              actionLabel: 'Go back',
                              onAction: () => Navigator.of(context).maybePop(),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg,
                                AppSpacing.md,
                                AppSpacing.lg,
                                AppSpacing.xl,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    DeliveryAddressCard(
                                      firstNameController: _firstNameController,
                                      lastNameController: _lastNameController,
                                      streetController: _streetController,
                                      cityController: _cityController,
                                      countryController: _countryController,
                                      saveAsDefault: _saveAsDefault,
                                      onSaveDefaultChanged: (val) {
                                        setState(
                                          () => _saveAsDefault = val ?? false,
                                        );
                                      },
                                      onEditTap: () async {
                                        final updated =
                                            await Navigator.pushNamed(
                                          context,
                                          AppRoutes.addressRoute,
                                        );
                                        if (updated is Address && mounted) {
                                          setState(() {
                                            _firstNameController.text =
                                                updated.firstName;
                                            _lastNameController.text =
                                                updated.lastName;
                                            _streetController.text =
                                                updated.street;
                                            _cityController.text = updated.city;
                                            _countryController.text =
                                                updated.country;
                                          });
                                        }
                                      },
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                    if (selectedMethod != null) ...[
                                      DeliveryMethodCard(
                                        methods: _methods,
                                        selectedMethodId: selectedMethod.id,
                                        onSelect: (id) => setState(
                                          () => _selectedMethodId = id,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.lg),
                                      CheckoutSummaryCard(
                                        subtotal: _subtotal,
                                        deliveryMethodName:
                                            selectedMethod.shortName,
                                        deliveryCost: selectedMethod.cost,
                                        total: _total,
                                      ),
                                      const SizedBox(height: AppSpacing.lg),
                                    ],
                                    PlaceOrderButton(
                                      total: _total,
                                      isPlacing: _isPlacing,
                                      onTap: _placeOrder,
                                    ),
                                  ],
                                ),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
