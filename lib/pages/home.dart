import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/enum/enum.dart';
import 'package:sensei_tunnel/manager/app_manager.dart';
import 'package:sensei_tunnel/providers/providers.dart';
import 'package:sensei_tunnel/state.dart';
import 'package:sensei_tunnel/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // নতুন ইমপোর্ট
import 'package:shared_preferences/shared_preferences.dart'; // নতুন ইমপোর্ট

typedef OnSelected = void Function(int index);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeBackScopeContainer(
      child: AppSidebarContainer(
        child: Material(
          color: context.colorScheme.surface,
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(navigationStateProvider);
              final isMobile = state.viewMode == ViewMode.mobile;
              final navigationItems = state.navigationItems;
              final pageView = _HomePageView(
                pageBuilder: (_, index) {
                  final navigationItem = state.navigationItems[index];
                  final navigationView = navigationItem.builder(context);
                  final view = KeepScope(
                    keep: navigationItem.keep,
                    child: isMobile
                        ? navigationView
                        : Navigator(
                            pages: [MaterialPage(child: navigationView)],
                            onDidRemovePage: (_) {},
                          ),
                  );
                  return view;
                },
              );
              final currentIndex = state.currentIndex;
              final bottomNavigationBar = NavigationBarTheme(
                data: _NavigationBarDefaultsM3(context),
                child: NavigationBar(
                  destinations: navigationItems
                      .map(
                        (e) => NavigationDestination(
                          icon: e.icon,
                          label: Intl.message(e.label.name),
                        ),
                      )
                      .toList(),
                  onDestinationSelected: (index) {
                    globalState.appController.toPage(
                      navigationItems[index].label,
                    );
                  },
                  selectedIndex: currentIndex,
                ),
              );
              if (isMobile) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: globalState.appState.systemUiOverlayStyle.copyWith(
                    systemNavigationBarColor:
                        context.colorScheme.surfaceContainer,
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: MediaQuery.removePadding(
                          removeTop: false,
                          removeBottom: true,
                          removeLeft: true,
                          removeRight: true,
                          context: context,
                          child: pageView,
                        ),
                      ),
                      MediaQuery.removePadding(
                        removeTop: true,
                        removeBottom: false,
                        removeLeft: true,
                        removeRight: true,
                        context: context,
                        child: bottomNavigationBar,
                      ),
                    ],
                  ),
                );
              } else {
                return pageView;
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HomePageView extends ConsumerStatefulWidget {
  final IndexedWidgetBuilder pageBuilder;

  const _HomePageView({required this.pageBuilder});

  @override
  ConsumerState createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<_HomePageView> {
  late PageController _pageController;

  @override
  initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    
    // অ্যাপ ওপেন হওয়ার পর ডায়ালগ দেখানোর লজিক
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showHackerJoinDialog();
    });

    ref.listenManual(currentPageLabelProvider, (prev, next) {
      if (prev != next) {
        _toPage(next);
      }
    });
    ref.listenManual(currentNavigationItemsStateProvider, (prev, next) {
      if (prev?.value.length != next.value.length) {
        _updatePageController();
      }
    });
  }

  // --- হ্যাকার স্টাইল ডায়ালগ বক্স ফাংশন ---
  void _showHackerJoinDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isHidden = prefs.getBool('hide_sensei_dialog') ?? false;

    if (isHidden == true) return;

    bool tempCheck = false;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF39FF14), width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                "SYSTEM ANNOUNCEMENT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF39FF14),
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome to Sensei Tunnel.\nAccessing secure protocols...\nJoin our community for the latest updates.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: tempCheck,
                        activeColor: const Color(0xFF39FF14),
                        checkColor: Colors.black,
                        onChanged: (val) {
                          setState(() {
                            tempCheck = val!;
                          });
                        },
                      ),
                      const Text(
                        "Don't show this again",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("IGNORE", style: TextStyle(color: Colors.redAccent)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39FF14),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (tempCheck) {
                      await prefs.setBool('hide_sensei_dialog', true);
                    }
                    final url = Uri.parse('https://t.me/JubairSensei'); // এখানে আপনার লিংক দিন
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text("JOIN CHANNEL", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  int get _pageIndex {
    final navigationItems = ref.read(currentNavigationItemsStateProvider).value;
    return navigationItems.indexWhere(
      (item) => item.label == globalState.appState.pageLabel,
    );
  }

  Future<void> _toPage(
    PageLabel pageLabel, [
    bool ignoreAnimateTo = false,
  ]) async {
    if (!mounted) {
      return;
    }
    final navigationItems = ref.read(currentNavigationItemsStateProvider).value;
    final index = navigationItems.indexWhere((item) => item.label == pageLabel);
    if (index == -1) {
      return;
    }
    final isAnimateToPage = ref.read(appSettingProvider).isAnimateToPage;
    final isMobile = ref.read(isMobileViewProvider);
    if (isAnimateToPage && isMobile && !ignoreAnimateTo) {
      await _pageController.animateToPage(
        index,
        duration: kTabScrollDuration,
        curve: Curves.easeOut,
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  void _updatePageController() {
    final pageLabel = globalState.appState.pageLabel;
    _toPage(pageLabel, true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = ref.watch(
      currentNavigationItemsStateProvider.select((state) => state.value.length),
    );
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return widget.pageBuilder(context, index);
      },
    );
  }
}

class _NavigationBarDefaultsM3 extends NavigationBarThemeData {
  _NavigationBarDefaultsM3(this.context)
    : super(
        height: 80.0,
        elevation: 3.0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get backgroundColor => _colors.surfaceContainer;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  WidgetStateProperty<IconThemeData?>? get iconTheme {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      return IconThemeData(
        size: 24.0,
        color: states.contains(WidgetState.disabled)
            ? _colors.onSurfaceVariant.opacity38
            : states.contains(WidgetState.selected)
            ? _colors.onSecondaryContainer
            : _colors.onSurfaceVariant,
      );
    });
  }

  @override
  Color? get indicatorColor => _colors.secondaryContainer;

  @override
  ShapeBorder? get indicatorShape => const StadiumBorder();

  @override
  WidgetStateProperty<TextStyle?>? get labelTextStyle {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      final TextStyle style = _textTheme.labelMedium!;
      return style.apply(
        overflow: TextOverflow.ellipsis,
        color: states.contains(WidgetState.disabled)
            ? _colors.onSurfaceVariant.opacity38
            : states.contains(WidgetState.selected)
            ? _colors.onSurface
            : _colors.onSurfaceVariant,
      );
    });
  }
}

class HomeBackScopeContainer extends ConsumerWidget {
  final Widget child;

  const HomeBackScopeContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    return CommonPopScope(
      onPop: (context) async {
        final pageLabel = ref.read(currentPageLabelProvider);
        final realContext =
            GlobalObjectKey(pageLabel).currentContext ?? context;
        final canPop = Navigator.canPop(realContext);
        if (canPop) {
          Navigator.of(realContext).pop();
        } else {
          await globalState.appController.handleBackOrExit();
        }
        return false;
      },
      child: child,
    );
  }
}