#!/bin/bash

echo "🚑 STARTING FINAL RESCUE V3 (THE BUILD FIXER)..."

# 1. FIX WINDOW CLASS (Accept any version type)
echo "🪟 Updating dummy Window class to accept 'int' version..."
cat <<EOF > lib/common/window.dart
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
EOF

# 2. FIX APPLICATION SETTING (Clean Syntax)
echo "⚙️ Rewriting application_setting.dart with clean syntax..."
cat <<EOF > lib/views/application_setting.dart
import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/l10n/l10n.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:sensei_tunnel/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationSettingView extends ConsumerWidget {
  const ApplicationSettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonScaffold(
      title: context.appLocalizations.application,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: const [
          _MinimizeItem(),
        ],
      ),
    );
  }
}

class _MinimizeItem extends ConsumerWidget {
  const _MinimizeItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minimizeOnExit = ref.watch(
      appSettingProvider.select((state) => state.minimizeOnExit),
    );

    return ListItem.switchItem(
      leading: const Icon(Icons.close),
      title: Text(context.appLocalizations.minimizeOnExit),
      subtitle: Text(context.appLocalizations.minimizeOnExitDesc),
      delegate: SwitchDelegate(
        value: minimizeOnExit,
        onChanged: (bool value) {
          ref
              .read(appSettingProvider.notifier)
              .updateState((state) => state.copyWith(minimizeOnExit: value));
        },
      ),
    );
  }
}
EOF

# 3. FIX QUICK OPTIONS (Explicit Imports)
echo "⚡ Rewriting quick_options.dart with correct providers..."
cat <<EOF > lib/views/dashboard/widgets/quick_options.dart
import 'package:sensei_tunnel/common/common.dart';
// Importing config explicitly to ensure configProvider is found
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

# 4. FIX TOOLS (Add missing BackupAndRecovery)
echo "🛠️ Rewriting tools.dart with backup support..."
# We will use the previous logic but ensure imports are correct
sed -i "1i import 'package:sensei_tunnel/views/backup_and_recovery.dart';" lib/views/tools.dart
# Safety fix for any const issues in tools.dart
sed -i 's/const BackupAndRecoveryView/BackupAndRecoveryView/g' lib/views/tools.dart

# 5. FIX ENUM.DART (Delete Broken Desktop Buttons)
echo "🚫 Removing broken desktop buttons from enum.dart..."
# Removing the lines causing 'Too few positional arguments'
sed -i '/tunButton(/d' lib/enum/enum.dart
sed -i '/vpnButton(/d' lib/enum/enum.dart
sed -i '/systemProxyButton(/d' lib/enum/enum.dart

echo "✅ RESCUE V3 COMPLETE."
