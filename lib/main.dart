import 'dart:async';
import 'dart:io';

import 'package:sensei_tunnel/plugins/app.dart'; // প্যাকেজ নেম আপডেট করা হয়েছে
import 'package:sensei_tunnel/plugins/tile.dart';
import 'package:sensei_tunnel/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application.dart';
import 'common/common.dart';
import 'core/controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ডেস্কটপের জন্য উইন্ডো ম্যানেজার বা অন্য কোনো লজিক এখানে রাখা হয়নি
  // সরাসরি মোবাইল অ্যাপ ইনিশিয়ালাইজেশন
  
  final version = await system.version;
  await globalState.initApp(version);
  
  // HTTP Overrides সেট করা (সবুজ-কালো ব্র্যান্ডিং অনুযায়ী নাম)
  HttpOverrides.global = SenseiTunnelHttpOverrides(); 
  
  runApp(
    ProviderScope(
      child: const Application(),
    ),
  );
}

// অ্যান্ড্রয়েড ভিপিএন সার্ভিসের জন্য এন্ট্রি পয়েন্ট
@pragma('vm:entry-point')
Future<void> _service(List<String> flags) async {
  WidgetsFlutterBinding.ensureInitialized();
  globalState.isService = true;
  await globalState.init();
  await coreController.preload();
  
  tile?.addListener(
    _TileListenerWithService(
      onStop: () async {
        await app?.tip(appLocalizations.stopVpn);
        await globalState.handleStop();
      },
    ),
  );
  
  app?.tip(appLocalizations.startVpn);
  final version = await system.version;
  await coreController.init(version);
  
  final clashConfig = globalState.config.patchClashConfig.copyWith.tun(
    enable: false,
  );
  
  final setupState = globalState.getSetupState(
    globalState.config.currentProfileId,
  );
  
  globalState.setupConfig(
    setupState: setupState,
    patchConfig: clashConfig,
    preloadInvoke: () {
      globalState.handleStart();
    },
  );
}

@immutable
class _TileListenerWithService with TileListener {
  final Function() _onStop;

  const _TileListenerWithService({required Function() onStop})
    : _onStop = onStop;

  @override
  void onStop() {
    _onStop();
  }
}

// HttpOverrides ক্লাস যা কানেকশন হ্যান্ডেল করে
class SenseiTunnelHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
