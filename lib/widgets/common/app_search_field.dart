import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hint,
    this.onSubmitted,
    this.onFilterTap,
    this.showClear = false,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final bool showClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.searchHeight),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            autofocus: autofocus,
            textInputAction: TextInputAction.search,
            onSubmitted: onSubmitted,
            style: AppTextStyles.input,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.searchHint,
              hintMaxLines: 1,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.mutedTextColor,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppSizes.headerAction,
                minHeight: AppSizes.headerAction,
              ),
              suffixIcon: _suffix(value),
              suffixIconConstraints: const BoxConstraints(
                minWidth: AppSizes.headerAction,
                minHeight: AppSizes.headerAction,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget? _suffix(TextEditingValue value) {
    if (onFilterTap != null) {
      return _FilterButton(onTap: onFilterTap!);
    }
    if (!showClear || value.text.isEmpty) {
      return null;
    }
    return IconButton(
      onPressed: () {
        controller.clear();
        onSubmitted?.call('');
      },
      tooltip: 'Clear search',
      icon: const Icon(
        Icons.close_rounded,
        size: 18,
        color: AppColors.mutedTextColor,
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.headerAction,
      height: AppSizes.headerAction,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Center(
          child: Container(
            width: AppSizes.filterButton,
            height: AppSizes.filterButton,
            decoration: const BoxDecoration(
              color: AppColors.softSurfaceColor,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
            ),
            child: const Icon(
              Icons.tune_rounded,
              size: 18,
              color: AppColors.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
