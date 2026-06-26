import 'dart:io';
import 'package:image/image.dart';

void main() {
  final bytes = File('assets/imgs/sprites/gear.png').readAsBytesSync();
  final img = decodeImage(bytes);
  if (img == null) return;
  
  const tileSize = 64;
  final col = 19; // Amulet column
  final outDir = Directory('assets/imgs/amulets');
  
  for (int r = 1; r <= 12; r++) {
    final tile = copyCrop(img, x: col * tileSize, y: r * tileSize, width: tileSize, height: tileSize);
    final outBytes = encodePng(tile);
    File('${outDir.path}/rarity${r}.png').writeAsBytesSync(outBytes);
  }
}
