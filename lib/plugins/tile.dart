import 'package:flutter/material.dart';

// Dummy Tile implementation for Mobile
class Tile {
  void addListener(TileListener listener) {}
  void removeListener(TileListener listener) {}
}

final Tile? tile = Tile();

mixin TileListener {
  void onStop() {}
}
