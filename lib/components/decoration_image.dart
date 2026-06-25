import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';

class DecorationAssetImage extends StatelessWidget {
  const DecorationAssetImage({
    super.key,
    required this.decoration,
    this.width = 35,
    this.height = 35,
    this.fallbackLevel = 1,
  });

  final DecorationItem decoration;
  final double width;
  final double height;
  final int fallbackLevel;

  static final Map<String, String?> _assetCache = {};

  String? _getAssetPathSync() {
    final color = decoration.icon.color;
    final kind = decoration.kind;
    final key = '${decoration.name}|${kind}|${color}|${decoration.slot}';
    if (_assetCache.containsKey(key)) return _assetCache[key];

    final assetPath = ItemIconAssetResolver.resolveDecorationSync(
      apiColor: color,
      decorationName: decoration.name,
      apiKind: kind,
      slot: decoration.slot,
    );
    _assetCache[key] = assetPath;
    return assetPath;
  }

  @override
  Widget build(BuildContext context) {
    final fallbackPath = 'assets/imgs/decorations/gem_level_$fallbackLevel.webp';
    final assetPath = _getAssetPathSync();

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          fallbackPath,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/imgs/decorations/default_jewel.webp',
            width: width,
            height: height,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Image.asset(
      fallbackPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Image.asset(
        'assets/imgs/decorations/default_jewel.webp',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
