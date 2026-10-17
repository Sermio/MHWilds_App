import 'package:flutter/material.dart';

/// Coloca el panel de filtros encima de la lista y la empuja hacia abajo, en
/// vez de superponerse y tapar los primeros elementos. Con [panel] nulo solo
/// muestra [child]. Si no cabe, el panel cede espacio (hace scroll por dentro).
class FilterPanelLayout extends StatelessWidget {
  const FilterPanelLayout(
      {super.key, required this.panel, required this.child});

  final Widget? panel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (panel != null)
          Flexible(
            child: Material(
              elevation: 8,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: panel,
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
