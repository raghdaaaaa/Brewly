import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// A section title with an optional link, trailing count or subtitle.
///
/// Used for "Categories", "FEATURED ROASTERS & BAKERIES" and
/// "Popular Right Now" so the spacing and text styles stay identical.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.titleStyle = AppTextStyles.sectionHeading,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
    this.trailingLabel,
  });

  final String title;
  final TextStyle titleStyle;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.headerAction),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailingLabel != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  trailingLabel!,
                  style: AppTextStyles.eyebrow,
                  maxLines: 1,
                ),
              ],
              if (actionLabel != null) ...[
                const SizedBox(width: AppSpacing.sm),
                InkWell(
                  onTap: onActionTap,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.md,
                    ),
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.sectionLink,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: AppTextStyles.sectionSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
