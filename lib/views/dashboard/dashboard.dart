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
