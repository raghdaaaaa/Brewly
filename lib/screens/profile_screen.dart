import 'package:flutter/material.dart';

import '../core/errors/app_exception.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/profile_image_service.dart';
import '../widgets/profile/profile_header_card.dart';
import '../widgets/profile/profile_logout_card.dart';
import '../widgets/profile/profile_menu_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onOrdersTap, this.profileImageService});

  final VoidCallback? onOrdersTap;
  final ProfileImageService? profileImageService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileImageService _profileImageService =
      widget.profileImageService ?? ProfileImageService.instance;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _profileImageService.initialize().ignore();
    if (AuthService.instance.isLoggedIn) {
      AuthService.instance.fetchCurrentUser().ignore();
    }
  }

  Future<void> _changeProfileImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      await _profileImageService.pickFromGallery();
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
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
            final displayName =
                (current != null && current.displayName.isNotEmpty)
                ? current.displayName
                : 'Guest';
            final email = (current != null && current.email.isNotEmpty)
                ? current.email
                : 'Not signed in';

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                ProfileHeaderCard(
                  name: displayName,
                  email: email,
                  onAvatarTap: _changeProfileImage,
                  isPickingImage: _isPickingImage,
                ),
                const SizedBox(height: AppSpacing.lg),
                ProfileMenuCard(
                  onOrdersTap:
                      widget.onOrdersTap ??
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
