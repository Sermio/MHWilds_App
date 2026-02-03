import 'package:flutter/material.dart';

class Cchip<T> extends StatelessWidget {
  // final T item;
  // final T chipItem;
  final String itemName;
  final Color Function(String) getItemColor;
  final Widget? optionalWidget;
  final VoidCallback? onTap;

  const Cchip({
    super.key,
    // required this.item,
    // required this.chipItem,
    required this.itemName,
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
        backgroundColor: getItemColor(itemName),
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
