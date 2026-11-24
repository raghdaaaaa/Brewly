import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  static const List<IconData> _tabIcons = [
    Icons.home_outlined,
    Icons.search,
    Icons.shopping_cart_outlined,
    Icons.receipt_long_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Container(
          height: AppSizes.navBarHeight,
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Row(
              children: [
                _tab(0, _tabIcons[0]),
                _tab(1, _tabIcons[1]),
                _cartTab(),
                _tab(3, _tabIcons[3]),
                _tab(4, _tabIcons[4]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(int index, IconData icon) {
    final active = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Center(
          child: active
              ? Container(
                  width: AppSizes.navActiveCircle,
                  height: AppSizes.navActiveCircle,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: Colors.white),
                )
              : Icon(icon, size: 22, color: AppColors.mutedTextColor),
        ),
      ),
    );
  }

  Widget _cartTab() {
    final active = currentIndex == 2;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(2),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Center(
          child: SizedBox(
            width: AppSizes.navActiveCircle,
            height: AppSizes.navActiveCircle,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (active)
                  Container(
                    width: AppSizes.navActiveCircle,
                    height: AppSizes.navActiveCircle,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 22,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 22,
                    color: AppColors.mutedTextColor,
                  ),
                if (cartCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartCount > 9 ? '9+' : '$cartCount',
                        style: AppTextStyles.statusPill.copyWith(
                          color: AppColors.navBadgeTextColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
