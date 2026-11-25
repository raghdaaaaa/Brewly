import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
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
