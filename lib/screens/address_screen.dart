import 'package:flutter/material.dart';

import '../../core/errors/app_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/address.dart';
import '../../services/auth_service.dart';
import '../widgets/address/address_top_bar.dart';
import '../widgets/app_text_field.dart';
import '../widgets/error_retry.dart';
import '../widgets/loading_indicator.dart';

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
  bool _isLoading = false;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    final address = widget.initialAddress ?? AuthService.savedAddress.value;
    _firstNameController = TextEditingController(text: address?.firstName ?? '');
    _lastNameController = TextEditingController(text: address?.lastName ?? '');
    _streetController = TextEditingController(text: address?.street ?? '');
    _cityController = TextEditingController(text: address?.city ?? '');
    _countryController = TextEditingController(
      text: (address != null && address.country.isNotEmpty)
          ? address.country
          : 'Egypt',
    );

    if (widget.initialAddress == null && AuthService.instance.isLoggedIn) {
      _loadSavedAddress();
    }
  }

  Future<void> _loadSavedAddress() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final saved = await AuthService.instance.getAddress();
      if (!mounted) return;
      if (saved != null) {
        _firstNameController.text = saved.firstName;
        _lastNameController.text = saved.lastName;
        _streetController.text = saved.street;
        _cityController.text = saved.city;
        if (saved.country.isNotEmpty) {
          _countryController.text = saved.country;
        }
      }
      setState(() {
        _isLoading = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Could not load your saved address. Please try again.';
        _isLoading = false;
      });
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
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);
    final address = Address(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim().isEmpty
          ? 'Egypt'
          : _countryController.text.trim(),
    );

    try {
      final saved = await AuthService.instance.updateAddress(address);
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address saved')),
      );
      Navigator.of(context).maybePop(saved);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save address. Please try again.'),
        ),
      );
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
        child: _isLoading
            ? const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: AddressTopBar(),
                  ),
                  Expanded(child: LoadingIndicator()),
                ],
              )
            : _loadError != null
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: AddressTopBar(),
                      ),
                      Expanded(
                        child: ErrorRetry(
                          message: _loadError!,
                          onRetry: _loadSavedAddress,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
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
                                  hint: 'First name',
                                  controller: _firstNameController,
                                  textInputAction: TextInputAction.next,
                                  validator: _required('your first name'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppTextField(
                                  label: 'Last name *',
                                  hint: 'Last name',
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
                            hint: 'Street and building',
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
                                  validator: _required('your city'),
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
                                  : const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.onAccentColor,
                                      size: 20,
                                    ),
                              label: Text(
                                'Save address',
                                style: AppTextStyles.buttonLabelBold.copyWith(
                                  color: AppColors.onAccentColor,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(AppRadius.pill),
                                  ),
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
