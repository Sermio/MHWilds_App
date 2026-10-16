import 'package:flutter/material.dart';

/// `Image.asset` that decodes at displayed size × device pixel ratio.
///
/// Uses [width] if given, else [height], else the incoming max width
/// (e.g. a grid cell). Do not use for zoomable full-screen images.
class AssetThumb extends StatelessWidget {
  const AssetThumb(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.colorBlendMode,
    this.errorBuilder,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (width != null || height != null) return _image(context, width, height);
    return LayoutBuilder(
      builder: (context, c) =>
          _image(context, c.hasBoundedWidth ? c.maxWidth : null, null),
    );
  }

  Widget _image(BuildContext context, double? cacheW, double? cacheH) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Only one dimension so the aspect ratio is preserved.
    final px = ((cacheW ?? cacheH) ?? 0) * dpr;
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: errorBuilder,
      cacheWidth: cacheW != null && px > 0 ? px.round() : null,
      cacheHeight: cacheW == null && px > 0 ? px.round() : null,
    );
  }
}
