import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MaterialImage extends StatelessWidget {
  const MaterialImage({
    super.key,
    required this.materialName,
    this.width = 50,
    this.height = 50,
  });

  final String materialName;
  final double width;
  final double height;

  static final Map<String, String?> _urlCache = {};

  String get formattedMaterialName {
    return materialName
        .replaceAll(RegExp(r'\s\+'), '+')
        .replaceAll(RegExp(r'[()]'), '')
        .toLowerCase()
        .replaceAll(' ', '_');
  }

  Future<String?> _getImageUrl() async {
    if (_urlCache.containsKey(formattedMaterialName)) {
      return _urlCache[formattedMaterialName];
    }

    final url = await getValidItemImageUrl(formattedMaterialName);
    _urlCache[formattedMaterialName] = url;
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: height,
            width: width,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Image.asset(
            'assets/imgs/materials/default_material.webp',
            width: width,
            height: height,
          );
        } else {
          return Image.network(
            snapshot.data!,
            height: height,
            width: width,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: height,
                width: width,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/imgs/materials/default_material.webp',
                width: width,
                height: height,
              );
            },
          );
        }
      },
    );
  }
}
