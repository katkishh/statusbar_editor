import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'statusbar_editor_method_channel.dart';

abstract class StatusbarEditorPlatform extends PlatformInterface {
  /// Constructs a StatusbarEditorPlatform.
  StatusbarEditorPlatform() : super(token: _token);

  static final Object _token = Object();

  static StatusbarEditorPlatform _instance = MethodChannelStatusbarEditor();

  /// The default instance of [StatusbarEditorPlatform] to use.
  ///
  /// Defaults to [MethodChannelStatusbarEditor].
  static StatusbarEditorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StatusbarEditorPlatform] when
  /// they register themselves.
  static set instance(StatusbarEditorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
