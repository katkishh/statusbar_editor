import 'package:flutter/material.dart';

import 'statusbar_editor_platform_interface.dart';

class StatusbarEditor {
  static Future<String?> getPlatformVersion() {
    return StatusbarEditorPlatform.instance.getPlatformVersion();
  }

  static Future<void> changeStatusBarColor(Color color) async {
    return await StatusbarEditorPlatform.instance.changeStatusBarColor(color);
  }

  static Future<void> changeStatusBarTheme(
    bool isLight, {
    Color? statusBarColor,
  }) async {
    return await StatusbarEditorPlatform.instance.changeStatusBarTheme(
      isLight,
      statusBarColor: statusBarColor,
    );
  }
}
