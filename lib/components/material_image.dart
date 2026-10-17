import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';

/// Icono local del objeto (por `kind + color`) o el placeholder si no se
/// resuelve.
class MaterialImage extends StatelessWidget {
  const MaterialImage({
    super.key,
    this.item,
    this.width = 50,
    this.height = 50,
  });

  static const _placeholder = 'assets/imgs/materials/default_material.webp';

  final Item? item;
  final double width;
  final double height;

  static final Map<String, String?> _assetCache = {};

  String? _getAssetPathSync() {
    final icon = item?.icon;
    if (icon == null) return null;
    final key = '${icon.kind}|${icon.color}';
    return _assetCache.putIfAbsent(
      key,
      () => ItemIconAssetResolver.resolveSync(
        apiKind: icon.kind,
        apiColor: icon.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = AssetThumb(_placeholder, width: width, height: height);
    final assetPath = _getAssetPathSync();
    if (assetPath == null) return placeholder;
    return AssetThumb(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
