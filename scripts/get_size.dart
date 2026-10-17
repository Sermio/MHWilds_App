import 'dart:io';
import 'package:image/image.dart';

void main() {
  final bytes = File('assets/imgs/sprites/gear.png').readAsBytesSync();
  final img = decodeImage(bytes);
  if (img != null) {
    stdout.writeln('Width: ${img.width}, Height: ${img.height}');
  } else {
    stdout.writeln('Failed to decode image');
  }
}
