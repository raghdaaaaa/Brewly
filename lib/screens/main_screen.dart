import 'package:flutter/material.dart';

import '../services/basket_service.dart';
import '../widgets/common/app_bottom_nav.dart';
import 'cart_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  // 0 = Home, 1 = Explore, 2 = Cart, 3 = Orders, 4 = Profile.
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = widget.initialIndex;

  @override
  void initState() {
    super.initState();
    // Load the real basket once so the cart badge shows the API count.
    BasketService().getBasket().ignore();
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          const ExploreScreen(),
          CartScreen(onBrowseMenu: () => _selectTab(0)),
          const OrdersScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: BasketService.itemCount,
        builder: (context, cartCount, child) {
          return AppBottomNav(
            currentIndex: _currentIndex,
            onTap: _selectTab,
            cartCount: cartCount,
          );
        },
      ),
    );
  }
}
