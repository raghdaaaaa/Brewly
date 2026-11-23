import 'package:flutter/material.dart';

import '../../screens/checkout_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/main_screen.dart';
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
    productsListRoute: (context) => const ProductsListScreen(),
    detailsRoute: (context) => const ProductDetailsScreen(),
    checkoutRoute: (context) => const CheckoutScreen(),
  };
}
