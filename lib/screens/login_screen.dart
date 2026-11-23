import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/app_header.dart';
import '../widgets/common/auth_switch_link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(
    text: 'omar.sayed@cairobrew.com',
  );

  // Sample password that satisfies the API password rule.
  final _passwordController = TextEditingController(text: 'Cairo@12');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
    }
  }

  String? _requiredEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    return null;
  }

  String? _requiredPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              child: AppHeaderBack(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _emblem(),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayBig,
                ),
              ],
            ),
            // Figma: title to the first field label.
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _emailCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _passwordCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _ctaButton(),
                      const SizedBox(height: AppSpacing.md),
                      AuthSwitchLink(
                        prompt: "Don't have an account?",
                        actionLabel: 'Create account',
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.registerRoute);
                        },
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

  Widget _emblem() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowBlack10,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 19.5,
                height: 19.5,
                child: SvgPicture.asset(AppAssets.emblemIcon),
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowBlack05,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SizedBox(
            width: 12.833,
            height: 12.833,
            child: SvgPicture.asset(AppAssets.emblemRing),
          ),
        ),
      ],
    );
  }

  Widget _fieldCard(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSpacing.sm),
        field,
      ],
    );
  }

  Widget _emailCard() {
    return _fieldCard(
      'Email address',
      Container(
        height: AppSizes.inputHeight,
        decoration: const BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack05,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SizedBox(
                width: 28.667,
                child: SvgPicture.asset(AppAssets.emailLeft),
              ),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  validator: _requiredEmail,
                  style: AppTextStyles.inputLarge,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'omar.sayed@cairobrew.com',
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 15,
                child: SvgPicture.asset(AppAssets.emailRight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordCard() {
    return _fieldCard(
      'Password',
      Container(
        height: AppSizes.inputHeight,
        decoration: const BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack05,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SizedBox(
                width: 25.333,
                child: SvgPicture.asset(AppAssets.passwordLeft),
              ),
              Expanded(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _requiredPassword,
                  textInputAction: TextInputAction.done,
                  style: AppTextStyles.inputPasswordLarge,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Password',
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
                child: SizedBox(
                  width: 18.333,
                  height: 12.5,
                  child: SvgPicture.asset(AppAssets.toggleEye),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ctaButton() {
    return InkWell(
      onTap: _login,
      child: Container(
        height: AppSizes.buttonHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack10,
              blurRadius: 15,
              spreadRadius: -3,
            ),
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
            const Text('Login', style: AppTextStyles.buttonLabel),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 13.333,
              child: SvgPicture.asset(AppAssets.ctaArrow),
            ),
          ],
        ),
      ),
    );
  }
}
