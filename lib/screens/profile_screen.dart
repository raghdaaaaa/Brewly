import 'package:flutter/material.dart';

import '../constants.dart';
import '../dummy_data.dart';
import '../widgets/app_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // The address form is prefilled with the saved address (dummy for now).
  late final TextEditingController _firstNameController =
      TextEditingController(text: dummyAddress.firstName);
  late final TextEditingController _lastNameController =
      TextEditingController(text: dummyAddress.lastName);
  late final TextEditingController _streetController =
      TextEditingController(text: dummyAddress.street);
  late final TextEditingController _cityController =
      TextEditingController(text: dummyAddress.city);
  late final TextEditingController _countryController =
      TextEditingController(text: dummyAddress.country);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  // Dummy: shows a snack bar after saving.
  // The API step will call PUT /api/Account/Address.
  void _saveAddress() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address saved!')),
    );
  }

  // Log out: asks for confirmation, then goes to the Login screen.
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
                Navigator.pushReplacementNamed(context, loginRoute);
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: errorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // First letters of the user name, used for the avatar.
  String _getInitials() {
    final name = '${dummyAddress.firstName} ${dummyAddress.lastName}';
    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part.substring(0, 1))
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Header: avatar with initials, name and email.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 96 circle avatar with initials.
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: emeraldTintColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: onAccentColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${dummyAddress.firstName} ${dummyAddress.lastName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dummyUserEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Address form card.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Address',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'First name',
                            controller: _firstNameController,
                            textInputAction: TextInputAction.next,
                            validator: _required('first name'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Last name',
                            controller: _lastNameController,
                            textInputAction: TextInputAction.next,
                            validator: _required('last name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    AppTextField(
                      label: 'Street and building',
                      controller: _streetController,
                      textInputAction: TextInputAction.next,
                      validator: _required('street'),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'City',
                            controller: _cityController,
                            textInputAction: TextInputAction.next,
                            validator: _required('city'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppTextField(
                            label: 'Country',
                            controller: _countryController,
                            textInputAction: TextInputAction.done,
                            validator: _required('country'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        child: const Text('Save address'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Log out row.
          TextButton(
            onPressed: _logOut,
            child: const Text(
              'Log out',
              style: TextStyle(
                color: errorColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Small validator used by every address field.
  String? Function(String?) _required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      return null;
    };
  }
}
