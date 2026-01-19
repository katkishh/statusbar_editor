# statusbar_editor

## Description

A Flutter plugin targeting mobile platforms (Android and iOS) to edit status bar settings: background color and theme.

## Getting Started

Depend on `statusbar_editor`:
```yaml
dependencies:
  statusbar_editor:
    git:
      url: https://github.com/katkishh/statusbar_editor
      ref: main
```

Run `flutter pub get`.

Use plugin in application:

```dart
StatusbarEditor.changeStatusBarColor(Colors.red);
```
