import 'package:sensei_tunnel/views/backup_and_recovery.dart';
import 'package:sensei_tunnel/views/backup_and_recovery.dart';
import 'dart:io';

import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/l10n/l10n.dart';
import 'package:sensei_tunnel/models/models.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:sensei_tunnel/state.dart';
import 'package:sensei_tunnel/views/about.dart';
import 'package:sensei_tunnel/views/access.dart';
import 'package:sensei_tunnel/views/application_setting.dart';
import 'package:sensei_tunnel/views/config/config.dart';
import 'package:sensei_tunnel/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show dirname, join;

import 'backup_and_recovery.dart';
import 'config/advanced.dart';
import 'developer.dart';
import 'theme.dart';

class ToolsView extends ConsumerStatefulWidget {
  const ToolsView({super.key});

  @override
  ConsumerState<ToolsView> createState() => _ToolViewState();
}

class _ToolViewState extends ConsumerState<ToolsView> {
  Widget _buildNavigationMenuItem(NavigationItem navigationItem) {
    return ListItem(
      leading: navigationItem.icon,
      title: Text(Intl.message(navigationItem.label.name)),
      subtitle: navigationItem.description != null
          ? Text(Intl.message(navigationItem.description!))
          : null,
      onTap: () {
        // Custom navigation logic if needed, empty for now to prevent crash
      },
    );
  }

  Widget _buildNavigationMenu(List<NavigationItem> navigationItems) {
    return Column(
      children: [
        for (final navigationItem in navigationItems) ...[
          _buildNavigationMenuItem(navigationItem),
          navigationItems.last != navigationItem
              ? const Divider(height: 0)
              : Container(),
        ],
      ],
    );
  }

  List<Widget> _getOtherList(bool enableDeveloperMode) {
    return generateSection(
      title: context.appLocalizations.other,
      items: [
        const _DisclaimerItem(),
        if (enableDeveloperMode) const _DeveloperItem(),
        const _InfoItem(),
      ],
    );
  }

  List<Widget> _getSettingList() {
    return generateSection(
      title: context.appLocalizations.settings,
      items: [
        const _LocaleItem(),
        const _ThemeItem(),
        const _BackupItem(),
        // Desktop items removed/hidden
        if (system.isWindows) const _LoopbackItem(),
        if (system.isAndroid) const _AccessItem(),
        const _ConfigItem(),
        const _AdvancedConfigItem(),
        const _SettingItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm2 = ref.watch(
      appSettingProvider.select(
        (state) => VM2(a: state.locale, b: state.developerMode),
      ),
    );
    final items = [
      Consumer(
        builder: (_, ref, __) {
          final state = ref.watch(moreToolsSelectorStateProvider);
          if (state.navigationItems.isEmpty) {
            return Container();
          }
          return Column(
            children: [
              ListHeader(title: context.appLocalizations.more),
              _buildNavigationMenu(state.navigationItems),
            ],
          );
        },
      ),
      ..._getSettingList(),
      ..._getOtherList(vm2.b),
    ];
    return CommonScaffold(
      title: context.appLocalizations.tools,
      body: ListView.builder(
        key: toolsStoreKey,
        itemCount: items.length,
        itemBuilder: (_, index) => items[index],
        padding: const EdgeInsets.only(bottom: 20),
      ),
    );
  }
}

class _LocaleItem extends ConsumerWidget {
  const _LocaleItem();

  String _getLocaleString(Locale? locale) {
    if (locale == null) return appLocalizations.defaultText;
    return Intl.message(locale.toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final subTitle = locale ?? context.appLocalizations.defaultText;
    final currentLocale = utils.getLocaleForString(locale);
    return ListItem<Locale?>.options(
      leading: const Icon(Icons.language_outlined),
      title: Text(context.appLocalizations.language),
      subtitle: Text(Intl.message(subTitle)),
      delegate: OptionsDelegate(
        title: context.appLocalizations.language,
        options: [null, ...AppLocalizations.delegate.supportedLocales],
        onChanged: (Locale? locale) {
          ref
              .read(appSettingProvider.notifier)
              .updateState(
                (state) => state.copyWith(locale: locale?.toString()),
              );
        },
        textBuilder: (locale) => _getLocaleString(locale),
        value: currentLocale,
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.style),
      title: Text(context.appLocalizations.theme),
      subtitle: Text(context.appLocalizations.themeDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ThemeView()),
        );
      },
    );
  }
}

class _BackupItem extends StatelessWidget {
  const _BackupItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.cloud_sync),
      title: Text(context.appLocalizations.backupAndRecovery),
      subtitle: Text(context.appLocalizations.backupAndRecoveryDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BackupAndRecoveryView()),
        );
      },
    );
  }
}

class _HotkeyItem extends StatelessWidget {
  const _HotkeyItem();

  @override
  Widget build(BuildContext context) {
    // Desktop feature disabled for mobile build
    return const SizedBox();
  }
}

class _LoopbackItem extends StatelessWidget {
  const _LoopbackItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.lock),
      title: Text(context.appLocalizations.loopback),
      subtitle: Text(context.appLocalizations.loopbackDesc),
      onTap: () {
        if (Platform.isWindows) {
            windows?.runas(
            '"${join(dirname(Platform.resolvedExecutable), "EnableLoopback.exe")}"',
            '',
            );
        }
      },
    );
  }
}

class _AccessItem extends StatelessWidget {
  const _AccessItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.view_list),
      title: Text(context.appLocalizations.accessControl),
      subtitle: Text(context.appLocalizations.accessControlDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AccessView()),
        );
      },
    );
  }
}

class _ConfigItem extends StatelessWidget {
  const _ConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.edit),
      title: Text(context.appLocalizations.basicConfig),
      subtitle: Text(context.appLocalizations.basicConfigDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ConfigView()),
        );
      },
    );
  }
}

class _AdvancedConfigItem extends StatelessWidget {
  const _AdvancedConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.build),
      title: Text(context.appLocalizations.advancedConfig),
      subtitle: Text(context.appLocalizations.advancedConfigDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AdvancedConfigView()),
        );
      },
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.settings),
      title: Text(context.appLocalizations.application),
      subtitle: Text(context.appLocalizations.applicationDesc),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ApplicationSettingView()),
        );
      },
    );
  }
}

class _DisclaimerItem extends StatelessWidget {
  const _DisclaimerItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.gavel),
      title: Text(context.appLocalizations.disclaimer),
      onTap: () async {
        final isDisclaimerAccepted = await globalState.appController
            .showDisclaimer();
        if (!isDisclaimerAccepted) {
          globalState.appController.handleExit();
        }
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.info),
      title: Text(context.appLocalizations.about),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AboutView()),
        );
      },
    );
  }
}

class _DeveloperItem extends StatelessWidget {
  const _DeveloperItem();

  @override
  Widget build(BuildContext context) {
    return ListItem(
      leading: const Icon(Icons.developer_board),
      title: Text(context.appLocalizations.developerMode),
       onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DeveloperView()),
        );
      },
    );
  }
}