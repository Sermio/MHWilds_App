import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/weapon.dart';

import '../fixture_loader.dart';

void main() {
  final json = loadFixture('weapons');
  final weapons = json.map(Weapon.fromJson).toList();
  Weapon last(String kind) => weapons.lastWhere((w) => w.kind == kind);

  test('parses every fixture weapon with core fields', () {
    expect(weapons, hasLength(json.length));
    for (final w in weapons) {
      expect(w.id, isPositive, reason: w.name);
      expect(w.name, isNotEmpty);
      expect(w.damage.raw, isPositive, reason: w.name);
      expect(w.crafting.weapon.id, w.id, reason: w.name);
    }
  });

  test('fixtures cover every special weapon kind', () {
    expect(
      weapons.map((w) => w.kind).toSet(),
      containsAll([
        'switch-axe',
        'charge-blade',
        'gunlance',
        'bow',
        'light-bowgun',
        'heavy-bowgun',
        'hunting-horn',
        'insect-glaive',
      ]),
    );
  });

  test('melee weapons expose sharpness and series', () {
    final gs = last('great-sword');
    expect(gs.sharpness.white, 350);
    expect(gs.series?.name, isNotEmpty);
  });

  test('switch-axe phial is an object', () {
    expect(last('switch-axe').phial?.kind, 'element');
  });

  test('charge-blade phial comes as a String in the API', () {
    final kinds = weapons
        .where((w) => w.kind == 'charge-blade')
        .map((w) => w.phial?.kind);
    expect(kinds, ['impact', 'element']);
  });

  test('gunlance shell', () {
    final g = last('gunlance');
    expect(g.shell, 'wide');
    expect(g.shellLevel, 3);
  });

  test('bow coatings and specials', () {
    final b = last('bow');
    expect(b.coatings, containsAll(['close-range', 'paralysis']));
    expect(b.specials, isA<List>());
  });

  test('bowguns ammo', () {
    final lbg = last('light-bowgun').ammo!;
    expect(lbg.first.kind, 'normal');
    expect(lbg.any((a) => a.rapid == true), isTrue);
    expect(last('heavy-bowgun').ammo!.first.capacity, isPositive);
  });

  test('hunting horn melody and echo bubble', () {
    final h = last('hunting-horn');
    expect(h.melody!.notes, hasLength(3));
    expect(h.melody!.songs.first.name, 'Self-Improvement');
    expect(h.echoBubble!.name, isNotEmpty);
  });

  test('insect glaive kinsect level', () {
    expect(last('insect-glaive').kinsectLevel, 8);
  });
}
