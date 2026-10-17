import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Colores fijos que rompen el modo oscuro: deben salir del `colorScheme` o de
/// `GameColors`. Los colores sobre imágenes o rellenos de color propio
/// (p. ej. texto blanco sobre el degradado de un mapa) no están en la lista.
void main() {
  final forbidden = RegExp(r'Colors\.(black87|grey\[(300|600)\])');
  const allowed = {'lib/components/set_piece_tag.dart'};

  test('pantallas y componentes no fijan grises ni negro de texto', () {
    final offenders = <String>[];
    for (final dir in ['lib/screens', 'lib/components']) {
      for (final f in Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))) {
        final path = f.path.replaceAll(r'\', '/'); // Windows
        if (allowed.contains(path)) continue;
        final lines = f.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          if (forbidden.hasMatch(lines[i])) {
            offenders.add('$path:${i + 1}');
          }
        }
      }
    }
    expect(offenders, isEmpty);
  });
}
