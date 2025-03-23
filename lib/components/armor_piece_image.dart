import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ArmorPieceImage extends StatelessWidget {
  const ArmorPieceImage({
    super.key,
    required this.armorPieceName,
  });

  final String armorPieceName;

  @override
  Widget build(BuildContext context) {
    String formattedArmorPieceName = armorPieceName
        .replaceAll(RegExp(r'\s\+'), '+')
        .replaceAll(RegExp(r'[()]'), '')
        .replaceAllMapped(RegExp(r'\b(alpha|beta)\b$', caseSensitive: false),
            (match) {
      return match.group(1)!.toLowerCase() == 'alpha' ? 'a' : 'b';
    });

    return FadeIn(
      child: Image.network(
        height: 50,
        width: 50,
        'https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${formattedArmorPieceName.toLowerCase().replaceAll(' ', '_')}_arm_typea_mhwilds_wiki_guide_200px.png',
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return SizedBox(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return Image.asset('assets/imgs/drawer/armor.webp');
        },
      ),
    );
  }
}
