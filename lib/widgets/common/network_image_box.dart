import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A network image with a fixed box, rounded corners and a local placeholder.
///
/// The API sometimes returns a relative or broken URL, so every image in the
/// app goes through this widget instead of calling [Image.network] directly.
class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = AppRadius.sm,
    this.iconSize = 28,
  });

  final String url;
  final double? width;
  final double? height;
  final double radius;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.softSurfaceColor,
      alignment: Alignment.center,
      child: Icon(
        Icons.local_cafe,
        size: iconSize,
        color: AppColors.mutedTextColor,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: url.isEmpty
            ? placeholder
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => placeholder,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return placeholder;
                },
              ),
      ),
    );
  }
}
