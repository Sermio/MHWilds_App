import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Cabecera de sección común a monstruos, armas y armaduras: icono dorado
/// sobre fondo tonal + título en la fuente de títulos. [fill] hace que el
/// texto ocupe el espacio libre (para colocar acciones a la derecha);
/// [trailing] es ese contenido.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    required this.icon,
    this.fill = false,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final bool fill;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: colorScheme.onSurface),
    );
    return Row(
      mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        fill ? Expanded(child: text) : Flexible(child: text),
        if (trailing != null) trailing!,
      ],
    );
  }
}
