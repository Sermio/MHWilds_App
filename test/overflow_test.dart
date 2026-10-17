import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/maps_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/armor_piece_details.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/screens/monster_details.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixture_loader.dart';
import 'overflow_helper.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  final lists = <String, Widget Function()>{
    'monstruos': () => const MonstersList(),
    'armas': () => const WeaponsList(),
    'sets de armadura': () => const ArmorSetList(),
    'decoraciones': () => const DecorationsList(),
    'talismanes': () => const AmuletList(),
    'habilidades': () => const SkillList(),
    'objetos': () => const ItemList(),
    'mapas': () => const MapsList(),
  };

  for (final e in lists.entries) {
    testWidgets('lista de ${e.key} sin overflow a 360×640, de, 200 %',
        (tester) async {
      final data = await FixtureProviders.load(tester);
      await pumpAtStress(tester, e.value(), data: data);
      await scrollThrough(tester);
      expectNoOverflow(tester);
    });
  }

  // Cabeceras y cuerpo de cada detalle, con varias entradas de los fixtures
  // (armas de distinto tipo, piezas de cada rango…).
  testWidgets('detalle de armas sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    final weapons = loadFixture('weapons').map(Weapon.fromJson).toList();
    final byKind = {for (final w in weapons) w.kind: w};
    for (final w in byKind.values) {
      await pumpAtStress(tester, WeaponDetails(weapon: w), data: data);
      await scrollThrough(tester, pages: 6);
      expectNoOverflow(tester, reason: 'arma ${w.kind}: ${w.name}');
    }
  });

  testWidgets('detalle de armaduras sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    for (final json in loadFixture('armor').take(4)) {
      final piece = ArmorPiece.fromJson(json);
      await pumpAtStress(tester, ArmorDetails(armor: piece), data: data);
      await scrollThrough(tester, pages: 6);
      expectNoOverflow(tester, reason: 'pieza ${piece.name}');
    }
  });

  testWidgets('detalle de habilidades sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    final ids = data.skills.allSkills.take(3).map((s) => s.id).toList();
    await pumpAtStress(tester, SkillDetails(skillsIds: ids), data: data);
    await scrollThrough(tester, pages: 6);
    expectNoOverflow(tester);
  });

  testWidgets('detalle de objetos sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    for (final json in loadFixture('items').take(3)) {
      final item = Item.fromJson(json);
      await pumpAtStress(tester, ItemDetails(item: item), data: data);
      await scrollThrough(tester, pages: 4);
      expectNoOverflow(tester, reason: 'objeto ${item.name}');
    }
  });

  testWidgets('detalle de monstruos sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    for (final m in data.monsters.allMonsters.take(3)) {
      await pumpAtStress(tester, MonsterDetails(monsterId: m.id), data: data);
      await scrollThrough(tester, pages: 8);
      expectNoOverflow(tester, reason: 'monstruo ${m.name}');
    }
  });

  testWidgets('detalle de mapas sin overflow', (tester) async {
    final data = await FixtureProviders.load(tester);
    for (final z in data.locations.zones.take(2)) {
      await pumpAtStress(tester, MonsterMapDetails(mapId: z.id ?? 0),
          data: data);
      await scrollThrough(tester, pages: 4);
      expectNoOverflow(tester, reason: 'mapa ${z.name}');
    }
  });
}
