import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_series_tree.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overflow_helper.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // Regresión: el ExpansionTile (bool) y el scroll horizontal de dentro
  // (double) compartían clave en PageStorage y expandir una serie lanzaba
  // "type 'bool' is not a subtype of type 'double?'".
  testWidgets('expandir una serie del árbol no lanza errores', (tester) async {
    final data = await FixtureProviders.load(tester);
    await pumpAtStress(tester, const WeaponsList(),
        data: data, textScale: 1, locale: const Locale('en'));

    await tester.tap(find.text('Tree'));
    await tester.pump(const Duration(milliseconds: 300));
    final tiles = find.byType(ExpansionTile);
    expect(tiles, findsWidgets);

    await tester.tap(tiles.first);
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    expect(find.byType(WeaponTreeNodeView), findsWidgets);
  });
}
