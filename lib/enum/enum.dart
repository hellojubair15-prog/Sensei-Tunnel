import 'package:flutter/material.dart';
import 'package:sensei_tunnel/views/dashboard/widgets/widgets.dart';
import 'package:sensei_tunnel/widgets/widgets.dart';

enum SupportPlatform {
  android,
  iOS,
  windows,
  linux,
  macOS;

  static SupportPlatform get currentPlatform => SupportPlatform.android;
}

enum DashboardWidget {
  intranetIp,
  memoryInfo,
  networkSpeed,
  outboundMode,
  trafficUsage,
  networkDetection;

  Widget get widget {
    switch (this) {
      case DashboardWidget.intranetIp:
        return const GridItem(crossAxisCellCount: 4, child: IntranetIp());
      case DashboardWidget.memoryInfo:
        return const GridItem(crossAxisCellCount: 4, child: MemoryInfo());
      case DashboardWidget.networkSpeed:
        return const GridItem(crossAxisCellCount: 8, child: NetworkSpeed());
      case DashboardWidget.outboundMode:
        return const GridItem(crossAxisCellCount: 4, child: OutboundMode());
      case DashboardWidget.trafficUsage:
        return const GridItem(crossAxisCellCount: 4, child: TrafficUsage());
      case DashboardWidget.networkDetection:
        return const GridItem(crossAxisCellCount: 4, child: NetworkDetection());
    }
  }

  // Mobile support for all widgets
  List<SupportPlatform> get platforms => SupportPlatform.values;
}

enum TunStack { system, gvisor, mixed }
enum LogLevel { info, warning, error, debug, silent }
enum Mode { rule, global, direct }
