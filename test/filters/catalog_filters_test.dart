import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/filters/amulet_filter.dart';
import 'package:mhwilds_app/providers/filters/armor_set_filter.dart';
import 'package:mhwilds_app/providers/filters/decoration_filter.dart';
import 'package:mhwilds_app/providers/filters/item_filter.dart';
import 'package:mhwilds_app/providers/filters/skill_filter.dart';
import 'package:mhwilds_app/providers/filters/weapon_filter.dart';

import '../fixture_loader.dart';

void main() {
  group('filterWeapons', () {
    final weapons = loadFixture('weapons').map(Weapon.fromJson).toList();
    List<String> names(WeaponFilter f) =>
        filterWeapons(weapons, f).map((w) => w.name).toList();

    test('vacío, lista vacía y sin coincidencias', () {
      expect(filterWeapons(weapons, const WeaponFilter()),
          hasLength(weapons.length));
      expect(filterWeapons([], const WeaponFilter(name: 'a')), isEmpty);
      expect(names(const WeaponFilter(name: 'zzzz')), isEmpty);
    });

    test('nombre parcial sin distinguir mayúsculas', () {
      expect(names(const WeaponFilter(name: 'hope BOW')), ['Hope Bow I']);
    });

    test('tipo y rareza se combinan', () {
      final bows = filterWeapons(weapons, const WeaponFilter(kind: 'bow'));
      expect(bows, isNotEmpty);
      expect(bows.every((w) => w.kind == 'bow'), isTrue);
      final r8 =
          filterWeapons(weapons, const WeaponFilter(kind: 'bow', rarity: 8));
      expect(r8.every((w) => w.kind == 'bow' && w.rarity == 8), isTrue);
      expect(filterWeapons(weapons, const WeaponFilter(rarity: 99)), isEmpty);
    });

    test('serie: las armas sin serie no coinciden', () {
      final withSeries = weapons.firstWhere((w) => w.series != null);
      final result = filterWeapons(
          weapons, WeaponFilter(series: withSeries.series!.name.toUpperCase()));
      expect(result, contains(withSeries));
      expect(result.every((w) => w.series != null), isTrue);
    });

    test('igualdad y copyWith', () {
      expect(const WeaponFilter(kind: 'bow'), const WeaponFilter(kind: 'bow'));
      expect(const WeaponFilter().copyWith(rarity: () => 3).rarity, 3);
      expect(const WeaponFilter(kind: 'bow').copyWith(kind: () => null).kind,
          isNull);
    });
  });

  group('filterArmorSets', () {
    final sets = loadFixture('armor_sets').map(ArmorSet.fromJson).toList();

    test('filtro vacío devuelve una copia de todos', () {
      final r = filterArmorSets(sets, const ArmorSetFilter());
      expect(r, hasLength(sets.length));
      expect(identical(r, sets), isFalse);
    });

    test('por nombre', () {
      final r = filterArmorSets(sets, const ArmorSetFilter(name: 'CONGA'));
      expect(r.map((s) => s.name), ['Conga α']);
    });

    test('por tipo de pieza deja solo esas piezas en cada set', () {
      final r = filterArmorSets(sets, const ArmorSetFilter(kind: 'head'));
      expect(r, isNotEmpty);
      for (final s in r) {
        expect(s.pieces, isNotEmpty);
        expect(s.pieces.every((p) => p.kind == 'head'), isTrue);
      }
    });

    test('sin piezas que cumplan se descarta el set', () {
      expect(filterArmorSets(sets, const ArmorSetFilter(rarity: 99)), isEmpty);
      expect(filterArmorSets([], const ArmorSetFilter(kind: 'head')), isEmpty);
    });
  });

  group('filterDecorations', () {
    final decos =
        loadFixture('decorations').map(DecorationItem.fromJson).toList();

    test('ordena por nivel descendente y luego por nombre', () {
      final r = filterDecorations(decos, const DecorationFilter());
      for (var i = 1; i < r.length; i++) {
        final a = r[i - 1], b = r[i];
        expect(a.displayLevel, greaterThanOrEqualTo(b.displayLevel));
        if (a.displayLevel == b.displayLevel) {
          expect(a.name.toLowerCase().compareTo(b.name.toLowerCase()),
              lessThanOrEqualTo(0));
        }
      }
    });

    test('tipo sin distinguir mayúsculas y nombre parcial', () {
      final r =
          filterDecorations(decos, const DecorationFilter(type: 'WEAPON'));
      expect(r.every((d) => d.kind == 'weapon'), isTrue);
      expect(r, isNotEmpty);
      expect(
          filterDecorations(decos, const DecorationFilter(name: 'venom'))
              .map((d) => d.name),
          ['Venom Jewel [1]']);
      expect(filterDecorations(decos, const DecorationFilter(name: 'zzz')),
          isEmpty);
    });
  });

  group('filterAmulets', () {
    final amulets = [
      for (final a in loadFixture('charms').map(Amulet.fromJson))
        for (final r in a.ranks) Amulet(id: r.id, gameId: a.gameId, ranks: [r]),
    ];

    test('ordena por rareza descendente', () {
      final r = filterAmulets(amulets, const AmuletFilter());
      expect(r, hasLength(amulets.length));
      for (var i = 1; i < r.length; i++) {
        expect(r[i - 1].ranks.first.rarity,
            greaterThanOrEqualTo(r[i].ranks.first.rarity));
      }
    });

    test('nombre, rareza y sin coincidencias', () {
      final first = amulets.first.ranks.first;
      expect(
          filterAmulets(amulets, AmuletFilter(name: first.name.toUpperCase())),
          contains(amulets.first));
      expect(
          filterAmulets(amulets, AmuletFilter(rarity: first.rarity))
              .every((a) => a.ranks.first.rarity == first.rarity),
          isTrue);
      expect(filterAmulets(amulets, const AmuletFilter(rarity: 99)), isEmpty);
    });

    test('un talismán sin rangos nunca coincide', () {
      expect(
          filterAmulets(
              [Amulet(id: 1, gameId: 1, ranks: [])], const AmuletFilter()),
          isEmpty);
    });
  });

  group('filterSkills / filterItems', () {
    final skills = loadFixture('skills').map(Skills.fromJson).toList();
    final items = loadFixture('items').map(Item.fromJson).toList();

    test('habilidades por nombre y tipo', () {
      expect(
          filterSkills(skills, const SkillFilter(name: 'critical'))
              .map((s) => s.name),
          ['Critical Eye']);
      expect(
          filterSkills(skills, const SkillFilter(kind: 'weapon'))
              .every((s) => s.kind == 'weapon'),
          isTrue);
      expect(filterSkills(skills, const SkillFilter(kind: 'set')), isEmpty);
      expect(filterSkills([], const SkillFilter()), isEmpty);
    });

    test('objetos por nombre y rareza', () {
      expect(
          filterItems(items, const ItemFilter(name: 'POTION')), hasLength(2));
      expect(filterItems(items, const ItemFilter(rarity: 1)), hasLength(2));
      expect(
          filterItems(items, const ItemFilter(name: 'potion', rarity: 2))
              .map((i) => i.name),
          ['Mega Potion']);
      expect(filterItems(items, const ItemFilter(rarity: 9)), isEmpty);
    });
  });
}
