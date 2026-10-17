import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/monster.dart';

import '../fixture_loader.dart';

void main() {
  final json = loadFixture('monsters');
  final monsters = json.map(Monster.fromJson).toList();

  test('parses core fields and nested lists', () {
    final m = monsters.first;
    expect(m.id, 1);
    expect(m.name, 'Zoh Shia');
    expect(m.kind, 'large');
    expect(m.baseHealth, 9000);
    expect(m.size!.base, closeTo(4623.598, 0.001));
    expect(m.weaknesses.first.element, 'dragon');
    expect(m.resistances.first.kind, 'effect');
    expect(m.locations.first.name, isNotEmpty);
    expect(m.rewards, isNotEmpty);
  });

  test('every fixture monster parses', () {
    expect(monsters.every((m) => m.id > 0 && m.name.isNotEmpty), isTrue);
  });

  // La API manda las partes en `parts`, pero el modelo lee `breakableParts`.
  // Al corregir el modelo, este test debe pasar a `isNotEmpty`.
  test('KNOWN BUG: breakableParts stays empty (API key is "parts")', () {
    expect(json.first['parts'], isNotEmpty);
    expect(monsters.first.breakableParts, isEmpty);
  });
}
