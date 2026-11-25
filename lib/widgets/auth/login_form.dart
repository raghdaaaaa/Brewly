import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../app_text_field.dart';
import '../common/primary_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailIsValid,
    required this.obscurePassword,
    required this.isLoading,
    required this.onEmailChanged,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool emailIsValid;
  final bool obscurePassword;
  final bool isLoading;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Container(
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
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Email address',
                hint: 'omar.sayed@cairobrew.com',
                controller: emailController,
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: onEmailChanged,
                suffixIcon: emailIsValid
                    ? SvgPicture.asset(
                        AppAssets.emailRight,
                        width: 15,
                        height: 15,
                      )
                    : null,
                prefixIcon: SizedBox(
                  width: 28.667,
                  height: 13.333,
                  child: SvgPicture.asset(AppAssets.emailLeft),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'Password',
                hint: 'Password',
                controller: passwordController,
                obscureText: obscurePassword,
                validator: (value) => Validators.requiredText(
                  value,
                  'Please enter your password',
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => onSubmit(),
                prefixIcon: SizedBox(
                  width: 25.333,
                  height: 17.5,
                  child: SvgPicture.asset(AppAssets.passwordLeft),
                ),
                suffixIcon: SizedBox(
                  width: 18.333,
                  height: 12.5,
                  child: SvgPicture.asset(AppAssets.toggleEye),
                ),
                onSuffixTap: onTogglePassword,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Login',
                onPressed: onSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
