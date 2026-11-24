import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// "Showing 1-10 of 24", the progress bar and the Load More button.
class ProductsPagination extends StatelessWidget {
  const ProductsPagination({
    super.key,
    required this.loaded,
    required this.total,
    required this.page,
    required this.pageCount,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final int loaded;
  final int total;
  final int page;
  final int pageCount;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (loaded / total).clamp(0.0, 1.0);
    final hasMore = loaded < total;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Showing 1-$loaded of $total',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.footerLabel,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Page $page of $pageCount',
                maxLines: 1,
                style: AppTextStyles.footerLabel,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.pill),
            ),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.borderColor,
              color: AppColors.primaryColor,
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Material(
                color: AppColors.softSurfaceColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.pill),
                ),
                child: InkWell(
                  onTap: isLoadingMore ? null : onLoadMore,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppRadius.pill),
                  ),
                  child: Center(
                    child: isLoadingMore
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                size: 18,
                                color: AppColors.textColor,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'Load More Roasts',
                                style: AppTextStyles.loadMore,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
