import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Gray placeholder cards shown while a product list is loading.
class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({
    super.key,
    this.count = 3,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
  });

  final int count;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: count,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.productCardMinHeight,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.productCardImage,
            height: AppSizes.productCardImage,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 70, height: 14),
                SizedBox(height: AppSpacing.sm),
                _SkeletonLine(width: 130),
                SizedBox(height: AppSpacing.sm),
                _SkeletonLine(width: 100, height: 10),
                SizedBox(height: AppSpacing.md),
                _SkeletonLine(width: 60, height: 16),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: AppSizes.addButton,
            height: AppSizes.addButton,
            decoration: const BoxDecoration(
              color: AppColors.skeletonColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width, this.height = 12});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeletonColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
