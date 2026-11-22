import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class AppHeaderBack extends StatelessWidget {
  const AppHeaderBack({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: softSurfaceDeepColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowBlack10,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: shadowBlack10,
                  blurRadius: 4,
                  offset: const Offset(-2, 2),
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/back_arrow.svg',
                width: 9.8125,
                height: 16.6667,
              ),
            ),
          ),
        ),
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
      ],
    );
  }
}
