import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'auth_emblem.dart';
import 'auth_top_bar.dart';

/// Back button, emblem and title at the top of the Login screen.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTopBar(onBack: onBack),
        const SizedBox(height: AppSpacing.lg),
        const Center(child: AuthEmblem()),
        const SizedBox(height: AppSpacing.sm),
        const Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: AppTextStyles.displayBig,
        ),
      ],
    );
  }
}
