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
    final background = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      children: [
        Image.asset(
          imagePath,
          width: 380,
          height: 250,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) =>
              const _ImagePlaceholder(),
        ),
        // Funde el borde inferior con el fondo en lugar de un corte recto.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.6, 1],
                colors: [background.withValues(alpha: 0), background],
              ),
            ),
          ),
        ),
      ],
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
