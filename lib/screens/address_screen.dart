import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/address.dart';
import '../../services/auth_service.dart';
import '../../services/dummy/dummy_data.dart';
import '../widgets/address/address_top_bar.dart';
import '../widgets/app_text_field.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, this.initialAddress});

  final Address? initialAddress;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _countryController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final address = widget.initialAddress;
    _firstNameController = TextEditingController(text: address?.firstName ?? '');
    _lastNameController = TextEditingController(text: address?.lastName ?? '');
    _streetController = TextEditingController(text: address?.street ?? '');
    _cityController = TextEditingController(text: address?.city ?? 'Cairo');
    _countryController = TextEditingController(text: address?.country ?? 'Egypt');

    if (address == null) {
      _loadSavedAddress();
    }
  }

  Future<void> _loadSavedAddress() async {
    try {
      final saved = await AuthService.instance.getAddress();
      if (saved != null && mounted) {
        setState(() {
          if (_firstNameController.text.isEmpty) _firstNameController.text = saved.firstName;
          if (_lastNameController.text.isEmpty) _lastNameController.text = saved.lastName;
          if (_streetController.text.isEmpty) _streetController.text = saved.street;
          if (_cityController.text.isEmpty) _cityController.text = saved.city;
          if (_countryController.text.isEmpty) _countryController.text = saved.country;
        });
      }
    } catch (_) {
      // Unauthenticated or network error; keep existing fields.
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final address = Address(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim().isEmpty ? 'Cairo' : _cityController.text.trim(),
      country: _countryController.text.trim().isEmpty ? 'Egypt' : _countryController.text.trim(),
    );

    try {
      await AuthService.instance.updateAddress(address);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address saved')),
      );
      Navigator.of(context).maybePop(address);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save address. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
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
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AddressTopBar(),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'My Delivery Address',
                  style: AppTextStyles.pageTitle,
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name *',
                        hint: dummyAddress.firstName,
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: _required('your first name'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name *',
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
                  label: 'Street and building *',
                  hint: dummyAddress.street,
                  controller: _streetController,
                  textInputAction: TextInputAction.next,
                  validator: _required('your street and building'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'City *',
                        hint: 'Cairo',
                        controller: _cityController,
                        textInputAction: TextInputAction.next,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.mutedTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Country',
                        hint: 'Egypt',
                        controller: _countryController,
                        enabled: false,
                        suffixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: AppColors.mutedTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onAccentColor,
                            ),
                          )
                        : const Icon(Icons.check_rounded, color: AppColors.onAccentColor, size: 20),
                    label: Text(
                      'Save address',
                      style: AppTextStyles.buttonLabelBold.copyWith(color: AppColors.onAccentColor),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
                      ),
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
