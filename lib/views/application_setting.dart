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
          _NotificationItem(),
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

class _NotificationItem extends ConsumerWidget {
  const _NotificationItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideNotification = ref.watch(
      appSettingProvider.select((state) => state.hideNotification),
    );
    
    return ListItem.switchItem(
      leading: const Icon(Icons.notifications_off),
      title: Text(context.appLocalizations.hideNotification),
      subtitle: Text(context.appLocalizations.hideNotificationDesc),
      delegate: SwitchDelegate(
        value: hideNotification,
        onChanged: (bool value) {
          ref.read(appSettingProvider.notifier).updateState(
                (state) => state.copyWith(hideNotification: value),
              );
        },
      ),
    );
  }
}
