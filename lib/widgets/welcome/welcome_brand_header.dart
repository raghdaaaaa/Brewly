import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../common/brewly_brand_lockup.dart';

class WelcomeBrandHeader extends StatelessWidget {
  const WelcomeBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(child: BrewlyBrandLockup()),
    );
  }
}
