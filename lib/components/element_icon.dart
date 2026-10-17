import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/game_element.dart';

/// Icono de un elemento o estado por id, con etiqueta traducida para lectores
/// de pantalla. Sin icono para ese id (p. ej. un vial `impact`) muestra
/// [fallback], o un hueco del mismo tamaño.
class ElementIcon extends StatelessWidget {
  const ElementIcon(this.id,
      {super.key, this.size = 25, this.fit, this.fallback});

  final String id;
  final double size;
  final BoxFit? fit;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final element = GameElement.fromId(id);
    final replacement = fallback ?? SizedBox(width: size, height: size);
    if (element == null) return replacement;
    return AssetThumb(
      element.asset,
      height: size,
      fit: fit,
      semanticLabel: element.label(AppLocalizations.of(context)!),
      errorBuilder: (_, __, ___) => replacement,
    );
  }
}
