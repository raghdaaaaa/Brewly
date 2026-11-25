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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Good evening, $name 👋',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTextStyles.greeting,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            PointsPill(points: points),
          ],
        ),
      ],
    );
  }
}
