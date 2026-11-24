import 'package:flutter/material.dart';

import '../../models/address.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../screens/address_screen.dart';
import '../../screens/checkout_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/order_details_screen.dart';
import '../../screens/order_success_screen.dart';
import '../../screens/product_details_screen.dart';
import '../../screens/products_list_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/splash_screen.dart';
import '../../screens/welcome_screen.dart';

/// Named routes and the route table used by [MaterialApp].
class AppRoutes {
  const AppRoutes._();

  static const String splashRoute = '/';
  static const String welcomeRoute = '/welcome';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String exploreRoute = '/explore';
  static const String productsListRoute = '/products';
  static const String detailsRoute = '/details';
  static const String checkoutRoute = '/checkout';
  static const String orderDetailsRoute = '/order_details';
  static const String orderSuccessRoute = '/order_success';
  static const String addressRoute = '/address';

  static final Map<String, WidgetBuilder> routes = {
    splashRoute: (context) => const SplashScreen(),
    welcomeRoute: (context) => const WelcomeScreen(),
    loginRoute: (context) => const LoginScreen(),
    registerRoute: (context) => const RegisterScreen(),
    homeRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final initialIndex = arguments is int ? arguments : 0;
      return MainScreen(initialIndex: initialIndex);
    },
    exploreRoute: (context) => const ExploreScreen(),
    productsListRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Map) {
        return ProductsListScreen(
          initialSearch: arguments['search'] as String? ?? '',
          categoryId: arguments['categoryId'] as int?,
          categoryName: arguments['categoryName'] as String?,
          brandId: arguments['brandId'] as int?,
          brandName: arguments['brandName'] as String?,
        );
      }
      return const ProductsListScreen();
    },
    detailsRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Product) {
        return ProductDetailsScreen(product: arguments);
      }
      if (arguments is int) {
        return ProductDetailsScreen(productId: arguments);
      }
      if (arguments is Map) {
        return ProductDetailsScreen(
          product: arguments['product'] as Product?,
          productId: arguments['productId'] as int?,
          heroPrefix: arguments['heroPrefix'] as String? ?? 'home',
        );
      }
      return const ProductDetailsScreen();
    },
    checkoutRoute: (context) => const CheckoutScreen(),
    orderDetailsRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      return OrderDetailsScreen(order: arguments as Order?);
    },
    orderSuccessRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is String) {
        return OrderSuccessScreen(orderId: arguments);
      }
      if (arguments is Map) {
        return OrderSuccessScreen(
          orderId: arguments['orderId'] as String?,
          total: (arguments['total'] as num?)?.toDouble(),
        );
      }
      return const OrderSuccessScreen();
    },
    addressRoute: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      return AddressScreen(initialAddress: arguments as Address?);
    },
  };
}
