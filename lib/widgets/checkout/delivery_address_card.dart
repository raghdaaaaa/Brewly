import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../app_text_field.dart';

/// Form card for entering and editing the delivery address.
class DeliveryAddressCard extends StatelessWidget {
  const DeliveryAddressCard({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.streetController,
    required this.cityController,
    required this.countryController,
    required this.saveAsDefault,
    required this.onSaveDefaultChanged,
    required this.onEditTap,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController countryController;
  final bool saveAsDefault;
  final ValueChanged<bool?> onSaveDefaultChanged;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Text(
                'Delivery Address',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle,
              ),
            ),
            TextButton(
              onPressed: onEditTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Edit', style: AppTextStyles.link),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'First Name',
                      hint: 'Omar',
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      validator: _required('your first name'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Last Name',
                      hint: 'El-Sayed',
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      validator: _required('your last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Street & Residence',
                hint: '14 Gezira St, Zamalek, Apt 4B',
                controller: streetController,
                textInputAction: TextInputAction.next,
                validator: _required('your street address'),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'City / District',
                      hint: 'Cairo',
                      controller: cityController,
                      textInputAction: TextInputAction.next,
                      validator: _required('your city'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Country',
                      hint: 'Egypt',
                      controller: countryController,
                      textInputAction: TextInputAction.done,
                      validator: _required('your country'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => onSaveDefaultChanged(!saveAsDefault),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: saveAsDefault,
                          onChanged: onSaveDefaultChanged,
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Text(
                          'Save as default Cairo delivery address',
                          style: AppTextStyles.bodyMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? Function(String?) _required(String fieldName) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $fieldName';
      }
      return null;
    };
  }
}
