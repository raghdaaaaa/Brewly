import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../app_text_field.dart';
import '../common/primary_button.dart';
import 'phone_number_field.dart';

/// Register fields inside the white form card.
class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({
    super.key,
    required this.formKey,
    required this.displayNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.displayNameIsValid,
    required this.emailIsValid,
    required this.obscurePassword,
    required this.isLoading,
    required this.onDisplayNameChanged,
    required this.onEmailChanged,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.emailValidator,
  });

  static const String passwordHelper =
      '6-10 chars with upper, lower, digit and symbol.';

  final GlobalKey<FormState> formKey;
  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool displayNameIsValid;
  final bool emailIsValid;
  final bool obscurePassword;
  final bool isLoading;
  final ValueChanged<String> onDisplayNameChanged;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final String? Function(String?) emailValidator;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: AutofillGroup(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Display Name',
                  hint: 'Omar El-Sayed',
                  controller: displayNameController,
                  validator: (value) => Validators.requiredText(
                    value,
                    'Please enter your display name',
                  ),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  labelStyle: AppTextStyles.fieldLabelStrong,
                  onChanged: onDisplayNameChanged,
                  suffixIcon: displayNameIsValid
                      ? SvgPicture.asset(
                          AppAssets.registerInputRight,
                          width: 16.667,
                          height: 16.667,
                        )
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Email Address',
                  hint: 'omar.sayed@cairobrew.com',
                  controller: emailController,
                  validator: emailValidator,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  labelStyle: AppTextStyles.fieldLabelStrong,
                  onChanged: onEmailChanged,
                  suffixIcon: emailIsValid
                      ? SvgPicture.asset(
                          AppAssets.registerInputRight,
                          width: 16.667,
                          height: 16.667,
                        )
                      : null,
                ),
                const SizedBox(height: AppSpacing.xl),
                PhoneNumberField(controller: phoneController),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Password',
                  hint: 'Password',
                  controller: passwordController,
                  obscureText: obscurePassword,
                  validator: Validators.password,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  labelStyle: AppTextStyles.fieldLabelStrong,
                  textStyle: AppTextStyles.inputPassword,
                  helperText: passwordHelper,
                  onFieldSubmitted: (_) => onSubmit(),
                  suffixIcon: SizedBox(
                    width: 18.333,
                    height: 12.5,
                    child: SvgPicture.asset(AppAssets.registerToggleEye),
                  ),
                  onSuffixTap: onTogglePassword,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Create account',
                  onPressed: onSubmit,
                  isLoading: isLoading,
                  iconAsset: AppAssets.registerCtaArrow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
