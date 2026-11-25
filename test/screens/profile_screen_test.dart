import 'package:brewly/screens/profile_screen.dart';
import 'package:brewly/services/profile_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestProfileImageService extends ProfileImageService {
  _TestProfileImageService(this.imagePath);

  final String imagePath;
  int selectionCount = 0;

  @override
  Future<void> initialize() async {
    ProfileImageService.selectedImagePath.value = null;
  }

  @override
  Future<bool> pickFromGallery() async {
    selectionCount++;
    ProfileImageService.selectedImagePath.value = imagePath;
    return true;
  }
}

void main() {
  testWidgets('profile screen renders without overflow', (tester) async {
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
        await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('My Orders'), findsOneWidget);
        expect(find.text('My Address'), findsOneWidget);
      }
    }
  });

  testWidgets('profile photo selection updates the displayed avatar', (
    tester,
  ) async {
    addTearDown(() => ProfileImageService.selectedImagePath.value = null);
    const avatarPath = 'assets\\images\\user_avatar.png';
    final imageService = _TestProfileImageService(avatarPath);

    await tester.pumpWidget(
      MaterialApp(home: ProfileScreen(profileImageService: imageService)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Change profile photo'));
    await tester.pumpAndSettle();

    expect(imageService.selectionCount, 1);
    expect(ProfileImageService.selectedImagePath.value, avatarPath);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is FileImage,
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
