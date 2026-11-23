import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _topBrandHeader(),
            _heroCard(),
            _getStartedButton(context),
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
    );
  }

  Widget _topBrandHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 81, 58, 0.2),
                    blurRadius: 6,
                    spreadRadius: -1,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 81, 58, 0.2),
                    blurRadius: 4,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: SvgPicture.asset('assets/icons/welcome_steam.svg'),
              ),
            ),
            Positioned(
              top: -4,
              right: 10,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Brewly',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 32 / 24,
                letterSpacing: -0.6,
                color: textColor,
              ),
            ),
            SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowBlack05,
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 256,
              child: Stack(
                children: [
                  Align(
                    alignment: const Alignment(-0.5, 0),
                    child: FractionallySizedBox(
                      widthFactor: 1.3123,
                      heightFactor: 1.0,
                      child: Image.asset(
                        'assets/images/welcome_hero.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: Colors.white,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.5, 1.0],
                          colors: [Color(0xE6FFFFFF), Color(0x00FFFFFF)],
                        ),
                      ),
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Artisanal Coffee & Pastries,',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 30 / 24,
                      letterSpacing: -0.6,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Delivered Fresh.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 32 / 24,
                      letterSpacing: -0.48,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, loginRoute);
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 81, 58, 0.25),
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
              'Get Started',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
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
              child: SvgPicture.asset('assets/icons/welcome_cta_arrow.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
