class Formatters {
  const Formatters._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String amount(num value) {
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.005) {
      return rounded.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  static String price(num value) => '${amount(value)} EGP';

  static String orderDate(String value, {DateTime? now}) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }

    final date = parsed.toLocal();
    final today = now ?? DateTime.now();
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    final daysAgo = todayOnly.difference(dateOnly).inDays;
    final dateLabel = switch (daysAgo) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => '${date.day} ${_months[date.month - 1]} ${date.year}',
    };

    final hasTime = value.contains('T') || value.contains(' ');
    if (!hasTime) {
      return dateLabel;
    }

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return '$dateLabel, $hour:$minute $period';
  }
}
