import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../app_text_field.dart';
import 'country_prefix_pill.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Egyptian Phone Number',
          style: AppTextStyles.fieldLabelStrong,
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CountryPrefixPill(),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppTextField(
                controller: controller,
                hint: '10 2345 6789',
                validator: Validators.egyptianPhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                  LengthLimitingTextInputFormatter(12),
                ],
                suffixIcon: SvgPicture.asset(
                  AppAssets.registerPhoneRight,
                  width: 11.25,
                  height: 16.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
