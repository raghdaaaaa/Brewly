import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/address.dart';
import '../app_text_field.dart';

/// Modal bottom sheet for viewing and editing the user's address.
class AddressBottomSheet extends StatefulWidget {
  const AddressBottomSheet({
    super.key,
    required this.initialAddress,
    required this.onSaved,
  });

  final Address initialAddress;
  final ValueChanged<Address> onSaved;

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController =
      TextEditingController(text: widget.initialAddress.firstName);
  late final TextEditingController _lastNameController =
      TextEditingController(text: widget.initialAddress.lastName);
  late final TextEditingController _streetController =
      TextEditingController(text: widget.initialAddress.street);
  late final TextEditingController _cityController =
      TextEditingController(text: widget.initialAddress.city);
  late final TextEditingController _countryController =
      TextEditingController(text: widget.initialAddress.country);

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
    final updated = Address(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
    );
    widget.onSaved(updated);
    Navigator.pop(context);
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'My Address',
                        style: AppTextStyles.sectionTitle,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: _required('first name'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        validator: _required('last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Street and building',
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                  validator: _required('street'),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'City',
                        controller: _cityController,
                        textInputAction: TextInputAction.next,
                        validator: _required('city'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Country',
                        controller: _countryController,
                        textInputAction: TextInputAction.done,
                        validator: _required('country'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    ),
                    onPressed: _save,
                    child: const Text(
                      'Save address',
                      style: AppTextStyles.buttonLabel,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
