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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
