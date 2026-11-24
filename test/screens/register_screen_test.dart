import 'package:brewly/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('register screen renders without overflow', (tester) async {
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

        await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.text('BREWLY'), findsOneWidget);
        expect(find.text('Egyptian Phone Number'), findsOneWidget);
        expect(find.text('+20'), findsOneWidget);
        expect(find.text('Create account'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('register validation grows the form without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;

    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '');
    await tester.enterText(fields.at(1), '');
    await tester.enterText(fields.at(2), '');
    await tester.enterText(fields.at(3), '');

    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your display name'), findsOneWidget);
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
