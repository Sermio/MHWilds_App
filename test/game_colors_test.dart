import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/utils/theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const darkSurface = Color(0xFF121212);

  group('variante clara conserva los colores históricos', () {
    final g = GameColors.light;

    test('elementos y estados', () {
      expect(g.element('fire'), Colors.red[600]);
      expect(g.element('Thunder'), Colors.yellow[600]);
      expect(g.element('exhaust'), Colors.grey[600]);
      expect(g.element('desconocido'), Colors.grey[600]);
    });

    test('revestimientos, armas y armaduras', () {
      expect(g.coating('close-range'), Colors.blue[600]);
      expect(g.coating('x'), Colors.grey[600]);
      expect(g.kind('great-sword'), Colors.red[400]);
      expect(g.kind('legs'), Colors.purple[400]);
      expect(g.kind('x'), Colors.grey[400]);
    });

    test('rareza muestreada del sprite y limitada al rango', () {
      expect(g.rarity(0), const Color(0xFF747474));
      expect(g.rarity(8), const Color(0xFFA15332));
      expect(g.rarity(99), g.rarity(12));
      expect(g.rarity(-1), g.rarity(0));
    });

    test('afilado y zonas', () {
      expect(g.sharpnessYellow, Colors.yellow[600]);
      expect(g.sharpnessWhite, Colors.white);
      expect(g.zone(2), const Color.fromARGB(255, 249, 207, 37));
      expect(g.zone(3), Colors.green.shade700);
      expect(g.zone(0), Colors.white);
    });
  });

  test('en oscuro los colores usados como texto llegan a 4,5:1', () {
    final g = GameColors.dark;
    for (final c in [
      ...g.elements.values,
      ...g.coatings.values,
      ...g.rarities,
    ]) {
      expect(_contrast(c, darkSurface), greaterThanOrEqualTo(4.5),
          reason: '$c sobre $darkSurface');
    }
  });

  test('oscuro solo cambia donde la clara no cumplía el contraste', () {
    for (var i = 0; i < GameColors.light.rarities.length; i++) {
      final l = GameColors.light.rarities[i];
      if (_contrast(l, darkSurface) >= 4.5) {
        expect(GameColors.dark.rarity(i), l);
      }
    }
  });

  testWidgets('cada tema registra su variante y of() tiene reserva',
      (tester) async {
    late GameColors fromLight, fromDark, fromPlain;
    Widget probe(void Function(BuildContext) read) => Builder(builder: (c) {
          read(c);
          return const SizedBox();
        });

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: probe((c) => fromLight = GameColors.of(c)),
    ));
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      home: probe((c) => fromDark = GameColors.of(c)),
    ));
    await tester.pumpAndSettle(); // el tema anima de claro a oscuro
    await tester.pumpWidget(MaterialApp(
      home: probe((c) => fromPlain = GameColors.of(c)),
    ));
    await tester.pumpAndSettle();

    expect(fromLight.element('fire'), GameColors.light.element('fire'));
    expect(fromDark.element('fire'), GameColors.dark.element('fire'));
    expect(fromPlain.element('fire'), GameColors.light.element('fire'));
  });
}
