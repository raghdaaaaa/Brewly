import 'package:flutter/material.dart';

import '../core/constants/app_assets.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../widgets/common/primary_button.dart';
import '../widgets/welcome/welcome_brand_header.dart';
import '../widgets/welcome/welcome_hero_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WelcomeBrandHeader(),
              const WelcomeHeroCard(),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Get Started',
                iconAsset: AppAssets.welcomeCtaArrow,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginRoute);
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
