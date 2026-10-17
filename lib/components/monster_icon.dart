import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/utils/asset_ids.g.dart';

/// Icono local del monstruo por id, o un placeholder si no hay asset.
class MonsterIcon extends StatelessWidget {
  const MonsterIcon(this.monsterId, {super.key, this.placeholderIconSize});

  final int monsterId;
  final double? placeholderIconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported,
          color: colorScheme.onSurfaceVariant, size: placeholderIconSize),
    );
    final path = monsterIconAssets[monsterId];
    if (path == null) return placeholder;
    return AssetThumb(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
