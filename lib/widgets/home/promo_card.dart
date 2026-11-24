import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// The local promo card on Home. Its height grows with the text scale.
class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 156),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.promoImage,
                fit: BoxFit.cover,
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.promoScrimStart,
                      AppColors.promoScrimStart,
                      AppColors.promoScrimEnd,
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 14,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.pill),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 12,
                          color: AppColors.onAccentColor,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text('BREWLY PICK', style: AppTextStyles.promoTag),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Artisan Morning Roast &\nSourdough Croissant',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.promoTitle,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Freshly baked in Zamalek • Ethiopian beans',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.promoSubtitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onExplore,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(AppRadius.pill),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(AppRadius.pill),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'Explore menu',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.promoButton,
                                ),
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
