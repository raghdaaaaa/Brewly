import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

class AuthEmblem extends StatelessWidget {
  const AuthEmblem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(AppAssets.emblemIcon, width: 18, height: 18),
      ),
    );
  }
}
