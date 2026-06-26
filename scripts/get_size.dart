import 'dart:io';
import 'package:image/image.dart';

void main() {
  final bytes = File('assets/imgs/sprites/gear.png').readAsBytesSync();
  final img = decodeImage(bytes);
  if (img != null) {
    print('Width: ${img.width}, Height: ${img.height}');
  } else {
    print('Failed to decode image');
  }
}
