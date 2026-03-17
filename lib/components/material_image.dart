import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MaterialImage extends StatelessWidget {
  const MaterialImage({
    super.key,
    required this.materialName,
    this.item,
    this.width = 50,
    this.height = 50,
  });

  final String materialName;
  final Item? item;
  final double width;
  final double height;

  static final Map<String, String?> _urlCache = {};
  static final Map<String, String?> _assetCache = {};

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

  Future<String?> _getAssetPath() async {
    final icon = item?.icon;
    if (icon == null) return null;
    final key = '${icon.kind}|${icon.color}';
    if (_assetCache.containsKey(key)) {
      return _assetCache[key];
    }

    final assetPath = await ItemIconAssetResolver.resolve(
      apiKind: icon.kind,
      apiColor: icon.color,
    );
    _assetCache[key] = assetPath;
    return assetPath;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String?>>(
      future: Future.wait([_getAssetPath(), _getImageUrl()]),
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
          final assetPath = snapshot.data![0];
          final networkUrl = snapshot.data![1];

          if (assetPath != null) {
            return Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/imgs/materials/default_material.webp',
                width: width,
                height: height,
              ),
            );
          }

          if (networkUrl != null) {
            return Image.network(
              networkUrl,
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

          return Image.asset(
            'assets/imgs/materials/default_material.webp',
            width: width,
            height: height,
          );
        }
      },
    );
  }
}
