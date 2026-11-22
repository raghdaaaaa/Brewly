import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';
import 'screens/checkout_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const BrewlyApp());
}

class BrewlyApp extends StatelessWidget {
  const BrewlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brewly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: cardColor,
          error: errorColor,
          onPrimary: Colors.white,
          onSecondary: onAccentColor,
          onSurface: textColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      initialRoute: splashRoute,
      routes: {
        splashRoute: (context) => const SplashScreen(),
        welcomeRoute: (context) => const WelcomeScreen(),
        loginRoute: (context) => const LoginScreen(),
        registerRoute: (context) => const RegisterScreen(),
        homeRoute: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          final initialIndex = arguments is int ? arguments : 0;
          return MainScreen(initialIndex: initialIndex);
        },
        detailsRoute: (context) => const ProductDetailsScreen(),
        checkoutRoute: (context) => const CheckoutScreen(),
      },
    );
  }
}
