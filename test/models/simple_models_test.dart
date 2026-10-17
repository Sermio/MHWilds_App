import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/models/talisman.dart';

import '../fixture_loader.dart';

void main() {
  test('DecorationItem', () {
    final d = DecorationItem.fromJson(loadFixture('decorations').first);
    expect(d.id, 1);
    expect(d.name, 'Venom Jewel [1]');
    expect(d.slot, 1);
    expect(d.skills.first.skill.id, 12);
    expect(d.icon.color, 'purple');
  });

  test('Item', () {
    final i = Item.fromJson(loadFixture('items').first);
    expect(i.id, 1);
    expect(i.name, 'Potion');
    expect(i.carryLimit, 10);
    expect(i.icon!.kind, 'potion');
    expect(i.icon!.color, 'green');
    expect(i.recipes.first.inputs.first.name, 'Herb');
  });

  test('Skills', () {
    final s = Skills.fromJson(loadFixture('skills').first);
    expect(s.id, 1);
    expect(s.name, 'Dragon Resistance');
    expect(s.kind, 'armor');
    expect(s.ranks, hasLength(3));
    expect(s.ranks.last.level, 3);
    expect(s.icon!.kind, 'defense');
  });

  test('MapData', () {
    final m = MapData.fromJson(loadFixture('locations').first);
    expect(m.name, 'Oilwell Basin');
    expect(m.zoneCount, 18);
    final camp = m.camps!.first;
    expect(camp.risk, 'safe');
    expect(camp.location!.id, 1);
    expect(camp.position!.x, closeTo(728.98, 0.01));
  });

  test('Amulet', () {
    final a = Amulet.fromJson(loadFixture('charms').first);
    expect(a.id, 1);
    expect(a.ranks, hasLength(3));
    final r = a.ranks.first;
    expect(r.name, 'Windproof Charm I');
    expect(r.rarity, 4);
    expect(r.skills.first.skill.id, 35);
    expect(r.crafting.craftable, isTrue);
    expect(r.crafting.materials.first.item.name, 'Dragonite Ore');
  });
}
