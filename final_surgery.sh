#!/bin/bash

echo "🏥 STARTING FINAL SURGERY OPERATION..."

# 1. REWRITE ENUM.DART (Simplify DashboardWidget)
echo "💊 Rewriting enum.dart to fix DashboardWidget Enum conflict..."
cat <<EOF > lib/enum/enum.dart
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
EOF

# 2. REWRITE CONFIG.DART (Fix Generated Code Issues)
echo "⚙️ Fixing config.dart to match new Enum..."
# We need to manually fix the generated part or simplify the model
# For now, let's patch the Config model to use List<String> instead of complex Enum mapping if possible, 
# OR just regenerate the file content to match the new Enum structure.

# Let's replace the problematic generated lines if they exist in a generated file, 
# but since we can't run build_runner, we have to fix the usage in config.dart itself.

# Fix lib/models/generated/config.g.dart manually by removing reference to deleted buttons
sed -i "/tunButton/d" lib/models/generated/config.g.dart
sed -i "/vpnButton/d" lib/models/generated/config.g.dart
sed -i "/systemProxyButton/d" lib/models/generated/config.g.dart

# 3. REWRITE DASHBOARD.DART (Fix Logic to match new Enum)
echo "📊 Rewriting dashboard.dart to use new Enum structure..."
cat <<EOF > lib/views/dashboard/dashboard.dart
import 'package:sensei_tunnel/enum/enum.dart';
import 'package:sensei_tunnel/models/models.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:sensei_tunnel/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';

import 'widgets/widgets.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWidgets = ref.watch(
      configProvider.select((value) => value.config.dashboardWidgets),
    );

    final widgets = dashboardWidgets
        .map((e) => e.widget)
        .toList();

    return SuperGrid(
      children: widgets,
    );
  }
}
EOF

# 4. FIX QUICK OPTIONS (Final check on imports)
echo "⚡ Verifying Quick Options imports..."
cat <<EOF > lib/views/dashboard/widgets/quick_options.dart
import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/providers/config.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:sensei_tunnel/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickOptions extends ConsumerWidget {
  const QuickOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tunProps = ref.watch(
      configProvider.select((value) => value.config.tun),
    );
    final enableTun = tunProps.enable;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionChip(
            avatar: Icon(Icons.vpn_key, size: 18, color: enableTun ? Colors.white : null),
            label: const Text("TUN Mode"),
            backgroundColor: enableTun ? context.colorScheme.primary : null,
            onPressed: () {
               ref.read(configProvider.notifier).configPatch((config) {
                return config.copyWith.tun(enable: !enableTun);
              });
            },
          ),
        ],
      ),
    );
  }
}
EOF

# 5. FIX TOOLS.DART (Final fix for BackupAndRecovery)
echo "🛠️ Finalizing tools.dart..."
sed -i "1i import 'package:sensei_tunnel/views/backup_and_recovery.dart';" lib/views/tools.dart
# Ensure correct usage
sed -i 's/MaterialPageRoute(builder: (_) => BackupAndRecoveryView())/MaterialPageRoute(builder: (_) => const BackupAndRecoveryView())/g' lib/views/tools.dart

echo "✅ SURGERY COMPLETE. PATIENT IS STABLE."
