import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

/// Panel reutilizable para filtros: contenedor con header fijo y contenido con scroll.
///
/// Importante: este widget NO aplica lógica de filtros; solo compone UI.
class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.height,
    required this.onReset,
    required this.child,
    this.title,
  });

  final double height;
  final VoidCallback onReset;
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final panelTitle = title ?? l10n.filters;

    return Container(
      margin: const EdgeInsets.all(16),
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header fijo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  panelTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.reset),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          // Contenido con scroll (lo aporta cada pantalla)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
