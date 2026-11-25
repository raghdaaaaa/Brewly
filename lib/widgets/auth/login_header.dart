import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'auth_emblem.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: AuthEmblem()),
        SizedBox(height: AppSpacing.lg),
        Text(
          'Welcome Back',
          textAlign: TextAlign.left,
          style: AppTextStyles.authHeaderTitle,
        ),
      ],
    );
  }
}
