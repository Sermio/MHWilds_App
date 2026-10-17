import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/components/sprite_icon.dart';

const _fallback = Key('fallback');

Widget _host(Widget child) => MaterialApp(home: Material(child: child));

/// Espera a que la hoja de sprites cargue (necesita async real) y repinta.
Future<void> _settle(WidgetTester tester) async {
  await tester
      .runAsync(() => Future.delayed(const Duration(milliseconds: 300)));
  await tester.pump();
}

void main() {
  group('SpriteIcon.sourceRect', () {
    test('con filas explícitas', () {
      final r = SpriteIcon.sourceRect(
          imageSize: const Size(200, 130),
          columns: 20,
          column: 3,
          row: 2,
          rows: 13);
      expect(r, const Rect.fromLTWH(30, 20, 10, 10));
    });

    test('deduce las filas de la proporción y limita column/row', () {
      final r = SpriteIcon.sourceRect(
          imageSize: const Size(140, 20), columns: 14, column: 99, row: 99);
      expect(r, const Rect.fromLTWH(130, 10, 10, 10));
    });
  });

  testWidgets('cada tipo pinta el sprite (CustomPaint) y comparte la hoja',
      (tester) async {
    SpriteSheetCache.clear();
    await tester.pumpWidget(_host(const Column(children: [
      GearSpriteIcon(
          column: 1, rarity: 5, size: 20, fallback: SizedBox(key: _fallback)),
      DecorationSpriteIcon(
          slot: 2, size: 20, fallback: SizedBox(key: Key('f2'))),
      SkillSpriteIcon(
          iconKind: 'attack', size: 20, fallback: SizedBox(key: Key('f3'))),
    ])));
    expect(find.byKey(_fallback), findsOneWidget); // mientras carga
    await _settle(tester);

    expect(find.byKey(_fallback), findsNothing);
    expect(find.byKey(const Key('f2')), findsNothing);
    expect(find.byKey(const Key('f3')), findsNothing);
    expect(
        find.descendant(
            of: find.byType(SpriteIcon), matching: find.byType(CustomPaint)),
        findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('sin columna válida se muestra el fallback', (tester) async {
    await tester.pumpWidget(_host(const Column(children: [
      DecorationSpriteIcon(slot: 9, size: 20, fallback: Text('deco')),
      SkillSpriteIcon(size: 20, fallback: Text('skill')),
    ])));
    await _settle(tester);
    expect(find.text('deco'), findsOneWidget);
    expect(find.text('skill'), findsOneWidget);
    expect(find.byType(SpriteIcon), findsNothing);
  });

  testWidgets('si la hoja no existe se queda en el fallback y se reintenta',
      (tester) async {
    SpriteSheetCache.clear();
    const icon = SpriteIcon(
        sheetAsset: 'assets/imgs/sprites/no_existe.webp',
        columns: 2,
        column: 0,
        size: 20,
        fallback: Text('fb'));
    await tester.pumpWidget(_host(icon));
    await _settle(tester);
    expect(find.text('fb'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byType(SpriteIcon), matching: find.byType(CustomPaint)),
        findsNothing);
  });
}
