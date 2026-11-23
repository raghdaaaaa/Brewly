import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../dummy_data.dart';
import '../models/delivery_method.dart';
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

  void _placeOrder() {
    // Stop if a field is empty.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dummy: empty the basket after the order.
    // The API step will call POST /api/Orders and DELETE /api/Basket.
    dummyBasketItems.clear();

    // Success message (the API step will show the real response).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your order has been placed!')),
    );

    // Back to Main, with the Orders tab open.
    Navigator.pushNamedAndRemoveUntil(
      context,
      homeRoute,
      (route) => false,
      arguments: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Address.
              const Text(
                'Delivery address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                          const SizedBox(width: 12),
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
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Street and building',
                        hint: '14 Gezira St, Apt 4B',
                        controller: _streetController,
                        textInputAction: TextInputAction.next,
                        validator: _required('your street'),
                      ),
                      const SizedBox(height: 16),
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
                          const SizedBox(width: 12),
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
              const SizedBox(height: 24),

              // 2. Delivery method.
              const Text(
                'Delivery method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    for (final method in dummyDeliveryMethods)
                      RadioListTile<int>(
                        value: method.id,
                        // ignore: deprecated_member_use
                        groupValue: _selectedMethodId,
                        // ignore: deprecated_member_use
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedMethodId = value;
                          });
                        },
                        activeColor: primaryColor,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          method.shortName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          '${method.deliveryTime} · '
                          '${method.cost == 0 ? 'Free' : '${method.cost.toStringAsFixed(0)} EGP'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: mutedTextColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Order summary.
              const Text(
                'Order summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Subtotal',
                        '${_subtotal.toStringAsFixed(0)} EGP',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        'Delivery',
                        _selectedMethod.cost == 0
                            ? 'Free'
                            : '${_selectedMethod.cost.toStringAsFixed(0)} EGP',
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Main button.
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 18),
                    SizedBox(width: 8),
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
