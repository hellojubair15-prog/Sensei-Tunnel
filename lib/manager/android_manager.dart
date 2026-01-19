import 'package:sensei_tunnel/core/core.dart';
import 'package:sensei_tunnel/enum/enum.dart';
import 'package:sensei_tunnel/models/core.dart';
import 'package:sensei_tunnel/plugins/app.dart';
import 'package:sensei_tunnel/plugins/service.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AndroidManager extends ConsumerStatefulWidget {
  final Widget child;

  const AndroidManager({super.key, required this.child});

  @override
  ConsumerState<AndroidManager> createState() => _AndroidContainerState();
}

class _AndroidContainerState extends ConsumerState<AndroidManager>
    with ServiceListener {
  @override
  void initState() {
    super.initState();
    ref.listenManual(appSettingProvider.select((state) => state.hidden), (
      prev,
      next,
    ) {
      app?.updateExcludeFromRecents(next);
    }, fireImmediately: true);
    ref.listenManual(androidStateProvider, (prev, next) {
      if (prev != next) {
        service?.syncAndroidState(next);
      }
    });
    service?.addListener(this);
  }

  @override
  Future<void> dispose() async {
    service?.removeListener(this);
    super.dispose();
  }

  @override
  void onServiceEvent(CoreEvent event) {
    coreEventManager.sendEvent(event);
    super.onServiceEvent(event);
  }

  @override
  void onServiceCrash(String message) {
    coreEventManager.sendEvent(
      CoreEvent(type: CoreEventType.crash, data: message),
    );
    super.onServiceCrash(message);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
