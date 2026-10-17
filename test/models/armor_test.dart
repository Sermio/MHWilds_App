import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/armor_set.dart' as sets;

import '../fixture_loader.dart';

void main() {
  test('ArmorPiece parses core fields', () {
    final p = ArmorPiece.fromJson(loadFixture('armor').first);
    expect(p.id, 1);
    expect(p.name, 'Conga Helm α');
    expect(p.kind, 'head');
    expect(p.rank, 'high');
    expect(p.defense['base'], 36);
    expect(p.slots, [1]);
    expect(p.skills.first.skill.name, 'Free Meal');
    expect(p.armorSet.id, 1);
    expect(p.crafting.materials.first.item.name, 'Congalala Pelt+');
  });

  test('ArmorSet parses pieces and bonuses', () {
    final all = loadFixture('armor_sets').map(sets.ArmorSet.fromJson).toList();
    final s = all.first;
    expect(s.id, 1);
    expect(s.pieces, hasLength(5));
    expect(s.groupBonusSkill.name, 'Fortifying Pelt');
    expect(s.groupBonusSkill.ranks.first.pieces, 3);
    expect(all.last.setBonusSkill.id, isPositive);
  });
}
