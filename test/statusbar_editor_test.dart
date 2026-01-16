import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:statusbar_editor/statusbar_editor.dart';
import 'package:statusbar_editor/statusbar_editor_platform_interface.dart';
import 'package:statusbar_editor/statusbar_editor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockStatusbarEditorPlatform
    with MockPlatformInterfaceMixin
    implements StatusbarEditorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> changeStatusBarColor(Color color) => Future.value();

  @override
  Future<void> changeStatusBarTheme(bool isLight, {Color? statusBarColor}) =>
      Future.value();
}

void main() {
  final StatusbarEditorPlatform initialPlatform =
      StatusbarEditorPlatform.instance;

  test('$MethodChannelStatusbarEditor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStatusbarEditor>());
  });

  test('getPlatformVersion', () async {
    MockStatusbarEditorPlatform fakePlatform = MockStatusbarEditorPlatform();
    StatusbarEditorPlatform.instance = fakePlatform;

    expect(await StatusbarEditor.getPlatformVersion(), '42');
  });
}
