import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/delivery_method.dart';

/// Card selector for choosing a delivery method.
class DeliveryMethodCard extends StatelessWidget {
  const DeliveryMethodCard({
    super.key,
    required this.methods,
    required this.selectedMethodId,
    required this.onSelect,
  });

  final List<DeliveryMethod> methods;
  final int selectedMethodId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.delivery_dining_outlined,
              size: 22,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Delivery Method',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final method in methods) ...[
          _MethodTile(
            method: method,
            isSelected: method.id == selectedMethodId,
            onTap: () => onSelect(method.id),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final DeliveryMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFree = method.cost == 0;
    final isSelfPick = method.shortName.toLowerCase().contains('pick') ||
        method.description.toLowerCase().contains('pick') ||
        isFree;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.borderColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          method.shortName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                      if (isSelfPick) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softSurfaceColor,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Text(
                            'Self Pick',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedTextColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isFree ? 'Free' : '${method.cost.toStringAsFixed(0)} EGP',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textColor,
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
