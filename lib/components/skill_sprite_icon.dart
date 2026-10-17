import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/sprite_icon.dart';

const String kSkillsSpriteSheetAssetPath = 'assets/imgs/sprites/skills.webp';
const int _skillsSpriteColumns = 14;

const Map<String, int> skillIconIdByKind = {
  'attack': 1,
  'affinity': 2,
  'element': 3,
  'handicraft': 4,
  'ranged': 5,
  'defense': 6,
  'health': 7,
  'stamina': 8,
  'offense': 9,
  'utility': 10,
  'item': 11,
  'gathering': 12,
  'group': 13,
  'set': 14,
};

class SkillSpriteIcon extends StatelessWidget {
  const SkillSpriteIcon({
    super.key,
    required this.size,
    required this.fallback,
    this.iconId,
    this.iconKind,
    this.assetPath = kSkillsSpriteSheetAssetPath,
    this.row = 0,
  });

  final double size;
  final Widget fallback;
  final int? iconId;
  final String? iconKind;
  final String assetPath;
  final int row;

  @override
  Widget build(BuildContext context) {
    final column = _resolveColumn(iconId, iconKind);
    if (column == null) {
      return SizedBox(width: size, height: size, child: fallback);
    }
    return SpriteIcon(
      sheetAsset: assetPath,
      columns: _skillsSpriteColumns,
      column: column,
      row: row,
      size: size,
      fallback: fallback,
    );
  }

  static int? _resolveColumn(int? iconId, String? iconKind) {
    if (iconId != null && iconId >= 1 && iconId <= _skillsSpriteColumns) {
      return iconId - 1;
    }

    if (iconKind != null) {
      final idFromKind = skillIconIdByKind[iconKind.toLowerCase().trim()];
      if (idFromKind != null) return idFromKind - 1;
    }

    return null;
  }
}
