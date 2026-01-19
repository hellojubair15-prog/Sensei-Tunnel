#!/bin/bash

echo "☢️ INITIATING NUCLEAR FIX PROTOCOL..."

# -------------------------------------------
# 1. FIX ANDROID SDK VERSION (CRITICAL)
# -------------------------------------------
echo "📱 Upgrading Android SDK to 36 (Required by latest plugins)..."
# build.gradle.kts ফাইলের SDK ভার্সন আপডেট করা
sed -i 's/compileSdk = .*/compileSdk = 36/g' android/app/build.gradle.kts
sed -i 's/targetSdk = .*/targetSdk = 36/g' android/app/build.gradle.kts
# যদি পুরনো build.gradle থাকে, সেখানেও আপডেট করা
sed -i 's/compileSdkVersion .*/compileSdkVersion 36/g' android/app/build.gradle
sed -i 's/targetSdkVersion .*/targetSdkVersion 36/g' android/app/build.gradle

# -------------------------------------------
# 2. REMOVE DESKTOP DEPENDENCIES FROM PUBSPEC
# -------------------------------------------
echo "📦 Removing desktop-only packages from pubspec.yaml..."
sed -i '/screen_retriever/d' pubspec.yaml
sed -i '/window_manager/d' pubspec.yaml
sed -i '/tray_manager/d' pubspec.yaml
sed -i '/hotkey_manager/d' pubspec.yaml
sed -i '/launch_at_startup/d' pubspec.yaml
sed -i '/window_ext/d' pubspec.yaml

# -------------------------------------------
# 3. CLEAN DART FILES (REMOVE IMPORTS)
# -------------------------------------------
echo "🧹 Scrubbing all Dart files for desktop imports..."
# screen_retriever (বর্তমান এরর)
find lib -type f -name "*.dart" -exec sed -i '/package:screen_retriever/d' {} +
# window_manager
find lib -type f -name "*.dart" -exec sed -i '/package:window_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/windowManager/d' {} +
# tray_manager
find lib -type f -name "*.dart" -exec sed -i '/package:tray_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/trayManager/d' {} +
# hotkey_manager
find lib -type f -name "*.dart" -exec sed -i '/package:hotkey_manager/d' {} +
find lib -type f -name "*.dart" -exec sed -i '/hotKeyManager/d' {} +

# -------------------------------------------
# 4. DELETE DESKTOP SPECIFIC FILES
# -------------------------------------------
echo "🗑️ Deleting known desktop-only files..."
rm -f lib/manager/hotkey_manager.dart
rm -f lib/manager/tray_manager.dart
rm -f lib/manager/window_manager.dart
rm -f lib/views/hotkey.dart
rm -rf plugins/window_ext

# -------------------------------------------
# 5. FIX SYNTAX ERRORS (DART 3 & TOOLS.DART)
# -------------------------------------------
echo "🔧 Applying final syntax fixes..."
# tools.dart এর সেই সেমিকোলন সমস্যা ফিক্স করা
sed -i 's/return const SizedBox();/const SizedBox(),/g' lib/views/tools.dart
sed -i 's/const SizedBox();/const SizedBox(),/g' lib/views/tools.dart

# Dart 3 Underscore fixes (Just in case some are left)
find lib -type f -name "*.dart" -exec sed -i 's/(_, _, _)/(_, __, ___)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, state, _)/(_, state, __)/g' {} +
find lib -type f -name "*.dart" -exec sed -i 's/(_, context, _)/(_, context, __)/g' {} +

echo "✅ NUCLEAR CLEANUP COMPLETE. READY TO BUILD."
