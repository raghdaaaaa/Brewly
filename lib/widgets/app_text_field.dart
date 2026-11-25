import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// The label is drawn above the field and the field grows with its validation
/// error or helper text, so messages never overlap the next field.
enum AppTextFieldVariant {
  /// Beige fill used by Register, Checkout and My Address.
  filled,

  /// White field with a soft shadow used by Login.
  card,
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.helperText,
    this.textInputAction,
    this.textStyle = AppTextStyles.input,
    this.labelStyle = AppTextStyles.fieldLabel,
    this.variant = AppTextFieldVariant.filled,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  final String? label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? helperText;
  final TextInputAction? textInputAction;
  final TextStyle textStyle;
  final TextStyle labelStyle;
  final AppTextFieldVariant variant;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? _buildSuffix() {
    if (suffixIcon == null) {
      return null;
    }
    if (onSuffixTap == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 4, right: 14),
        child: suffixIcon,
      );
    }
    return InkWell(
      onTap: onSuffixTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: suffixIcon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      style: textStyle,
      enabled: enabled,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      cursorColor: AppColors.primaryColor,
      textAlignVertical: TextAlignVertical.center,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: textStyle.copyWith(color: AppColors.mutedTextColor),
        filled: true,
        fillColor: variant == AppTextFieldVariant.card
            ? AppColors.cardColor
            : AppColors.softSurfaceColor,
        isDense: true,
        constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 16,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: prefixIcon,
              ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        suffixIcon: _buildSuffix(),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        helperText: helperText,
        helperStyle: AppTextStyles.caption,
        helperMaxLines: 3,
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.errorColor,
        ),
        errorMaxLines: 3,
        border: _border(
          variant == AppTextFieldVariant.card
              ? AppColors.borderColor
              : Colors.transparent,
          variant == AppTextFieldVariant.card ? 1 : 0,
        ),
        enabledBorder: _border(
          variant == AppTextFieldVariant.card
              ? AppColors.borderColor
              : Colors.transparent,
          variant == AppTextFieldVariant.card ? 1 : 0,
        ),
        focusedBorder: _border(AppColors.primaryColor, 1.5),
        disabledBorder: _border(Colors.transparent, 0),
        errorBorder: _border(AppColors.errorColor, 1),
        focusedErrorBorder: _border(AppColors.errorColor, 1.5),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: labelStyle),
          const SizedBox(height: 6),
        ],
        field,
      ],
    );
  }
}
