class Formatters {
  const Formatters._();

  static String amount(num value) {
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.005) {
      return rounded.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  static String price(num value) => '${amount(value)} EGP';
}
