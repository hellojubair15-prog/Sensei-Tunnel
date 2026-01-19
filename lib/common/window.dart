import 'package:flutter/material.dart';

class Window {
  Future<void> show() async {}
  Future<void> hide() async {}
  Future<void> close() async {}
  Future<void> init(String version) async {}
  Future<bool> get isVisible async => true;
}

final Window? window = Window();

class WindowOptions {
  WindowOptions({
    Size? size,
    Size? minimumSize,
    bool? center,
    bool? skipTaskbar,
    String? title,
  });
}
