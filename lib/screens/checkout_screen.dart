import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/address.dart';
import '../models/delivery_method.dart';
import '../services/basket_service.dart';
import '../services/dummy/dummy_data.dart';
import '../services/order_service.dart';
import '../widgets/checkout/checkout_summary_card.dart';
import '../widgets/checkout/checkout_top_bar.dart';
import '../widgets/checkout/delivery_address_card.dart';
import '../widgets/checkout/delivery_method_card.dart';
import '../widgets/checkout/place_order_button.dart';

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
  bool _isPlacing = false;

  List<DeliveryMethod> _methods = dummyDeliveryMethods;
  int _selectedMethodId = dummyDeliveryMethods.first.id;

  @override
  void initState() {
    super.initState();
    _loadDeliveryMethods();
  }

  Future<void> _loadDeliveryMethods() async {
    try {
      final methods = await _orderService.getDeliveryMethods();
      if (!mounted) return;
      if (methods.isNotEmpty) {
        setState(() {
          _methods = methods;
          _selectedMethodId = methods.first.id;
        });
      }
    } catch (_) {
      // Keep dummy methods if network/endpoint fails.
    }
  }

  DeliveryMethod get _selectedMethod {
    return _methods.firstWhere(
      (m) => m.id == _selectedMethodId,
      orElse: () => _methods.first,
    );
  }

  double get _subtotal {
    double sum = 0;
    for (final item in dummyBasketItems) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double get _total => _subtotal + _selectedMethod.cost;

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

    setState(() => _isPlacing = true);

    final address = Address(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
    );

    try {
      final order = await _orderService.createOrder(
        deliveryMethodId: _selectedMethodId,
        shippingAddress: address,
      );
      final orderId = order.id

      await _basketService.clearBasket();
      clearDummyBasket();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.orderSuccessRoute,
        (route) => false,
        arguments: {
          'orderId': orderId,
          'total': _total,
        },
      );
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DeliveryAddressCard(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        streetController: _streetController,
                        cityController: _cityController,
                        countryController: _countryController,
                        saveAsDefault: _saveAsDefault,
                        onSaveDefaultChanged: (val) {
                          setState(() => _saveAsDefault = val ?? false);
                        },
                        onEditTap: () {
                          Navigator.pushNamed(context, AppRoutes.addressRoute);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      DeliveryMethodCard(
                        methods: _methods,
                        selectedMethodId: _selectedMethodId,
                        onSelect: (id) => setState(() => _selectedMethodId = id),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      CheckoutSummaryCard(
                        subtotal: _subtotal,
                        deliveryMethodName: _selectedMethod.shortName,
                        deliveryCost: _selectedMethod.cost,
                        total: _total,
                      ),
                      const SizedBox(height: AppSpacing.xl),
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
