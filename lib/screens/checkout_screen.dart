import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/delivery_method.dart';
import '../services/dummy/dummy_data.dart';
import '../widgets/app_text_field.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // The address form is prefilled with the saved address (dummy for now).
  late final TextEditingController _firstNameController =
      TextEditingController(text: dummyAddress.firstName);
  late final TextEditingController _lastNameController =
      TextEditingController(text: dummyAddress.lastName);
  late final TextEditingController _streetController =
      TextEditingController(text: dummyAddress.street);
  late final TextEditingController _cityController =
      TextEditingController(text: dummyAddress.city);
  late final TextEditingController _countryController =
      TextEditingController(text: dummyAddress.country);

  // The delivery method selected with the radio buttons.
  int _selectedMethodId = dummyDeliveryMethods.first.id;

  DeliveryMethod get _selectedMethod {
    return dummyDeliveryMethods.firstWhere(
      (method) => method.id == _selectedMethodId,
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

  String _nextOrderId() {
    if (dummyOrders.isEmpty) {
      return 'ORD-1001';
    }
    final last = int.tryParse(dummyOrders.last.id.split('-').last);
    return last == null ? dummyOrders.last.id : 'ORD-${last + 1}';
  }

  void _placeOrder() {
    // Stop if a field is empty.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dummy: empty the basket after the order.
    // The API step will call POST /api/Orders and DELETE /api/Basket.
    dummyBasketItems.clear();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.orderSuccessRoute,
      (route) => false,
      arguments: _nextOrderId(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Address.
              const Text(
                'Delivery address',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'First name',
                              hint: 'Omar',
                              controller: _firstNameController,
                              textInputAction: TextInputAction.next,
                              validator: _required('your first name'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              label: 'Last name',
                              hint: 'El-Sayed',
                              controller: _lastNameController,
                              textInputAction: TextInputAction.next,
                              validator: _required('your last name'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: 'Street and building',
                        hint: '14 Gezira St, Apt 4B',
                        controller: _streetController,
                        textInputAction: TextInputAction.next,
                        validator: _required('your street'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'City',
                              hint: 'Cairo',
                              controller: _cityController,
                              textInputAction: TextInputAction.next,
                              validator: _required('your city'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              label: 'Country',
                              hint: 'Egypt',
                              controller: _countryController,
                              textInputAction: TextInputAction.done,
                              validator: _required('your country'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 2. Delivery method.
              const Text(
                'Delivery method',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Column(
                  children: [
                    for (final method in dummyDeliveryMethods)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMethodId = method.id;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                method.id == _selectedMethodId
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 18,
                                color: method.id == _selectedMethodId
                                    ? AppColors.primaryColor
                                    : AppColors.mutedTextColor,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method.shortName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.cardTitle,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${method.description} · '
                                      '${method.deliveryTime}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                method.cost == 0
                                    ? 'Free'
                                    : '${method.cost.toStringAsFixed(0)} EGP',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Order summary.
              const Text(
                'Order summary',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Subtotal',
                        '${_subtotal.toStringAsFixed(0)} EGP',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildSummaryRow(
                        'Delivery',
                        _selectedMethod.cost == 0
                            ? 'Free'
                            : '${_selectedMethod.cost.toStringAsFixed(0)} EGP',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Divider(height: 1),
                      ),
                      Row(
                        children: [
                          const Text('Total', style: AppTextStyles.subtitle),
                          const Spacer(),
                          Expanded(
                            child: Text(
                              '${_total.toStringAsFixed(0)} EGP',
                              style: AppTextStyles.priceTotal,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Main button.
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        'Place order',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Small validator used by every address field.
  String? Function(String?) _required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      return null;
    };
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodyMuted),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.summaryValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
