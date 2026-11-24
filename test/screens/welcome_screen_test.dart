import 'package:brewly/core/routes/app_routes.dart';
import 'package:brewly/screens/login_screen.dart';
import 'package:brewly/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('welcome screen renders without overflow', (tester) async {
    for (final size in [
      const Size(320, 640),
      const Size(360, 800),
      const Size(390, 844),
      const Size(430, 932),
    ]) {
      for (final scale in [1.0, 1.3]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        tester.platformDispatcher.textScaleFactorTestValue = scale;

        await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Brewly'), findsOneWidget);
        expect(find.text('Artisanal Coffee & Pastries,'), findsOneWidget);
        expect(find.text('Delivered Fresh.'), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('Get Started opens Login with a named route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const WelcomeScreen(),
        routes: {
          AppRoutes.loginRoute: (context) => const LoginScreen(),
        },
      ),
    );

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
