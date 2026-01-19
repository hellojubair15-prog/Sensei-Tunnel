import 'package:flutter/material.dart';

class Tray {
  Future<void> init() async {}
  Future<void> setIcon(String icon) async {}
  Future<void> setToolTip(String tooltip) async {}
  Future<void> setContextMenu(Menu menu) async {}
}

final Tray? tray = Tray();

class Menu {
  Menu({required List<MenuItem> items});
}

class MenuItem {
  MenuItem({String? label, Function? onClick});
  MenuItem.separator();
  MenuItem.checkbox({String? label, bool? checked, Function? onClick});
  MenuItem.submenu({String? label, Menu? submenu});
}
