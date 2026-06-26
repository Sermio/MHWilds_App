import 'dart:io';
import 'package:image/image.dart';

void main() {
  final bytes = File('assets/imgs/sprites/gear.png').readAsBytesSync();
  final img = decodeImage(bytes);
  if (img == null) return;
  
  const tileSize = 64;
  
  final columns = {
    0: 'weapons/great-sword',
    1: 'weapons/sword-and-shield',
    2: 'weapons/dual-blades',
    3: 'weapons/long-sword',
    4: 'weapons/hammer',
    5: 'weapons/hunting-horn',
    6: 'weapons/lance',
    7: 'weapons/gunlance',
    8: 'weapons/switch-axe',
    9: 'weapons/charge-blade',
    10: 'weapons/insect-glaive',
    11: 'weapons/bow',
    12: 'weapons/light-bowgun',
    13: 'weapons/heavy-bowgun',
    14: 'armor/head',
    15: 'armor/chest',
    16: 'armor/arms',
    17: 'armor/waist',
    18: 'armor/legs',
  };

  for (final entry in columns.entries) {
    final col = entry.key;
    final folder = entry.value;
    
    final outDir = Directory('assets/imgs/$folder');
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }
    
    for (int r = 1; r <= 12; r++) {
      final tile = copyCrop(img, x: col * tileSize, y: r * tileSize, width: tileSize, height: tileSize);
      final outBytes = encodePng(tile);
      File('${outDir.path}/rarity${r}.png').writeAsBytesSync(outBytes);
    }
  }
  
  print('Extraction complete for armors and weapons!');
}
