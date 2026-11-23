import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController(text: 'Omar El-Sayed');
  final _emailController = TextEditingController(text: 'omar.sayed@cairobrew.com');
  final _phoneController = TextEditingController(text: '10 2345 6789');
  final _passwordController = TextEditingController(text: 'CairoBrew!9');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: softSurfaceColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: shadowBlack05,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/register_back_arrow.svg',
                          width: 13.333,
                          height: 13.333,
                        ),
                      ),
                    ),
                  ),
                  _brandChip(),
                  SizedBox(width: 40),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Create Account',
                style: TextStyle(fontFamily: 'PlusJakartaSans',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 38 / 30,
                  letterSpacing: -0.6,
                  color: textColor,
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: shadowBlack05,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _displayNameField(),
                      SizedBox(height: 16),
                      _emailField(),
                      SizedBox(height: 16),
                      _phoneField(),
                      SizedBox(height: 16),
                      _passwordField(),
                      SizedBox(height: 8),
                      _ctaButton(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: 128,
                    height: 4,
                    decoration: BoxDecoration(
                      color: subtleBottomPillColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandChip() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowBlack05,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/register_brand_icon.svg',
                width: 11.25,
                height: 11.25,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text(
            'BREWLY',
            style: TextStyle(fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
              letterSpacing: 0.6,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(fontFamily: 'PlusJakartaSans',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.24,
        color: textColor,
      ),
    );
  }

  Widget _fieldInput({
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    TextInputAction? action,
    String? Function(String?)? validator,
    bool showRightIcon = false,
    double rightIconSize = 16.667,
    String? rightIconPath,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: softSurfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              child: TextFormField(
                controller: controller,
                obscureText: obscure,
                textInputAction: action,
                validator: validator,
                style: TextStyle(fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          if (showRightIcon && rightIconPath != null)
            SizedBox(
              width: 14,
              child: Center(
                child: SvgPicture.asset(
                  rightIconPath,
                  width: rightIconSize,
                  height: rightIconSize,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _displayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Display Name'),
        SizedBox(height: 6),
        _fieldInput(
          controller: _displayNameController,
          action: TextInputAction.next,
          validator: _validateName,
          showRightIcon: true,
          rightIconPath: 'assets/icons/register_input_right.svg',
        ),
      ],
    );
  }

  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Email Address'),
        SizedBox(height: 6),
        _fieldInput(
          controller: _emailController,
          action: TextInputAction.next,
          validator: _validateEmail,
          showRightIcon: true,
          rightIconPath: 'assets/icons/register_input_right.svg',
        ),
      ],
    );
  }

  Widget _phoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Egyptian Phone Number'),
        SizedBox(height: 6),
        Row(
          spacing: 8,
          children: [
            _countryPrefixPill(),
            Expanded(
              child: _fieldInput(
                controller: _phoneController,
                action: TextInputAction.next,
                validator: _validatePhone,
                showRightIcon: true,
                rightIconPath: 'assets/icons/register_phone_right.svg',
                rightIconSize: 11.25,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _countryPrefixPill() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: softSurfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 17),
        child: Row(
          spacing: 6,
          children: [
            const Text(
              '🇪🇬',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Text(
              '+20',
              style: TextStyle(fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 16 / 12,
                letterSpacing: 0.24,
                color: primaryColor,
              ),
            ),
            SizedBox(width: 2),
            SizedBox(
              width: 8,
              child: SvgPicture.asset('assets/icons/register_phone_prefix.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Password'),
        SizedBox(height: 6),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: softSurfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 17, 48, 17),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    style: TextStyle(fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      letterSpacing: 0.7,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: SvgPicture.asset('assets/icons/register_toggle_eye.svg'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ctaButton() {
    return InkWell(
      onTap: _register,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: shadowBlack10,
              blurRadius: 6,
              spreadRadius: -4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create account',
              style: TextStyle(fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 20 / 14,
                letterSpacing: 0.14,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 13.333,
              child: SvgPicture.asset('assets/icons/register_cta_arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }
}
