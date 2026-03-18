import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String kSkillsSpriteSheetAssetPath = 'assets/imgs/sprites/skills.png';
const int _skillsSpriteColumns = 14;

const Map<String, int> skillIconIdByKind = {
  'attack': 1,
  'affinity': 2,
  'element': 3,
  'handicraft': 4,
  'ranged': 5,
  'defense': 6,
  'health': 7,
  'stamina': 8,
  'offense': 9,
  'utility': 10,
  'item': 11,
  'gathering': 12,
  'group': 13,
  'set': 14,
};

class SkillSpriteIcon extends StatefulWidget {
  const SkillSpriteIcon({
    super.key,
    required this.size,
    required this.fallback,
    this.iconId,
    this.iconKind,
    this.assetPath = kSkillsSpriteSheetAssetPath,
    this.row = 0,
  });

  final double size;
  final Widget fallback;
  final int? iconId;
  final String? iconKind;
  final String assetPath;
  final int row;

  @override
  State<SkillSpriteIcon> createState() => _SkillSpriteIconState();
}

class _SkillSpriteIconState extends State<SkillSpriteIcon> {
  static final Map<String, Future<ui.Image>> _imageCache = {};

  late Future<ui.Image> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _imageCache.putIfAbsent(
      widget.assetPath,
      () => _loadUiImage(widget.assetPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int? column = _resolveColumn(widget.iconId, widget.iconKind);
    if (column == null) {
      return SizedBox(width: widget.size, height: widget.size, child: widget.fallback);
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: FutureBuilder<ui.Image>(
        future: _imageFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return widget.fallback;
          }

          final image = snapshot.data!;
          final int row = widget.row.clamp(0, _safeRowCount(image) - 1);
          return CustomPaint(
            painter: _SkillSpritePainter(
              image: image,
              column: column.clamp(0, _skillsSpriteColumns - 1),
              row: row,
              rows: _safeRowCount(image),
            ),
          );
        },
      ),
    );
  }

  int? _resolveColumn(int? iconId, String? iconKind) {
    if (iconId != null && iconId >= 1 && iconId <= _skillsSpriteColumns) {
      return iconId - 1;
    }

    if (iconKind != null) {
      final normalizedKind = iconKind.toLowerCase().trim();
      final idFromKind = skillIconIdByKind[normalizedKind];
      if (idFromKind != null) {
        return idFromKind - 1;
      }
    }

    return null;
  }

  Future<ui.Image> _loadUiImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes,
    );
    final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(
      buffer,
    );
    final ui.Codec codec = await descriptor.instantiateCodec();
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  int _safeRowCount(ui.Image image) {
    final int estimatedRows =
        (image.height / (image.width / _skillsSpriteColumns)).round();
    return estimatedRows > 0 ? estimatedRows : 1;
  }
}

class _SkillSpritePainter extends CustomPainter {
  const _SkillSpritePainter({
    required this.image,
    required this.column,
    required this.row,
    required this.rows,
  });

  final ui.Image image;
  final int column;
  final int row;
  final int rows;

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = image.width / _skillsSpriteColumns;
    final double cellHeight = image.height / rows;

    final Rect sourceRect = Rect.fromLTWH(
      column * cellWidth,
      row * cellHeight,
      cellWidth,
      cellHeight,
    );

    final Rect destinationRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      sourceRect,
      destinationRect,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(covariant _SkillSpritePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.column != column ||
        oldDelegate.row != row ||
        oldDelegate.rows != rows;
  }
}
