import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../widgets/app_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(
    text: 'omar.sayed@cairobrew.com',
  );
  final _passwordController = TextEditingController(
    text: 'EspressoZamalek2024!',
  );

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, homeRoute);
    }
  }

  String? _requiredEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    return null;
  }

  String? _requiredPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: AppHeaderBack(),
          ),
          SizedBox(height: 24),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _emblem(),
              SizedBox(height: 8),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 38 / 30,
                  letterSpacing: -0.6,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _emailCard(),
                  SizedBox(height: 16),
                  _passwordCard(),
                  SizedBox(height: 16),
                  _ctaButton(),
                ],
              ),
            ),
          ),
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
    );
  }

  Widget _emblem() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowBlack10,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 19.5,
                height: 19.5,
                child: SvgPicture.asset('assets/icons/emblem_icon.svg'),
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowBlack05,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SizedBox(
            width: 12.833,
            height: 12.833,
            child: SvgPicture.asset('assets/icons/emblem_ring.svg'),
          ),
        ),
      ],
    );
  }

  Widget _fieldCard(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
            letterSpacing: 0.24,
            color: mutedTextColor,
          ),
        ),
        SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _emailCard() {
    return _fieldCard(
      'Email address',
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowBlack05,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SizedBox(
                width: 28.667,
                child: SvgPicture.asset('assets/icons/email_left.svg'),
              ),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  validator: _requiredEmail,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 24 / 16,
                    color: textColor,
                  ),
                  decoration: const InputDecoration.collapsed(hintText: 'omar.sayed@cairobrew.com'),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 15,
                child: SvgPicture.asset('assets/icons/email_right.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordCard() {
    return _fieldCard(
      'Password',
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowBlack05,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SizedBox(
                width: 25.333,
                child: SvgPicture.asset(
                  'assets/icons/password_left.svg',
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _requiredPassword,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 24 / 16,
                    letterSpacing: 1.6,
                    color: textColor,
                  ),
                  decoration: const InputDecoration.collapsed(hintText: 'Password'),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: SizedBox(
                  width: 18.333,
                  height: 12.5,
                  child: SvgPicture.asset('assets/icons/toggle_eye.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ctaButton() {
    return InkWell(
      onTap: _login,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: shadowBlack10,
              blurRadius: 15,
              spreadRadius: -3,
            ),
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
              'Login',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 20 / 14,
                letterSpacing: 0.14,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 13.333,
              child: SvgPicture.asset('assets/icons/cta_arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
