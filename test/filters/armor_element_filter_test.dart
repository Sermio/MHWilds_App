import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/filters/armor_set_filter.dart';

import '../fixture_loader.dart';

Map<String, dynamic> _piece(int id, String kind, int rarity,
    {int fire = 0, int ice = 0}) {
  final base = Map<String, dynamic>.from(loadFixture('armor').first);
  return {
    ...base,
    'id': id,
    'name': 'P$id',
    'kind': kind,
    'rarity': rarity,
    'resistances': {
      'fire': fire,
      'water': 0,
      'ice': ice,
      'thunder': 0,
      'dragon': 0
    },
  };
}

ArmorSet _set(int id, String name, List<Map<String, dynamic>> pieces) {
  final base = Map<String, dynamic>.from(loadFixture('armor_sets').first);
  return ArmorSet.fromJson({...base, 'id': id, 'name': name, 'pieces': pieces});
}

void main() {
  // best fire: A=2, B=3, C=3 (empate con B), D=0, E=-1
  final a = _set(1, 'A', [
    _piece(1, 'head', 1, fire: 2),
    _piece(2, 'chest', 1, fire: 1),
  ]);
  final b = _set(2, 'B', [_piece(3, 'head', 2, fire: 3)]);
  final c = _set(3, 'C', [
    _piece(4, 'head', 1, fire: 0),
    _piece(5, 'legs', 2, fire: 3),
  ]);
  final d = _set(4, 'D', [_piece(6, 'head', 1, fire: 0, ice: 5)]);
  final e = _set(5, 'E', [_piece(7, 'head', 1, fire: -1)]);
  final sets = [a, b, c, d, e];

  List<String> names(ArmorSetFilter f) =>
      filterArmorSets(sets, f).map((s) => s.name).toList();

  test('solo piezas con resistencia mayor que 0; 0 y negativas se excluyen',
      () {
    expect(names(const ArmorSetFilter(element: 'fire')), isNot(contains('D')));
    expect(names(const ArmorSetFilter(element: 'fire')), isNot(contains('E')));
    final c2 = filterArmorSets(sets, const ArmorSetFilter(element: 'fire'))
        .firstWhere((s) => s.name == 'C');
    expect(c2.pieces.map((p) => p.name), ['P5']);
  });

  test('ordena los sets de mayor a menor y mantiene el orden en los empates',
      () {
    expect(names(const ArmorSetFilter(element: 'fire')), ['B', 'C', 'A']);
  });

  test('dentro de un set las piezas conservan el orden cabeza → piernas', () {
    final a2 = filterArmorSets(sets, const ArmorSetFilter(element: 'fire'))
        .firstWhere((s) => s.name == 'A');
    expect(a2.pieces.map((p) => p.kind), ['head', 'chest']);
  });

  test('otro elemento da otro resultado', () {
    expect(names(const ArmorSetFilter(element: 'ice')), ['D']);
    expect(names(const ArmorSetFilter(element: 'dragon')), isEmpty);
  });

  test('un elemento ausente en las resistencias equivale a 0', () {
    expect(names(const ArmorSetFilter(element: 'poison')), isEmpty);
  });

  test('se combina con rareza, tipo y nombre', () {
    expect(names(const ArmorSetFilter(element: 'fire', rarity: 2)), ['B', 'C']);
    expect(names(const ArmorSetFilter(element: 'fire', kind: 'chest')), ['A']);
    expect(names(const ArmorSetFilter(element: 'fire', name: 'b')), ['B']);
    expect(names(const ArmorSetFilter(element: 'fire', kind: 'arms')), isEmpty);
  });

  test('sin elemento no cambia el orden ni el resultado', () {
    expect(names(const ArmorSetFilter(rarity: 1)), ['A', 'C', 'D', 'E']);
    expect(filterArmorSets([], const ArmorSetFilter(element: 'fire')), isEmpty);
  });

  test('copyWith e igualdad incluyen el elemento', () {
    const f = ArmorSetFilter(element: 'fire');
    expect(f, const ArmorSetFilter(element: 'fire'));
    expect(f, isNot(const ArmorSetFilter()));
    expect(f.copyWith(element: () => null).element, isNull);
    expect(f.copyWith(name: 'x').element, 'fire');
  });
}
