/// Spacing scale, radii and fixed component sizes from the Figma file.
class AppSpacing {
  const AppSpacing._();

  /// 4
  static const double xs = 4;

  /// 8
  static const double sm = 8;

  /// 12
  static const double md = 12;

  /// 16
  static const double lg = 16;

  /// 24
  static const double xl = 24;

  /// 32
  static const double xxl = 32;
}

class AppRadius {
  const AppRadius._();

  /// 12: inputs, small inner cards.
  static const double sm = 12;

  /// 16: cards, form fields.
  static const double md = 16;

  /// 20: product and order cards, bottom sheets.
  static const double lg = 20;

  /// 24: hero cards, bottom bars.
  static const double xl = 24;

  /// 9999: buttons, chips, pills, avatars.
  static const double pill = 9999;
}

class AppSizes {
  const AppSizes._();

  static const double inputHeight = 52;
  static const double buttonHeight = 56;
  static const double navBarHeight = 64;
}
