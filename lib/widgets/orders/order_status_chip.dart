import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isPreparation = normalized.contains('preparation') || normalized.contains('pending');
    final isCancelled = normalized.contains('cancel');

    final Color bgColor;
    final Color textColor;
    final IconData icon;

    if (isCancelled) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      icon = Icons.close_rounded;
    } else if (isPreparation) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFF92400E);
      icon = Icons.access_time_rounded;
    } else {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF065F46);
      icon = Icons.check_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.pill),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.statusPill.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
