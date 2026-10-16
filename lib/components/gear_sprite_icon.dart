import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Map<String, int> weaponColumnByKind = {
  'sword-shield': 0,
  'great-sword': 1,
  'long-sword': 2,
  'dual-blades': 3,
  'lance': 4,
  'gunlance': 5,
  'hammer': 6,
  'hunting-horn': 7,
  'switch-axe': 8,
  'charge-blade': 9,
  'insect-glaive': 10,
  'light-bowgun': 11,
  'heavy-bowgun': 12,
  'bow': 13,
};

const Map<String, int> armorColumnByKind = {
  'head': 14,
  'chest': 15,
  'arms': 16,
  'waist': 17,
  'legs': 18,
};

const int talismanColumn = 19;

const String kGearSpriteSheetAssetPath = 'assets/imgs/sprites/gear.webp';
const int _gearSpriteColumns = 20;
const int _gearSpriteRows = 13;

int spriteRowForRarity(int rarity) {
  return rarity.clamp(0, _gearSpriteRows - 1);
}

class GearSpriteIcon extends StatefulWidget {
  const GearSpriteIcon({
    super.key,
    required this.column,
    required this.rarity,
    required this.size,
    required this.fallback,
    this.assetPath = kGearSpriteSheetAssetPath,
  });

  final int column;
  final int rarity;
  final double size;
  final Widget fallback;
  final String assetPath;

  @override
  State<GearSpriteIcon> createState() => _GearSpriteIconState();
}

class _GearSpriteIconState extends State<GearSpriteIcon> {
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
          return CustomPaint(
            painter: _GearSpritePainter(
              image: image,
              column: widget.column.clamp(0, _gearSpriteColumns - 1),
              row: spriteRowForRarity(widget.rarity),
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
}

class _GearSpritePainter extends CustomPainter {
  const _GearSpritePainter({
    required this.image,
    required this.column,
    required this.row,
  });

  final ui.Image image;
  final int column;
  final int row;

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = image.width / _gearSpriteColumns;
    final double cellHeight = image.height / _gearSpriteRows;

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
  bool shouldRepaint(covariant _GearSpritePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.column != column ||
        oldDelegate.row != row;
  }
}
