import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../auth/auth_emblem.dart';

class WelcomeBrandHeader extends StatelessWidget {
  const WelcomeBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.md),
      child: Center(child: AuthEmblem()),
    );
  }
}
