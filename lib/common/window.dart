import 'package:flutter/material.dart';

class Window {
  Future<void> show() async {}
  Future<void> hide() async {}
  Future<void> close() async {}
  // Changed to dynamic to accept both int and String
  Future<void> init(dynamic version) async {}
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
