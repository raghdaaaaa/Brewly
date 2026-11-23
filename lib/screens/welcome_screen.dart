import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBrandHeader(),
            _heroCard(),
            _getStartedButton(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  width: 128,
                  height: AppSpacing.xs,
                  decoration: const BoxDecoration(
                    color: AppColors.subtleBottomPillColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBrandHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryShadow20,
                    blurRadius: 6,
                    spreadRadius: -1,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: AppColors.primaryShadow20,
                    blurRadius: 4,
                    spreadRadius: -2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: SvgPicture.asset(AppAssets.welcomeSteamIcon),
              ),
            ),
            Positioned(
              top: -4,
              right: 10,
              child: Row(
                children: [
                  Container(
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    width: AppSpacing.sm,
                    height: AppSpacing.sm,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Brewly', style: AppTextStyles.displayTitle),
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack05,
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 256,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-0.5, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1.3123,
                      heightFactor: 1.0,
                      child: Image.asset(
                        AppAssets.welcomeHeroImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const ColoredBox(
                    color: AppColors.cardColor,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.5, 1.0],
                          colors: [
                            AppColors.heroFadeStart,
                            AppColors.heroFadeEnd,
                          ],
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Artisanal Coffee & Pastries,',
                    style: AppTextStyles.heroLine,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Delivered Fresh.',
                    style: AppTextStyles.heroLineAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
      },
      child: Container(
        height: AppSizes.buttonHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryShadow25,
              blurRadius: 6,
              spreadRadius: -4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Get Started', style: AppTextStyles.buttonLabel),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 13.333,
              child: SvgPicture.asset(AppAssets.welcomeCtaArrow),
            ),
          ],
        ),
      ),
    );
  }
}
