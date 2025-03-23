import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MaterialImage extends StatelessWidget {
  const MaterialImage({
    super.key,
    required this.materialName,
  });

  final String materialName;

  @override
  Widget build(BuildContext context) {
    String formattedMaterialName = materialName
        .replaceAll(RegExp(r'\s\+'), '+')
        .replaceAll(RegExp(r'[()]'), '');

    return FadeIn(
      child: Image.network(
        height: 50,
        width: 50,
        'https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${formattedMaterialName.toLowerCase().replaceAll(' ', '_')}_item_equipment_material_mhwilds_wiki_guide_85px.png',
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
          return Image.asset('assets/imgs/materials/default_material.webp');
        },
      ),
    );
  }
}
