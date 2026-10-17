import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/filters/weapon_filter.dart';
import 'package:mhwilds_app/utils/game_element.dart';

import '../fixture_loader.dart';

Weapon _weapon(int id,
    {String kind = 'great-sword',
    int rarity = 1,
    List<Map<String, dynamic>> specials = const [],
    Object? phial}) {
  final base = Map<String, dynamic>.from(
      loadFixture('weapons').firstWhere((w) => w['kind'] == kind));
  return Weapon.fromJson({
    ...base,
    'id': id,
    'name': 'W$id',
    'rarity': rarity,
    'specials': specials,
    if (phial != null) 'phial': phial,
  });
}

Map<String, dynamic> _element(String e) => {
      'kind': 'element',
      'element': e,
      'damage': {'raw': 10, 'display': 100}
    };
Map<String, dynamic> _status(String s) => {
      'kind': 'status',
      'status': s,
      'damage': {'raw': 10, 'display': 100}
    };

void main() {
  final fire = _weapon(1, specials: [_element('fire')]);
  final fireRare = _weapon(2, rarity: 5, specials: [_element('fire')]);
  final ice = _weapon(3, specials: [_element('ice')]);
  final poison = _weapon(4, specials: [_status('poison')]);
  final plain = _weapon(5);
  // Vial de elemento sin special de elemento: no cuenta.
  final elementPhial =
      _weapon(6, kind: 'charge-blade', phial: 'element', specials: const []);
  final all = [fire, fireRare, ice, poison, plain, elementPhial];

  List<int> ids(WeaponFilter f) =>
      filterWeapons(all, f).map((w) => w.id).toList();

  test('elemento: solo las armas con ese special', () {
    expect(ids(const WeaponFilter(element: 'fire')), [1, 2]);
    expect(ids(const WeaponFilter(element: 'ice')), [3]);
    expect(ids(const WeaponFilter(element: 'dragon')), isEmpty);
  });

  test('estado: coincide por el campo status', () {
    expect(ids(const WeaponFilter(element: 'poison')), [4]);
    expect(ids(const WeaponFilter(element: 'sleep')), isEmpty);
  });

  test('el vial de elemento no cuenta como elemento', () {
    expect(weaponElementIds(elementPhial), isEmpty);
    expect(ids(const WeaponFilter(element: 'fire')), isNot(contains(6)));
  });

  test('se combina con rareza, tipo y nombre', () {
    expect(ids(const WeaponFilter(element: 'fire', rarity: 5)), [2]);
    expect(ids(const WeaponFilter(element: 'fire', kind: 'bow')), isEmpty);
    expect(ids(const WeaponFilter(element: 'fire', name: 'w2')), [2]);
  });

  test('sin elemento no filtra', () {
    expect(ids(const WeaponFilter()), hasLength(all.length));
  });

  test('weaponElementIds tolera specials ausentes o raros', () {
    expect(weaponElementIds(plain), isEmpty);
    expect(weaponElementIds(fire), {'fire'});
    expect(weaponElementIds(poison), {'poison'});
  });

  test('copyWith y igualdad incluyen el elemento', () {
    const f = WeaponFilter(element: 'fire');
    expect(f, const WeaponFilter(element: 'fire'));
    expect(f, isNot(const WeaponFilter()));
    expect(f.copyWith(element: () => null).element, isNull);
    expect(f.copyWith(name: 'a').element, 'fire');
  });

  test('cada elemento y estado de armas filtra con datos del fixture', () {
    final weapons = loadFixture('weapons').map(Weapon.fromJson).toList();
    for (final e in [...GameElement.elements, ...GameElement.weaponStatuses]) {
      final r = filterWeapons(weapons, WeaponFilter(element: e.id));
      expect(r.every((w) => weaponElementIds(w).contains(e.id)), isTrue,
          reason: e.id);
    }
  });
}
