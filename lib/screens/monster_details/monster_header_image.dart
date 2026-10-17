import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/asset_ids.g.dart';

/// Imagen de cabecera del monstruo (con placeholder si no existe).
class MonsterHeaderImage extends StatelessWidget {
  final int monsterId;

  const MonsterHeaderImage({super.key, required this.monsterId});

  @override
  Widget build(BuildContext context) {
    final imagePath = monsterImageAssets[monsterId];
    if (imagePath == null) return const _ImagePlaceholder();
    return Image.asset(
      imagePath,
      width: 380,
      height: 250,
      fit: BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 380,
      height: 250,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported,
          color: colorScheme.onSurfaceVariant, size: 64),
    );
  }
}
