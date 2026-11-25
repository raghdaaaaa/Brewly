import 'package:brewly/core/theme/app_colors.dart';
import 'package:brewly/widgets/auth/auth_emblem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('coffee glyph is centered on a circular green container', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: AuthEmblem())),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AuthEmblem),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.shape, BoxShape.circle);
    expect(decoration.color, AppColors.primaryColor);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
