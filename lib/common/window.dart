import 'dart:io';

import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/models/config.dart';
import 'package:sensei_tunnel/state.dart';
import 'package:flutter/material.dart';

class Window {
  Future<void> init(int version) async {
    final props = globalState.config.windowProps;
    final acquire = await singleInstanceLock.acquire();
    if (!acquire) {
      exit(0);
    }
    if (system.isWindows) {
      protocol.register('clash');
      protocol.register('clashmeta');
      protocol.register('flclash');
    }
    // kDebugMode ? Size(680, 580) :
    WindowOptions windowOptions = WindowOptions(
      size: props.size,
      minimumSize: const Size(380, 400),
    );
    if (!system.isMacOS || version > 10) {
    }
    await _windowPosition(props);
    });
  }

  Future<void> _windowPosition(WindowProps props) async {
    if (!system.isMacOS) {
      final left = props.left ?? 0;
      final top = props.top ?? 0;
      final right = left + props.width;
      final bottom = top + props.height;
      if (left == 0 && top == 0) {
      } else {
        final displays = await screenRetriever.getAllDisplays();
        final isPositionValid = displays.any((display) {
          final displayBounds = Rect.fromLTWH(
            display.visiblePosition!.dx,
            display.visiblePosition!.dy,
            display.size.width,
            display.size.height,
          );
          return displayBounds.contains(Offset(left, top)) ||
              displayBounds.contains(Offset(right, bottom));
        });
        if (isPositionValid) {
        }
      }
    }
  }

  Future<void> show() async {
    render?.resume();
  }

  Future<bool> get isVisible async {
    commonPrint.log('window visible check: $value');
    return value;
  }

  Future<void> close() async {
    exit(0);
  }

  Future<void> hide() async {
    render?.pause();
  }
}

final window = system.isDesktop ? Window() : null;
