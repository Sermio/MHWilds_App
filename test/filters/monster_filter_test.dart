import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/filters/monster_filter.dart';

import '../fixture_loader.dart';

void main() {
  final monsters = loadFixture('monsters').map(Monster.fromJson).toList();

  List<String> names(MonsterFilter f) =>
      filterMonsters(monsters, f).map((m) => m.name).toList();

  test('filtro vacío devuelve todos y la lista vacía no falla', () {
    expect(filterMonsters(monsters, const MonsterFilter()), hasLength(3));
    expect(filterMonsters([], const MonsterFilter(name: 'x')), isEmpty);
  });

  test('nombre: parcial, sin mayúsculas ni tildes', () {
    expect(names(const MonsterFilter(name: 'rEy')), ['Rey Dau']);
    expect(names(const MonsterFilter(name: 'guardián')), isEmpty);
    expect(
        names(const MonsterFilter(name: 'guardian')), ['Guardian Doshaguma']);
  });

  test('sin coincidencias', () {
    expect(names(const MonsterFilter(name: 'zzz')), isEmpty);
  });

  test('especie y rango', () {
    final species = monsters.first.species;
    final bySpecies = names(MonsterFilter(species: species));
    expect(bySpecies, contains(monsters.first.name));
    expect(bySpecies.length, lessThanOrEqualTo(monsters.length));
    expect(names(const MonsterFilter(species: 'no-existe')), isEmpty);
    expect(names(const MonsterFilter(rank: 'master')), isEmpty);
  });

  test('zonas: basta con una y se ignoran mayúsculas', () {
    final zone = monsters.first.locations.first.name;
    final result =
        names(MonsterFilter(locations: [zone.toUpperCase(), 'nada']));
    expect(result, contains(monsters.first.name));
    expect(names(const MonsterFilter(locations: ['nada'])), isEmpty);
  });

  test('los criterios se combinan con AND', () {
    expect(
        names(const MonsterFilter(name: 'rey', species: 'no-existe')), isEmpty);
  });

  test('igualdad por valor (incluidas las listas) y copyWith', () {
    expect(const MonsterFilter(), const MonsterFilter());
    expect(const MonsterFilter(locations: ['a']),
        const MonsterFilter(locations: ['a']));
    expect(const MonsterFilter(locations: ['a']).hashCode,
        const MonsterFilter(locations: ['a']).hashCode);
    expect(const MonsterFilter(name: 'a'), isNot(const MonsterFilter()));
    final f = const MonsterFilter(species: 'x').copyWith(rank: () => 'high');
    expect(f.species, 'x');
    expect(f.rank, 'high');
    expect(f.copyWith(species: () => null).species, isNull);
  });
}
