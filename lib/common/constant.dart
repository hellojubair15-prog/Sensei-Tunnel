// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:sensei_tunnel/common/common.dart';
import 'package:sensei_tunnel/enum/enum.dart';
import 'package:sensei_tunnel/models/models.dart';
import 'package:flutter/material.dart';

// --- মডিফাইড ক্রেডিট এবং নাম ---
const appName = 'Sensei Tunnel';
const appHelperService = 'SenseiTunnelHelperService';
const coreName = 'clash.meta';
const browserUa =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
const packageName = 'com.sensei.tunnel';
final unixSocketPath = '/tmp/SenseiTunnelSocket_${Random().nextInt(10000)}.sock';
const helperPort = 47890;
const maxTextScale = 1.4;
const minTextScale = 0.8;

// --- আপনার গিটহাব রিপোজিটরি ---
const repository = 'jubairsensei/Sensei Tunnel';

// --- হ্যাকার থিম কালার (নিওন গ্রিন) ---
const defaultPrimaryColor = 0xFF39FF14; 

const defaultPrimaryColors = [
  0xFF00FF00, // Pure Green
  0xFF39FF14, // Neon Green
  0xFF008000, // Dark Green
  0xFF00FF7F, // Spring Green
  0xFF004D40, // Teal Green
  0xFF2E7D32, // Forest Green
  0xFF000000, // Black
];

final baseInfoEdgeInsets = EdgeInsets.symmetric(
  vertical: 16.ap,
  horizontal: 16.ap,
);
final listHeaderPadding = EdgeInsets.only(
  left: 16.ap,
  right: 8.ap,
  top: 24.ap,
  bottom: 8.ap,
);

final defaultTextScaleFactor =
    WidgetsBinding.instance.platformDispatcher.textScaleFactor;
const httpTimeoutDuration = Duration(milliseconds: 5000);
const moreDuration = Duration(milliseconds: 100);
const animateDuration = Duration(milliseconds: 100);
const midDuration = Duration(milliseconds: 200);
const commonDuration = Duration(milliseconds: 300);
const defaultUpdateDuration = Duration(days: 1);
const MMDB = 'GEOIP.metadb';
const ASN = 'ASN.mmdb';
const GEOIP = 'GEOIP.dat';
const GEOSITE = 'GEOSITE.dat';
final double kHeaderHeight = system.isDesktop
    ? !system.isMacOS
          ? 40
          : 28
    : 0;
const profilesDirectoryName = 'profiles';
const localhost = '127.0.0.1';
const clashConfigKey = 'clash_config';
const configKey = 'config';
const double dialogCommonWidth = 300;
const defaultExternalController = '127.0.0.1:9090';
const maxMobileWidth = 600;
const maxLaptopWidth = 840;
const defaultTestUrl = 'https://www.gstatic.com/generate_204';
final commonFilter = ImageFilter.blur(
  sigmaX: 5,
  sigmaY: 5,
  tileMode: TileMode.mirror,
);

const navigationItemListEquality = ListEquality<NavigationItem>();
const trackerInfoListEquality = ListEquality<TrackerInfo>();
const stringListEquality = ListEquality<String>();
const intListEquality = ListEquality<int>();
const logListEquality = ListEquality<Log>();
const groupListEquality = ListEquality<Group>();
const ruleListEquality = ListEquality<Rule>();
const scriptEquality = ListEquality<Script>();
const externalProviderListEquality = ListEquality<ExternalProvider>();
const packageListEquality = ListEquality<Package>();
const hotKeyActionListEquality = ListEquality<HotKeyAction>();
const stringAndStringMapEquality = MapEquality<String, String>();
const stringAndStringMapEntryListEquality =
    ListEquality<MapEntry<String, String>>();
const stringAndStringMapEntryIterableEquality =
    IterableEquality<MapEntry<String, String>>();
const delayMapEquality = MapEquality<String, Map<String, int?>>();
const stringSetEquality = SetEquality<String>();
const keyboardModifierListEquality = SetEquality<KeyboardModifier>();

const viewModeColumnsMap = {
  ViewMode.mobile: [2, 1],
  ViewMode.laptop: [3, 2],
  ViewMode.desktop: [4, 3],
};

const proxiesListStoreKey = PageStorageKey<String>('proxies_list');
const toolsStoreKey = PageStorageKey<String>('tools');
const profilesStoreKey = PageStorageKey<String>('profiles');

double getWidgetHeight(num lines) {
  return max(lines * 80 + (lines - 1) * 16, 0).ap;
}

const maxLength = 1000;

final mainIsolate = 'SenseiTunnelMainIsolate';
final serviceIsolate = 'SenseiTunnelServiceIsolate';

const scriptTemplate = '''
const main = (config) => {
  return config;
}''';
