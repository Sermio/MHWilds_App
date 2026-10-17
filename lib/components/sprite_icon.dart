import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Carga cada hoja de sprites una sola vez y comparte el `ui.Image` entre
/// todos los iconos que la usan.
class SpriteSheetCache {
  SpriteSheetCache._();

  static final Map<String, Future<ui.Image>> _images = {};

  static Future<ui.Image> load(String assetPath) {
    return _images[assetPath] ??= _decode(assetPath).catchError(
      (Object e, StackTrace st) {
        _images.remove(assetPath); // permite reintentar en el siguiente uso
        Error.throwWithStackTrace(e, st);
      },
    );
  }

  static Future<ui.Image> _decode(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final buffer =
        await ui.ImmutableBuffer.fromUint8List(data.buffer.asUint8List());
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    return (await codec.getNextFrame()).image;
  }

  /// Solo para tests: descarta las hojas cargadas.
  @visibleForTesting
  static void clear() => _images.clear();
}

/// Celda ([column], [row]) de una hoja de sprites de [columns] columnas.
/// Si [rows] es null se deduce de las proporciones de la imagen (celdas
/// cuadradas). Mientras carga, o si falla, muestra [fallback].
class SpriteIcon extends StatelessWidget {
  const SpriteIcon({
    super.key,
    required this.sheetAsset,
    required this.columns,
    required this.column,
    required this.size,
    required this.fallback,
    this.row = 0,
    this.rows,
  });

  final String sheetAsset;
  final int columns;
  final int column;
  final int row;
  final int? rows;
  final double size;
  final Widget fallback;

  /// Rectángulo de origen de una celda dentro de una imagen de [imageSize].
  @visibleForTesting
  static Rect sourceRect({
    required Size imageSize,
    required int columns,
    required int column,
    required int row,
    int? rows,
  }) {
    final totalRows = rows ?? _estimateRows(imageSize, columns);
    final cellWidth = imageSize.width / columns;
    final cellHeight = imageSize.height / totalRows;
    final c = column.clamp(0, columns - 1);
    final r = row.clamp(0, totalRows - 1);
    return Rect.fromLTWH(c * cellWidth, r * cellHeight, cellWidth, cellHeight);
  }

  static int _estimateRows(Size imageSize, int columns) {
    final estimated = (imageSize.height / (imageSize.width / columns)).round();
    return estimated > 0 ? estimated : 1;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder<ui.Image>(
        future: SpriteSheetCache.load(sheetAsset),
        builder: (context, snapshot) {
          final image = snapshot.data;
          if (image == null) return fallback;
          return CustomPaint(
            painter: _SpritePainter(
              image: image,
              source: sourceRect(
                imageSize:
                    Size(image.width.toDouble(), image.height.toDouble()),
                columns: columns,
                column: column,
                row: row,
                rows: rows,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  const _SpritePainter({required this.image, required this.source});

  final ui.Image image;
  final Rect source;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      source,
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(covariant _SpritePainter oldDelegate) =>
      oldDelegate.image != image || oldDelegate.source != source;
}
