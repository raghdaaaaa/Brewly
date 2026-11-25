import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../auth/auth_emblem.dart';

class BrewlyBrandLockup extends StatelessWidget {
  const BrewlyBrandLockup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 40, height: 40, child: FittedBox(child: AuthEmblem())),
        SizedBox(width: AppSpacing.sm),
        Text('Brewly', style: AppTextStyles.brandLockupName),
      ],
    );
  }
}
