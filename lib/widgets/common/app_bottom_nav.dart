import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

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
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    _tab(2, _tabIcons[2]),
                    if (cartCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cartCount.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
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
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                  child: Icon(icon, size: 20, color: Colors.white),
                )
              : Icon(icon, size: 20, color: AppColors.mutedTextColor),
        ),
      ),
    );
  }
}
