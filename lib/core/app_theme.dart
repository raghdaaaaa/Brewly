import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle displayBig = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 38 / 30,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  static const TextStyle displayTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  static const TextStyle heroLine = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 30 / 24,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  static const TextStyle heroLineGreen = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.48,
    color: AppColors.primaryColor,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.accentColor,
          surface: AppColors.cardColor,
          error: AppColors.errorColor,
          onPrimary: Colors.white,
          onSecondary: AppColors.onAccentColor,
          onSurface: AppColors.textColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
      );
}
