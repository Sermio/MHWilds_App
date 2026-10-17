import 'package:flutter/material.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:provider/provider.dart';

/// Imagen de cabecera del monstruo (con placeholder si no existe).
class MonsterHeaderImage extends StatelessWidget {
  final int monsterId;
  final String monsterName;

  const MonsterHeaderImage({
    super.key,
    required this.monsterId,
    required this.monsterName,
  });

  @override
  Widget build(BuildContext context) {
    final imageName = context
        .watch<EnNamesCache>()
        .nameForMonsterImage(monsterId, monsterName);

    if (imageName == null) {
      // Cache no cargado, mostrar placeholder
      return const _ImagePlaceholder();
    }

    final imagePath =
        'assets/imgs/monsters/${imageName.toLowerCase().replaceAll(' ', '_')}.webp';
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
