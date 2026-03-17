import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String kDecorationsSpriteSheetAssetPath =
    'assets/imgs/sprites/decorations.png';
const int _decorationsSpriteColumns = 20;

const Map<int, int> decorationColumnBySlot = {
  1: 0,
  2: 5,
  3: 10,
  4: 15,
};

class DecorationSpriteIcon extends StatefulWidget {
  const DecorationSpriteIcon({
    super.key,
    required this.slot,
    required this.size,
    required this.fallback,
    this.assetPath = kDecorationsSpriteSheetAssetPath,
    this.row = 0,
  });

  final int slot;
  final double size;
  final Widget fallback;
  final String assetPath;
  final int row;

  @override
  State<DecorationSpriteIcon> createState() => _DecorationSpriteIconState();
}

class _DecorationSpriteIconState extends State<DecorationSpriteIcon> {
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
    final int? column = decorationColumnBySlot[widget.slot];
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
            painter: _DecorationSpritePainter(
              image: image,
              column: column.clamp(0, _decorationsSpriteColumns - 1),
              row: row,
              rows: _safeRowCount(image),
            ),
          );
        },
      ),
    );
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
    final int estimatedRows = (image.height / (image.width / _decorationsSpriteColumns)).round();
    return estimatedRows > 0 ? estimatedRows : 1;
  }
}

class _DecorationSpritePainter extends CustomPainter {
  const _DecorationSpritePainter({
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
    final double cellWidth = image.width / _decorationsSpriteColumns;
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
  bool shouldRepaint(covariant _DecorationSpritePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.column != column ||
        oldDelegate.row != row ||
        oldDelegate.rows != rows;
  }
}
