import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
    this.actionStyle = AppTextStyles.link,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;
  final TextStyle actionStyle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: AppTextStyles.bodyMuted),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          child: Text(actionLabel, style: actionStyle),
        ),
      ],
    );
  }
}
