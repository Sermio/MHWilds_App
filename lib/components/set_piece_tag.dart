import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

enum SetPieceTagVariant { gold, grey }

class SetPieceTag extends StatelessWidget {
  final int count;
  final SetPieceTagVariant variant;
  final double fontSize;
  final EdgeInsets padding;

  const SetPieceTag({
    super.key,
    required this.count,
    this.variant = SetPieceTagVariant.grey,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    
    // Colores basados en las capturas
    final Color bgColor = variant == SetPieceTagVariant.gold 
        ? const Color(0xFFB4964F) // Oro/Mostaza MH
        : const Color(0xFFB0B0B0); // Gris neutral
    
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20), // Forma de píldora
      ),
      child: Text(
        "$count ${l10n.pieces}",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
