import 'package:flutter/material.dart';

import '../core/routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../models/address.dart';
import '../services/dummy/dummy_data.dart';
import '../widgets/app_header.dart';
import '../widgets/profile/address_bottom_sheet.dart';
import '../widgets/profile/profile_header_card.dart';
import '../widgets/profile/profile_logout_card.dart';
import '../widgets/profile/profile_menu_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Address _userAddress = dummyAddress;

  void _openAddressSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AddressBottomSheet(
          initialAddress: _userAddress,
          onSaved: (updated) {
            setState(() {
              _userAddress = updated;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address saved!')),
            );
          },
        );
      },
    );
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
              onPressed: () {
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
              name: '${_userAddress.firstName} ${_userAddress.lastName}',
              email: dummyUserEmail,
            ),
            const SizedBox(height: AppSpacing.lg),
            ProfileMenuCard(
              onOrdersTap: () {
                Navigator.pushNamed(context, AppRoutes.homeRoute, arguments: 3);
              },
              onAddressTap: _openAddressSheet,
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
