import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Every text style used by the app, with the values from the Figma file.
/// Screens and widgets must use these instead of inline [TextStyle]s.
class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'PlusJakartaSans';

  // ---------------------------------------------------------------
  // Display / hero
  // ---------------------------------------------------------------

  /// 30/38, bold: "Welcome Back", "Create Account".
  static const TextStyle displayBig = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 38 / 30,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  /// 24/32, bold: wordmark, hero title.
  static const TextStyle displayTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  /// 24/30, bold: first line of the hero.
  static const TextStyle heroLine = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 30 / 24,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  /// 24/32, bold, emerald: second line of the hero.
  static const TextStyle heroLineAccent = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.48,
    color: AppColors.primaryColor,
  );

  // ---------------------------------------------------------------
  // Headings and titles
  // ---------------------------------------------------------------

  /// 24 bold: app header and profile name.
  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 18 bold: empty-state titles and order numbers in the sheet.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 20 semibold: large section headings ("Popular Right Now").
  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  /// 16 bold: order numbers, prices on cards.
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 18 semibold: section titles.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  /// 16 semibold: small section titles and total label.
  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  /// 14 semibold: card titles and list item names.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  /// 14 semibold, muted: secondary item titles.
  static const TextStyle cardTitleMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedTextColor,
  );

  // ---------------------------------------------------------------
  // Prices
  // ---------------------------------------------------------------

  /// 20 bold, emerald: detail screen price.
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  /// 18 bold: totals.
  static const TextStyle priceTotal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 16 bold: product card price.
  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 14 bold: line totals.
  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  // ---------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------

  /// 14 regular.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textColor,
  );

  /// 14 regular, muted: subtotal labels, secondary lines.
  static const TextStyle bodyMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.mutedTextColor,
  );

  /// 12 regular, muted: dates, captions.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.mutedTextColor,
  );

  /// 12 regular: small values.
  static const TextStyle captionStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textColor,
  );

  /// 16 regular, muted: full-screen messages.
  static const TextStyle bodyLargeMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.mutedTextColor,
  );

  /// 12 semibold, muted: category and quantity pills.
  static const TextStyle tag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedTextColor,
  );

  /// 12 bold: quantity counter value.
  static const TextStyle quantityLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  /// 14 bold, error: destructive dialog action.
  static const TextStyle dangerAction = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.errorColor,
  );

  /// 16 semibold, error: log out row.
  static const TextStyle dangerLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.errorColor,
  );

  /// 11 bold, muted: uppercase brand names.
  static const TextStyle brandCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.mutedTextColor,
  );

  /// 14 regular, muted, relaxed: product description.
  static const TextStyle description = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.6,
    color: AppColors.mutedTextColor,
  );

  /// 14 semibold: summary values.
  static const TextStyle summaryValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  /// 13 regular, muted at 90 %: greeting subtitle.
  static final TextStyle bodySubtle = bodyMuted.copyWith(
    fontSize: 13,
    color: AppColors.mutedTextColor.withValues(alpha: 0.9),
  );

  // ---------------------------------------------------------------
  // Forms
  // ---------------------------------------------------------------

  /// 12/16 semibold with tracking: input label.
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.mutedTextColor,
  );

  /// Same as [fieldLabel] but in the ink color (Register).
  static const TextStyle fieldLabelStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.textColor,
  );

  /// 14 regular: app form inputs.
  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textColor,
  );

  /// 16/24 regular: Login inputs.
  static const TextStyle inputLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: AppColors.textColor,
  );

  /// 16/24 with wide tracking: Login password.
  static const TextStyle inputPasswordLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 1.6,
    color: AppColors.textColor,
  );

  /// 14 with tracking: Register password.
  static const TextStyle inputPassword = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    letterSpacing: 0.7,
    color: AppColors.textColor,
  );

  /// 12 semibold, uppercase brand: "BREWLY" chip.
  static const TextStyle brandLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.6,
    color: AppColors.primaryColor,
  );

  /// 12/16 semibold, emerald: phone prefix.
  static const TextStyle prefixLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.primaryColor,
  );

  // ---------------------------------------------------------------
  // Buttons and small elements
  // ---------------------------------------------------------------

  /// 14/20 semibold: primary button label.
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.14,
    color: Colors.white,
  );

  /// 14/20 bold: Register primary button label.
  static const TextStyle buttonLabelBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0.14,
    color: Colors.white,
  );

  /// 14 semibold, emerald: inline links (Login / Register switch).
  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  /// 12 semibold, emerald: sheet section labels.
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  /// 10 semibold: status pills. Use copyWith for the dynamic color.
  static const TextStyle statusPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  /// 13 medium, muted: category chip.
  static const TextStyle chipLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedTextColor,
  );

  /// 13 bold, white: selected category chip.
  static const TextStyle chipLabelSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// 14 bold, white: avatar initials.
  static const TextStyle avatarInitials = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// 36 bold, dark on the emerald tint: profile avatar.
  static const TextStyle avatarInitialsLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.onAccentColor,
  );

  /// 32 bold, white: splash wordmark.
  static const TextStyle splashTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  /// 16 regular, white 70 %: splash subtitle.
  static const TextStyle splashSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: Colors.white70,
  );
}
