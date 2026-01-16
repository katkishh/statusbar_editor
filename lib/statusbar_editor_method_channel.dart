import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'statusbar_editor_platform_interface.dart';

/// An implementation of [StatusbarEditorPlatform] that uses method channels.
class MethodChannelStatusbarEditor extends StatusbarEditorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('statusbar_editor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  /// This method uses plain ARGB components to acquire maximum precision and
  /// allow iOS implementation
  @override
  Future<void> changeStatusBarColor(Color color) async {
    await methodChannel.invokeMethod('changeStatusBarColor', {
      'a': color.a,
      'r': color.r,
      'g': color.g,
      'b': color.b,
    });
  }

  /// This method uses plain ARGB components to acquire maximum precision and
  /// allow iOS implementation
  @override
  Future<void> changeStatusBarTheme(
    bool isLight, {
    Color? statusBarColor,
  }) async {
    await methodChannel.invokeMethod('changeStatusBarTheme', {
      'is_light': isLight,
      'a': statusBarColor?.a,
      'r': statusBarColor?.r,
      'g': statusBarColor?.g,
      'b': statusBarColor?.b,
    });
  }
}
