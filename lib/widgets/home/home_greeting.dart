import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'points_pill.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.name, required this.points});

  final String name;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Good evening, $name 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.greeting,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: PointsPill(points: points),
            ),
          ],
        ),
      ],
    );
  }
}
