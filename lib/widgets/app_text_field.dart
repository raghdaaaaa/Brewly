import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

/// The single text-field style used by the whole app.
///
/// The field grows with its validation error or helper text, so nothing is
/// clipped when the keyboard is open or a message is shown.
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
        padding: const EdgeInsets.only(right: 14),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: labelStyle),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          style: textStyle,
          cursorColor: AppColors.primaryColor,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textStyle.copyWith(color: AppColors.mutedTextColor),
            filled: true,
            fillColor: AppColors.softSurfaceColor,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
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
            helperMaxLines: 2,
            errorStyle: AppTextStyles.caption.copyWith(
              color: AppColors.errorColor,
            ),
            errorMaxLines: 3,
            border: _border(Colors.transparent, 0),
            enabledBorder: _border(Colors.transparent, 0),
            focusedBorder: _border(AppColors.primaryColor, 1.5),
            errorBorder: _border(AppColors.errorColor, 1),
            focusedErrorBorder: _border(AppColors.errorColor, 1.5),
          ),
        ),
      ],
    );
  }
}
