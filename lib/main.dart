import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';

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
      theme: AppTheme.light,
      initialRoute: AppRoutes.splashRoute,
      routes: AppRoutes.routes,
    );
  }
}
