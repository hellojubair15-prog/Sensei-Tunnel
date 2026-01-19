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
