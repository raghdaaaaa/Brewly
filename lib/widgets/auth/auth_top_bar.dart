import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import 'auth_back_button.dart';
import 'register_brand_chip.dart';

class AuthTopBar extends StatelessWidget {
  const AuthTopBar({
    super.key,
    required this.onBack,
    this.showBrandChip = false,
  });

  final VoidCallback onBack;
  final bool showBrandChip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AuthBackButton(
          onTap: onBack,
          iconAsset: showBrandChip
              ? AppAssets.registerBackArrow
              : AppAssets.backArrow,
          iconWidth: showBrandChip ? 13.333 : 9.8125,
          iconHeight: showBrandChip ? 13.333 : 16.6667,
        ),
        if (showBrandChip) const RegisterBrandChip(),
        const SizedBox(width: 44),
      ],
    );
  }
}
