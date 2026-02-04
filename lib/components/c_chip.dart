import 'package:flutter/material.dart';

class Cchip<T> extends StatelessWidget {
  final String itemName;

  /// ID del mapa/zona para asignar color (p. ej. 1-5). Se usa con [getItemColor].
  final int itemIdForColor;
  final Color Function(int) getItemColor;
  final Widget? optionalWidget;
  final VoidCallback? onTap;

  const Cchip({
    super.key,
    required this.itemName,
    required this.itemIdForColor,
    required this.getItemColor,
    this.optionalWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        elevation: 0,
        backgroundColor: getItemColor(itemIdForColor),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              itemName.isNotEmpty ? itemName : "Unknown",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            if (optionalWidget != null) ...[
              const SizedBox(width: 6),
              optionalWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
