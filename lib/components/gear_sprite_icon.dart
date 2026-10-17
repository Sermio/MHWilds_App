import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/sprite_icon.dart';

const Map<String, int> weaponColumnByKind = {
  'sword-shield': 0,
  'great-sword': 1,
  'long-sword': 2,
  'dual-blades': 3,
  'lance': 4,
  'gunlance': 5,
  'hammer': 6,
  'hunting-horn': 7,
  'switch-axe': 8,
  'charge-blade': 9,
  'insect-glaive': 10,
  'light-bowgun': 11,
  'heavy-bowgun': 12,
  'bow': 13,
};

const Map<String, int> armorColumnByKind = {
  'head': 14,
  'chest': 15,
  'arms': 16,
  'waist': 17,
  'legs': 18,
};

const int talismanColumn = 19;

const String kGearSpriteSheetAssetPath = 'assets/imgs/sprites/gear.webp';
const int _gearSpriteColumns = 20;
const int _gearSpriteRows = 13;

int spriteRowForRarity(int rarity) {
  return rarity.clamp(0, _gearSpriteRows - 1);
}

class GearSpriteIcon extends StatelessWidget {
  const GearSpriteIcon({
    super.key,
    required this.column,
    required this.rarity,
    required this.size,
    required this.fallback,
    this.assetPath = kGearSpriteSheetAssetPath,
  });

  final int column;
  final int rarity;
  final double size;
  final Widget fallback;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SpriteIcon(
      sheetAsset: assetPath,
      columns: _gearSpriteColumns,
      rows: _gearSpriteRows,
      column: column,
      row: spriteRowForRarity(rarity),
      size: size,
      fallback: fallback,
    );
  }
}
