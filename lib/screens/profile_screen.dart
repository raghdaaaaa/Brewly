import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/app_header.dart';
import '../widgets/profile/profile_header_card.dart';
import '../widgets/profile/profile_logout_card.dart';
import '../widgets/profile/profile_menu_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onOrdersTap});

  final VoidCallback? onOrdersTap;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthService.instance.isLoggedIn) {
      AuthService.instance.fetchCurrentUser().ignore();
    }
  }

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
              onPressed: () async {
                final navigator = Navigator.of(context);
                Navigator.pop(dialogContext);
                await AuthService.instance.logout();
                if (!mounted) return;
                navigator.pushNamedAndRemoveUntil(
                  AppRoutes.loginRoute,
                  (route) => false,
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ValueListenableBuilder<User?>(
          valueListenable: AuthService.currentUserNotifier,
          builder: (context, user, child) {
            final current = user ?? AuthService.instance.currentUser;
            final displayName = (current != null && current.displayName.isNotEmpty)
                ? current.displayName
                : 'Guest';
            final email = (current != null && current.email.isNotEmpty)
                ? current.email
                : 'Not signed in';

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
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
                  onOrdersTap: widget.onOrdersTap ??
                      () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.homeRoute,
                          arguments: 3,
                        );
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
            );
          },
        ),
      ),
    );
  }
}
