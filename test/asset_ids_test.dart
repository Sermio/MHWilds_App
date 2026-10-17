import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/asset_ids.g.dart';

import 'fixture_loader.dart';

void main() {
  test('every fixture monster id has an icon and a header image', () {
    for (final m in loadFixture('monsters')) {
      final id = m['id'] as int;
      expect(monsterIconAssets[id], isNotNull, reason: 'icon for $id');
      expect(monsterImageAssets[id], isNotNull, reason: 'image for $id');
    }
  });

  test('every fixture location id has map images', () {
    for (final l in loadFixture('locations')) {
      final id = l['id'] as int;
      expect(locationMapAssets[id], isNotEmpty, reason: 'maps for $id');
    }
  });

  test('every generated path exists', () {
    final paths = [
      ...monsterIconAssets.values,
      ...monsterImageAssets.values,
      ...locationMapAssets.values.expand((v) => v),
    ];
    for (final p in paths) {
      expect(File(p).existsSync(), isTrue, reason: p);
    }
  });
}
