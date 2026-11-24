import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../services/auth_service.dart';
import '../services/dummy/dummy_data.dart';
import '../widgets/app_header.dart';
import '../widgets/profile/profile_header_card.dart';
import '../widgets/profile/profile_logout_card.dart';
import '../widgets/profile/profile_menu_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logOut() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text('You will be signed out of Brewly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                AuthService.instance.logout();
                Navigator.pop(dialogContext);
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.loginRoute,
                );
              },
              child: const Text('Log out', style: AppTextStyles.dangerAction),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final displayName = (user != null && user.displayName.isNotEmpty)
        ? user.displayName
        : '${dummyAddress.firstName} ${dummyAddress.lastName}';
    final email = (user != null && user.email.isNotEmpty)
        ? user.email
        : dummyUserEmail;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            100,
          ),
          children: [
            const AppHeaderTop(),
            const SizedBox(height: AppSpacing.md),
            ProfileHeaderCard(
              name: displayName,
              email: email,
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileMenuCard(
              onOrdersTap: () {
                Navigator.pushNamed(context, AppRoutes.homeRoute, arguments: 3);
              },
              onAddressTap: () {
                Navigator.pushNamed(context, AppRoutes.addressRoute);
              },
              onSettingsTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              },
              onHelpTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileLogoutCard(onTap: _logOut),
          ],
        ),
      ),
    );
  }
}
