import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/label_value_row.dart';

/// Fila de estadística de los detalles de armas y armaduras: nombre a la
/// izquierda y valor a la derecha. [value] admite cualquier widget; con [text]
/// se muestra como texto normal.
class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.title, this.value, this.text = ''});

  final String title;
  final Widget? value;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return LabelValueRow(
      label: Text(
        '$title:',
        style: textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8)),
      ),
      value: value ??
          Text(
            text,
            style: textTheme.bodyLarge!.copyWith(
                color: colorScheme.onSurface, fontWeight: FontWeight.w500),
          ),
    );
  }
}
