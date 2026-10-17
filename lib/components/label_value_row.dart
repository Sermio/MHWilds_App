import 'package:flutter/material.dart';

/// Etiqueta a la izquierda y valor a la derecha. Si ambos no caben en una
/// línea (alemán, texto grande), el valor pasa a la línea siguiente en lugar
/// de desbordar, como haría un `Row` con `Spacer`.
class LabelValueRow extends StatelessWidget {
  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.runSpacing = 4,
  });

  final Widget label;
  final Widget value;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: runSpacing,
      children: [label, value],
    );
  }
}
