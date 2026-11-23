import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/app_text_field.dart';
import '../widgets/common/auth_switch_link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController(text: 'Omar El-Sayed');
  final _emailController = TextEditingController(
    text: 'omar.sayed@cairobrew.com',
  );
  final _phoneController = TextEditingController(text: '10 2345 6789');

  // Sample password that satisfies the API password rule.
  final _passwordController = TextEditingController(text: 'Cairo@12');

  bool _obscurePassword = true;

  // The API password rule: 6-10 chars with upper, lower, digit and symbol.
  static final RegExp _passwordPattern = RegExp(
    r'^(?=.{6,10}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).*$',
  );

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppRadius.pill),
                      ),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.softSurfaceColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBlack05,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.registerBackArrow,
                            width: 13.333,
                            height: 13.333,
                          ),
                        ),
                      ),
                    ),
                    _brandChip(),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('Create Account', style: AppTextStyles.displayBig),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.md),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowBlack05,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _displayNameField(),
                        const SizedBox(height: AppSpacing.lg),
                        _emailField(),
                        const SizedBox(height: AppSpacing.lg),
                        _phoneField(),
                        const SizedBox(height: AppSpacing.lg),
                        _passwordField(),
                        const SizedBox(height: AppSpacing.xl),
                        _ctaButton(),
                        const SizedBox(height: AppSpacing.md),
                        AuthSwitchLink(
                          prompt: 'Already have an account?',
                          actionLabel: 'Login',
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.loginRoute,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandChip() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack05,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.registerBrandIcon,
                width: 11.25,
                height: 11.25,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text('BREWLY', style: AppTextStyles.brandLabel),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(label, style: AppTextStyles.fieldLabelStrong);
  }

  Widget _displayNameField() {
    return AppTextField(
      label: 'Display Name',
      controller: _displayNameController,
      textInputAction: TextInputAction.next,
      validator: _validateName,
      labelStyle: AppTextStyles.fieldLabelStrong,
      suffixIcon: SizedBox(
        width: 16.667,
        height: 16.667,
        child: SvgPicture.asset(AppAssets.registerInputRight),
      ),
    );
  }

  Widget _emailField() {
    return AppTextField(
      label: 'Email Address',
      controller: _emailController,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      labelStyle: AppTextStyles.fieldLabelStrong,
      suffixIcon: SizedBox(
        width: 16.667,
        height: 16.667,
        child: SvgPicture.asset(AppAssets.registerInputRight),
      ),
    );
  }

  Widget _phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Egyptian Phone Number'),
        const SizedBox(height: 6),
        Row(
          spacing: AppSpacing.sm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _countryPrefixPill(),
            Expanded(
              child: AppTextField(
                controller: _phoneController,
                textInputAction: TextInputAction.next,
                validator: _validatePhone,
                suffixIcon: SizedBox(
                  width: 11.25,
                  height: 16.5,
                  child: SvgPicture.asset(AppAssets.registerPhoneRight),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _countryPrefixPill() {
    return Container(
      height: AppSizes.inputHeight,
      decoration: const BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 17),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('+20', style: AppTextStyles.prefixLabel),
            const SizedBox(width: 2),
            SizedBox(
              width: AppSpacing.sm,
              child: SvgPicture.asset(AppAssets.registerPhonePrefix),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return AppTextField(
      label: 'Password',
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
      textStyle: AppTextStyles.inputPassword,
      labelStyle: AppTextStyles.fieldLabelStrong,
      helperText: '6-10 characters with upper, lower, digit and symbol.',
      onSuffixTap: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      suffixIcon: SizedBox(
        width: 18.333,
        height: 12.5,
        child: SvgPicture.asset(AppAssets.registerToggleEye),
      ),
    );
  }

  Widget _ctaButton() {
    return InkWell(
      onTap: _register,
      child: Container(
        height: AppSizes.buttonHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack10,
              blurRadius: 6,
              spreadRadius: -4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              child: Text(
                'Create account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonLabelBold,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 13.333,
              child: SvgPicture.asset(AppAssets.registerCtaArrow),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (!_passwordPattern.hasMatch(value)) {
      return 'Use 6-10 characters with upper, lower, digit and symbol';
    }
    return null;
  }
}
