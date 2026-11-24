import 'dart:io';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/errors/app_exception.dart';

typedef PickProfileImage = Future<XFile?> Function();
typedef ProfileImageDirectory = Future<Directory> Function();
typedef ProfileImagePreferences = Future<SharedPreferences> Function();

class ProfileImageService {
  ProfileImageService({
    PickProfileImage? pickImage,
    ProfileImageDirectory? directoryProvider,
    ProfileImagePreferences? preferencesProvider,
  })  : _pickImage = pickImage ?? _pickFromGallery,
        _directoryProvider =
            directoryProvider ?? getApplicationDocumentsDirectory,
        _preferencesProvider =
            preferencesProvider ?? SharedPreferences.getInstance;

  static final ProfileImageService instance = ProfileImageService();

  static final ValueNotifier<String?> selectedImagePath =
      ValueNotifier<String?>(null);
  static const String _preferenceKey = 'profile_image_path';
  static const String _imageFolderName = 'profile_images';

  final PickProfileImage _pickImage;
  final ProfileImageDirectory _directoryProvider;
  final ProfileImagePreferences _preferencesProvider;

  Future<void>? _initialization;

  bool get hasCustomImage => selectedImagePath.value != null;

  Future<void> initialize() {
    return _initialization ??= _restoreSavedImage();
  }

  Future<bool> pickFromGallery() async {
    try {
      final picked = await _pickImage();
      if (picked == null) {
        return false;
      }

      final source = File(picked.path);
      if (!await source.exists() || await source.length() == 0) {
        throw const AppException(
          'The selected image is no longer available. Please choose another one.',
        );
      }

      final directory = await _directoryProvider();
      final imageDirectory = Directory(
        '${directory.path}${Platform.pathSeparator}$_imageFolderName',
      );
      await imageDirectory.create(recursive: true);

      final target = File(
        '${imageDirectory.path}${Platform.pathSeparator}'
        'brewly_profile_avatar${_safeExtension(picked.name)}',
      );
      await picked.saveTo(target.path);

      if (!await target.exists() || await target.length() == 0) {
        throw const AppException(
          'The selected image could not be saved. Please try again.',
        );
      }

      final previousPath = selectedImagePath.value;
      try {
        final preferences = await _preferencesProvider();
        await preferences.setString(_preferenceKey, target.path);
      } catch (_) {
        await _deleteIfPresent(target);
        throw const AppException(
          'The selected image could not be saved on this device.',
        );
      }

      selectedImagePath.value = target.path;
      if (previousPath != null && previousPath != target.path) {
        await _deleteIfPresent(File(previousPath));
      }
      return true;
    } on AppException {
      rethrow;
    } on PlatformException {
      throw const AppException(
        'The photo library could not be opened. Please check app permissions.',
      );
    } catch (_) {
      throw const AppException(
        'The selected image could not be saved. Please try again.',
      );
    }
  }

  Future<void> resetToDefault() async {
    final previousPath = selectedImagePath.value;
    selectedImagePath.value = null;

    try {
      final preferences = await _preferencesProvider();
      await preferences.remove(_preferenceKey);
    } catch (_) {}

    if (previousPath != null) {
      await _deleteIfPresent(File(previousPath));
    }
  }

  Future<void> _restoreSavedImage() async {
    try {
      final preferences = await _preferencesProvider();
      final savedPath = preferences.getString(_preferenceKey);
      if (savedPath == null || savedPath.isEmpty) {
        selectedImagePath.value = null;
        return;
      }

      final savedFile = File(savedPath);
      if (!await savedFile.exists() || await savedFile.length() == 0) {
        selectedImagePath.value = null;
        await preferences.remove(_preferenceKey);
        return;
      }

      selectedImagePath.value = savedPath;
    } catch (_) {
      selectedImagePath.value = null;
    }
  }

  static Future<XFile?> _pickFromGallery() {
    return ImagePicker().pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );
  }

  static String _safeExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return '.jpg';
    }
    final extension = fileName.substring(dotIndex).toLowerCase();
    return RegExp(r'^\.[a-z0-9]{1,5}$').hasMatch(extension)
        ? extension
        : '.jpg';
  }

  static Future<void> _deleteIfPresent(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
