import 'package:sensei_tunnel/common/common.dart';
import 'package:flutter/material.dart';

class CommonTheme {
  final BuildContext context;
  final Map<String, Color> _colorMap;
  final double textScaleFactor;

  CommonTheme.of(
    this.context,
    this.textScaleFactor,
  ) : _colorMap = {};

  static const Color neonGreen = Color(0xFF39FF14);
  static const Color darkHackerGreen = Color(0xFF002200);

  Color get darkenSecondaryContainer {
    return _colorMap.updateCacheValue(
      'darkenSecondaryContainer',
      () => const Color(0xFF001A00), 
    );
  }

  Color get darkenSecondaryContainerLighter {
    return _colorMap.updateCacheValue(
      'darkenSecondaryContainerLighter',
      () => const Color(0xFF00FF00).withOpacity(0.2), 
    );
  }

  Color get darken2SecondaryContainer {
    return _colorMap.updateCacheValue(
      'darken2SecondaryContainer',
      () => const Color(0xFF000D00), 
    );
  }

  Color get darken3PrimaryContainer {
    return _colorMap.updateCacheValue(
      'darken3PrimaryContainer',
      () => const Color(0xFF00FF00).withOpacity(0.1),
    );
  }
  
  TextStyle get hackerTextStyle {
    return TextStyle(
      color: neonGreen,
      fontFamily: 'monospace',
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: neonGreen.withOpacity(0.5),
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}
