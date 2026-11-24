import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// White onboarding card with the hero photo and the two-line promise.
class WelcomeHeroCard extends StatelessWidget {
  const WelcomeHeroCard({super.key});

  /// The Figma frame shows 256 dp of photo inside a 358 dp card.
  static const double _heroAspectRatio = 358 / 256;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack05,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: _heroAspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.welcomeHeroImage, fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.0, 0.5],
                      colors: [AppColors.heroFadeStart, AppColors.heroFadeEnd],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Artisanal Coffee & Pastries,',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroLine,
                ),
                SizedBox(height: 2),
                Text(
                  'Delivered Fresh.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heroLineAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
