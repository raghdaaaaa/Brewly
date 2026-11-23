import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
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
      body: SingleChildScrollView(
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
              const Text(
                'Create Account',
                style: AppTextStyles.displayBig,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
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
                      const SizedBox(height: AppSpacing.sm),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Container(
                    width: 128,
                    height: AppSpacing.xs,
                    decoration: const BoxDecoration(
                      color: AppColors.subtleBottomPillColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _fieldInput({
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    TextInputAction? action,
    String? Function(String?)? validator,
    bool showRightIcon = false,
    double rightIconSize = 16.667,
    String? rightIconPath,
  }) {
    return Container(
      height: AppSizes.inputHeight,
      decoration: const BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 17,
              ),
              child: TextFormField(
                controller: controller,
                obscureText: obscure,
                textInputAction: action,
                validator: validator,
                style: AppTextStyles.input,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: AppTextStyles.input,
                ),
              ),
            ),
          ),
          if (showRightIcon && rightIconPath != null)
            SizedBox(
              width: 14,
              child: Center(
                child: SvgPicture.asset(
                  rightIconPath,
                  width: rightIconSize,
                  height: rightIconSize,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _displayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Display Name'),
        const SizedBox(height: 6),
        _fieldInput(
          controller: _displayNameController,
          action: TextInputAction.next,
          validator: _validateName,
          showRightIcon: true,
          rightIconPath: AppAssets.registerInputRight,
        ),
      ],
    );
  }

  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Email Address'),
        const SizedBox(height: 6),
        _fieldInput(
          controller: _emailController,
          action: TextInputAction.next,
          validator: _validateEmail,
          showRightIcon: true,
          rightIconPath: AppAssets.registerInputRight,
        ),
      ],
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
          children: [
            _countryPrefixPill(),
            Expanded(
              child: _fieldInput(
                controller: _phoneController,
                action: TextInputAction.next,
                validator: _validatePhone,
                showRightIcon: true,
                rightIconPath: AppAssets.registerPhoneRight,
                rightIconSize: 11.25,
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
          spacing: 6,
          children: [
            const Text(
              '🇪🇬',
              style: TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Password'),
        const SizedBox(height: 6),
        Container(
          height: AppSizes.inputHeight,
          decoration: const BoxDecoration(
            color: AppColors.softSurfaceColor,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 17, 48, 17),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    style: AppTextStyles.inputPassword,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: AppTextStyles.input,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                child: SizedBox(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  child: SvgPicture.asset(AppAssets.registerToggleEye),
                ),
              ),
            ],
          ),
        ),
      ],
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
    return null;
  }
}
