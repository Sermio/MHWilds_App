import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/providers/filters/item_filter.dart';
import 'package:mhwilds_app/providers/filters/monster_filter.dart';
import 'package:mhwilds_app/providers/filters/weapon_filter.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overflow_helper.dart';

/// Al salir de una sección y volver, la pantalla se recrea: el filtro debe
/// seguir en el provider y el campo de búsqueda mostrarlo.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> open(
          WidgetTester tester, Widget screen, FixtureProviders data) =>
      pumpAtStress(tester, screen,
          data: data, textScale: 1, locale: const Locale('en'));

  Future<void> showFilters(WidgetTester tester) async {
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('monstruos: el texto filtrado se conserva al recrear la pantalla',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    await open(tester, const MonstersList(), data);
    await showFilters(tester);
    await tester.enterText(find.byType(TextField).first, 'rey');
    await tester.pump(const Duration(milliseconds: 300)); // debounce de 250 ms
    expect(data.monsters.filter, const MonsterFilter(name: 'rey'));
    expect(data.monsters.filteredMonsters.map((m) => m.name), ['Rey Dau']);

    await open(tester, const SizedBox(), data); // otra sección
    await open(tester, const MonstersList(), data);
    await showFilters(tester);

    expect(data.monsters.filter.name, 'rey');
    expect(find.widgetWithText(TextField, 'rey'), findsOneWidget);
    expect(find.byKey(const PageStorageKey('monsters-list')), findsOneWidget);
  });

  testWidgets('objetos: el filtro sobrevive y "Reset" lo vacía',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    data.items.setFilter(const ItemFilter(name: 'mega', rarity: 2));

    await open(tester, const ItemList(), data);
    await showFilters(tester);
    expect(find.widgetWithText(TextField, 'mega'), findsOneWidget);
    expect(data.items.items.map((i) => i.name), ['Mega Potion']);

    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(data.items.hasActiveFilter, isFalse);
    expect(data.items.items.length, data.items.allItems.length);
    expect(find.widgetWithText(TextField, 'mega'), findsNothing);
  });

  testWidgets('armas: nombre y serie se restauran', (tester) async {
    final data = await FixtureProviders.load(tester);
    data.weapons.setFilter(const WeaponFilter(name: 'hope', series: 'abc'));

    await open(tester, const WeaponsList(), data);
    await showFilters(tester);

    expect(find.widgetWithText(TextField, 'hope'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'abc'), findsOneWidget);
  });

  testWidgets('armas: el elemento elegido se muestra en el desplegable',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    data.weapons.setFilter(const WeaponFilter(element: 'fire'));

    await open(tester, const WeaponsList(), data);
    await showFilters(tester);

    expect(find.text('Element'), findsOneWidget); // etiqueta del campo
    expect(find.text('Fire'), findsOneWidget); // valor elegido
  });

  testWidgets('armas: elegir un elemento en el desplegable filtra la lista',
      (tester) async {
    final data = await FixtureProviders.load(tester);

    await open(tester, const WeaponsList(), data);
    await showFilters(tester);
    final field = find.byType(DropdownButtonFormField<dynamic>);
    await tester.ensureVisible(field); // el panel hace scroll por dentro
    await tester.pump();
    await tester.tap(field);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Ice').last);
    await tester.pump(const Duration(milliseconds: 400));

    expect(data.weapons.filter.element, 'ice');
  });

  testWidgets('armaduras: elegir un elemento en el desplegable lo guarda',
      (tester) async {
    final data = await FixtureProviders.load(tester);

    await open(tester, const ArmorSetList(), data);
    await showFilters(tester);
    final field = find.byType(DropdownButtonFormField<dynamic>);
    await tester.ensureVisible(field);
    await tester.pump();
    await tester.tap(field);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Dragon').last);
    await tester.pump(const Duration(milliseconds: 400));

    expect(data.armorSets.filter.element, 'dragon');
  });
}
