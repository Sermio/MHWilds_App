import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/sprite_icon.dart';

const String kDecorationsSpriteSheetAssetPath =
    'assets/imgs/sprites/decorations.webp';
const int _decorationsSpriteColumns = 20;

const Map<int, int> decorationColumnBySlot = {
  1: 0,
  2: 5,
  3: 10,
  4: 15,
};

class DecorationSpriteIcon extends StatelessWidget {
  const DecorationSpriteIcon({
    super.key,
    required this.slot,
    required this.size,
    required this.fallback,
    this.assetPath = kDecorationsSpriteSheetAssetPath,
    this.row = 0,
  });

  final int slot;
  final double size;
  final Widget fallback;
  final String assetPath;
  final int row;

  @override
  Widget build(BuildContext context) {
    final column = decorationColumnBySlot[slot];
    if (column == null) {
      return SizedBox(width: size, height: size, child: fallback);
    }
    return SpriteIcon(
      sheetAsset: assetPath,
      columns: _decorationsSpriteColumns,
      column: column,
      row: row,
      size: size,
      fallback: fallback,
    );
  }
}
