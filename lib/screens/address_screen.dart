import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../models/address.dart';
import '../../services/dummy/dummy_data.dart';
import '../widgets/app_text_field.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, this.initialAddress});

  final Address? initialAddress;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController = TextEditingController(
    text: widget.initialAddress?.firstName ?? '',
  );
  late final TextEditingController _lastNameController = TextEditingController(
    text: widget.initialAddress?.lastName ?? '',
  );
  late final TextEditingController _streetController = TextEditingController(
    text: widget.initialAddress?.street ?? '',
  );
  late final TextEditingController _cityController = TextEditingController(
    text: widget.initialAddress?.city ?? '',
  );
  late final TextEditingController _countryController = TextEditingController(
    text: widget.initialAddress?.country ?? '',
  );

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address saved')),
    );
  }

  String? Function(String?) _required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Address')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        hint: dummyAddress.firstName,
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: _required('your first name'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        hint: dummyAddress.lastName,
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
                  hint: dummyAddress.street,
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                  validator: _required('your street'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'City',
                        hint: dummyAddress.city,
                        controller: _cityController,
                        textInputAction: TextInputAction.next,
                        validator: _required('your city'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Country',
                        hint: dummyAddress.country,
                        controller: _countryController,
                        textInputAction: TextInputAction.done,
                        validator: _required('your country'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
