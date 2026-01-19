#!/bin/bash

echo "🚑 STARTING PHASE 2 RESCUE..."

# 1. FIX WINDOW CLASS (Add missing 'init' method)
echo "🪟 Updating dummy Window class..."
cat <<EOF > lib/common/window.dart
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
EOF

# 2. FIX TRAY CLASS (Add missing 'update' method)
echo "📥 Updating dummy Tray class..."
cat <<EOF > lib/common/tray.dart
import 'package:flutter/material.dart';

class Tray {
  Future<void> init() async {}
  Future<void> setIcon(String icon) async {}
  Future<void> setToolTip(String tooltip) async {}
  Future<void> setContextMenu(Menu menu) async {}
  Future<void> update({dynamic trayState}) async {}
}

final Tray? tray = Tray();

class Menu {
  Menu({required List<MenuItem> items});
}

class MenuItem {
  MenuItem({String? label, Function? onClick});
  MenuItem.separator();
  MenuItem.checkbox({String? label, bool? checked, Function? onClick});
  MenuItem.submenu({String? label, Menu? submenu});
}
EOF

# 3. FIX CONTROLLER (Disable autoLaunch & tray update calls)
echo "🎮 Patching Controller..."
sed -i 's/autoLaunch?.updateStatus/\/\/ autoLaunch?.updateStatus/g' lib/controller.dart
sed -i 's/tray?.update/\/\/ tray?.update/g' lib/controller.dart

# 4. FIX TILE MANAGER (Remove super.onStart)
echo "🧱 Fixing Tile Manager..."
sed -i 's/super.onStart();//g' lib/manager/tile_manager.dart

# 5. FIX ENUM.DART (Remove missing Desktop Buttons)
echo "🔘 Removing Desktop Buttons from enum.dart..."
sed -i '/TUNButton/d' lib/enum/enum.dart
sed -i '/VpnButton/d' lib/enum/enum.dart
sed -i '/SystemProxyButton/d' lib/enum/enum.dart

# 6. FIX QUICK OPTIONS (Add Missing Imports)
echo "⚡ Re-writing Quick Options with correct imports..."
cat <<EOF > lib/views/dashboard/widgets/quick_options.dart
import 'package:sensei_tunnel/common/common.dart';
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

# 7. FIX TOOLS.DART (Add BackupAndRecovery Import)
echo "🛠️ Adding import to tools.dart..."
# Check if import exists, if not prepend it
if ! grep -q "backup_and_recovery.dart" lib/views/tools.dart; then
  sed -i "1i import 'package:sensei_tunnel/views/backup_and_recovery.dart';" lib/views/tools.dart
fi

# 8. FIX APPLICATION SETTING (Remove Notification Item)
echo "⚙️ Removing Notification settings (Mobile doesn't support)..."
# Remove usage in list
sed -i '/_NotificationItem(),/d' lib/views/application_setting.dart
# Remove the class definition (brute force removal of lines containing _NotificationItem)
sed -i '/class _NotificationItem/,/}/d' lib/views/application_setting.dart

echo "✅ PHASE 2 RESCUE COMPLETE."
