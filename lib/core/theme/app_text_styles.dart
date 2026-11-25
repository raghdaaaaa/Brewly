import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'PlusJakartaSans';

  // Display
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
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.2,
    color: AppColors.textColor,
  );

  static const TextStyle heroLineAccent = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.2,
    color: AppColors.primaryColor,
  );

  // Headings
  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle profileName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle cardTitleMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedTextColor,
  );

  // Prices
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  static const TextStyle priceTotal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle priceMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textColor,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle captionStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textColor,
  );

  static const TextStyle bodyLargeMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle tag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle quantityLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textColor,
  );

  static const TextStyle dangerAction = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.errorColor,
  );

  static const TextStyle dangerLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.errorColor,
  );

  static const TextStyle brandCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle description = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.6,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle summaryValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static final TextStyle bodySubtle = bodyMuted.copyWith(
    fontSize: 13,
    color: AppColors.mutedTextColor.withValues(alpha: 0.9),
  );

  // Forms
  static const TextStyle fieldLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle fieldLabelStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.textColor,
  );

  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textColor,
  );

  static const TextStyle inputLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: AppColors.textColor,
  );

  static const TextStyle inputPasswordLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 1.6,
    color: AppColors.textColor,
  );

  static const TextStyle inputPassword = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    letterSpacing: 0.7,
    color: AppColors.textColor,
  );

  static const TextStyle brandLockupName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 20 / 16,
    letterSpacing: 0.2,
    color: AppColors.primaryColor,
  );

  static const TextStyle brandLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.6,
    color: AppColors.primaryColor,
  );

  static const TextStyle prefixLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
    color: AppColors.primaryColor,
  );

  // Buttons
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.14,
    color: Colors.white,
  );

  static const TextStyle buttonLabelBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0.14,
    color: Colors.white,
  );

  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );

  static const TextStyle statusPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle chipLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle chipLabelSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle avatarInitials = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle avatarInitialsLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.onAccentColor,
  );

  static const TextStyle splashTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: Colors.white70,
  );

  // Home / Explore / Products List
  static const TextStyle wordmark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    height: 13 / 11,
    letterSpacing: 0.8,
    color: AppColors.primaryColor,
  );

  static const TextStyle locationTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 26 / 20,
    letterSpacing: -0.2,
    color: AppColors.textColor,
  );

  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 36 / 28,
    letterSpacing: -0.6,
    color: AppColors.textColor,
  );

  static const TextStyle greeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 28 / 22,
    letterSpacing: -0.4,
    color: AppColors.textColor,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 26 / 20,
    letterSpacing: -0.3,
    color: AppColors.textColor,
  );

  static const TextStyle sectionLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    color: AppColors.primaryColor,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle eyebrowCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 14 / 11,
    letterSpacing: 0.6,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle points = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 18 / 13,
    color: AppColors.onAccentColor,
  );

  static const TextStyle deliveryEyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 14 / 10,
    letterSpacing: 0.5,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle deliveryAddress = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.textColor,
  );

  static const TextStyle promoTag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    height: 14 / 10,
    letterSpacing: 0.4,
    color: AppColors.onAccentColor,
  );

  static const TextStyle promoTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 26 / 20,
    letterSpacing: -0.4,
    color: Colors.white,
  );

  static const TextStyle promoSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    color: Color(0xB3FFFFFF),
  );

  static const TextStyle promoButton = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    color: Colors.white,
  );

  static const TextStyle categoryName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textColor,
  );

  static const TextStyle categoryTileTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: -0.3,
    color: Colors.white,
  );

  static const TextStyle brandChip = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle brandChipCaps = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 13 / 10,
    letterSpacing: 0.6,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle productTag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9,
    fontWeight: FontWeight.w600,
    height: 12 / 9,
    color: AppColors.textColor,
  );

  static const TextStyle rating = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    color: AppColors.textColor,
  );

  static const TextStyle productName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    letterSpacing: -0.2,
    color: AppColors.textColor,
  );

  static const TextStyle productDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle priceCard = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    color: AppColors.primaryColor,
  );

  static const TextStyle priceCurrency = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    color: AppColors.primaryColor,
  );

  static const TextStyle chipStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    color: Colors.white,
  );

  static const TextStyle chipSoft = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textColor,
  );

  static const TextStyle sortLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    color: AppColors.textColor,
  );

  static const TextStyle itemsFound = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle footerLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle loadMore = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    color: AppColors.textColor,
  );

  static const TextStyle orderBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    color: Colors.white,
  );

  static const TextStyle orderBarSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 14 / 10,
    color: Color(0xB3FFFFFF),
  );

  static const TextStyle orderBarTotal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    color: Colors.white,
  );

  static const TextStyle orderBarCurrency = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 14 / 10,
    color: Colors.white,
  );

  static const TextStyle searchHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 18 / 14,
    color: AppColors.mutedTextColor,
  );

  // Product Details
  static const TextStyle detailsTopBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    letterSpacing: -0.3,
    color: AppColors.textColor,
  );

  static const TextStyle detailsProductName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.4,
    color: AppColors.textColor,
  );

  static const TextStyle detailsPrice = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.5,
    color: AppColors.primaryColor,
  );

  static const TextStyle detailsPriceCurrency = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.primaryColor,
  );

  static const TextStyle detailsDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 22 / 14,
    color: AppColors.mutedTextColor,
  );

  static const TextStyle detailsQuantity = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    color: AppColors.textColor,
  );

  static const TextStyle detailsAddToCart = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 20 / 15,
    color: Colors.white,
  );
}
