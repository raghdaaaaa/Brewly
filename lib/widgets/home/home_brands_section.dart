import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/brand.dart';
import '../error_retry.dart';
import '../loading_indicator.dart';
import '../common/section_header.dart';
import 'brand_pill.dart';

/// "FEATURED ROASTERS & BAKERIES" and the brand pills from the API.
class HomeBrandsSection extends StatelessWidget {
  const HomeBrandsSection({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onBrandTap,
  });

  final Future<List<Brand>> future;
  final VoidCallback onRetry;
  final ValueChanged<Brand> onBrandTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Brand>>(
      future: future,
      builder: (context, snapshot) {
        final brands = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'FEATURED ROASTERS & BAKERIES',
              titleStyle: AppTextStyles.eyebrowCaps,
              trailingLabel: snapshot.hasData
                  ? '${brands.length} Roasters'
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (snapshot.connectionState == ConnectionState.waiting)
              const LoadingIndicator()
            else if (snapshot.hasError)
              ErrorRetry(
                message: 'Could not load the roasters.',
                onRetry: onRetry,
              )
            else if (brands.isEmpty)
              const SizedBox.shrink()
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var index = 0; index < brands.length; index++) ...[
                      if (index > 0) const SizedBox(width: AppSpacing.sm),
                      BrandPill(
                        brand: brands[index],
                        isSelected: index == 0,
                        onTap: () => onBrandTap(brands[index]),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
