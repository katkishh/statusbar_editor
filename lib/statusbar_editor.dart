import 'statusbar_editor_platform_interface.dart';

class StatusbarEditor {
  Future<String?> getPlatformVersion() {
    return StatusbarEditorPlatform.instance.getPlatformVersion();
  }
}
