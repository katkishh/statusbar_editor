import 'package:flutter/material.dart';

import 'statusbar_editor_platform_interface.dart';

class StatusbarEditor {
  Future<String?> getPlatformVersion() {
    return StatusbarEditorPlatform.instance.getPlatformVersion();
  }

  Future<void> changeStatusBarColor(Color color) async {
    return await StatusbarEditorPlatform.instance.changeStatusBarColor(color);
  }

  Future<void> changeStatusBarTheme(
    bool isLight, {
    Color? statusBarColor,
  }) async {
    return await StatusbarEditorPlatform.instance.changeStatusBarTheme(
      isLight,
      statusBarColor: statusBarColor,
    );
  }
}
