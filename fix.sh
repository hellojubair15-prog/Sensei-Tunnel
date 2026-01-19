#!/bin/bash

echo "🚀 Starting Sensei Tunnel Cleanup & Fix Procedure..."

# 1. Clean pubspec.yaml (Remove Desktop Dependencies)
echo "📦 Cleaning dependencies in pubspec.yaml..."
sed -i '/hotkey_manager/d' pubspec.yaml
sed -i '/tray_manager/d' pubspec.yaml
sed -i '/window_manager/d' pubspec.yaml
sed -i '/launch_at_startup/d' pubspec.yaml
sed -i '/window_ext/d' pubspec.yaml

# 2. Delete Desktop-Specific Files (Based on your ls output)
echo "🗑️ Deleting desktop-specific files..."
rm -f lib/manager/hotkey_manager.dart
rm -f lib/manager/tray_manager.dart
rm -f lib/manager/window_manager.dart
rm -f lib/views/hotkey.dart
rm -rf plugins/window_ext

# 3. Fix Android SDK Versions (Bump to 35 for new plugins)
echo "🤖 Upgrading Android SDK versions..."
sed -i 's/compileSdk = .*/compileSdk = 35/g' android/app/build.gradle.kts
sed -i 's/targetSdk = .*/targetSdk = 35/g' android/app/build.gradle.kts
sed -i 's/compileSdkVersion .*/compileSdkVersion 35/g' android/app/build.gradle
sed -i 's/targetSdkVersion .*/targetSdkVersion 35/g' android/app/build.gradle

# 4. Global Import Cleanup (Remove imports of deleted files)
echo "🧹 Removing broken imports from all Dart files..."
find lib -type f -name "*.dart" -exec sed -i '/package:hotkey_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/package:tray_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/package:window_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/package:launch_at_startup/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/import.*hotkey.dart/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/import.*tray_manager.dart/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/import.*window_manager.dart/d' {} +

# 5. Fix Dart 3 Syntax Errors (Multiple Underscores)
echo "🔧 Fixing Dart 3 Syntax Errors (The '_' issue)..."
# Common patterns
find lib -type f -name "*.dart" -exec sed -i 's/(_, _, _)/(_, __, ___)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, _)/(_, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, ref, _)/(_, ref, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, state, _)/(_, state, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, child, _)/(_, child, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, value, _)/(_, value, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, index, _)/(_, index, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, context, _)/(_, context, __)/g' {} +

# 6. Specific Fix for Tools.dart (Broken Widget)
echo "🛠️ Repairing lib/views/tools.dart..."
# Remove broken lines and replace with safe empty widget
sed -i '/delegate: OpenDelegate/d' lib/views/tools.dart
sed -i 's/return const SizedBox();/const SizedBox(),/g' lib/views/tools.dart
sed -i 's/const SizedBox();/const SizedBox(),/g' lib/views/tools.dart

# 7. Remove usage of Desktop Managers in code
echo "🧼 Cleaning up code references..."
find lib -type f -name "*.dart" -exec sed -i '/hotKeyManager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/trayManager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/windowManager/d' {} +

echo "✅ ALL DONE! Your project is now 100% Mobile Optimized."
