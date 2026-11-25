import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../services/auth_service.dart';
import '../services/profile_image_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();

    ProfileImageService.instance.initialize().ignore();
    _startApp();
  }

  Future<void> _startApp() async {
    final delayFuture = Future<void>.delayed(const Duration(seconds: 2));
    final restored = await AuthService.instance.restoreSession();
    await delayFuture;
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(
      context,
      restored ? AppRoutes.homeRoute : AppRoutes.welcomeRoute,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.coffee, size: 80, color: AppColors.cardColor),
                SizedBox(height: AppSpacing.lg),
                Text('Brewly', style: AppTextStyles.splashTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
