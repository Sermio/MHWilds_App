import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/game_element.dart';

import 'fixture_loader.dart';

void main() {
  test('todos los elementos tienen su imagen', () {
    for (final e in GameElement.values) {
      expect(File(e.asset).existsSync(), isTrue, reason: e.asset);
    }
  });

  test('todos los archivos de assets/imgs/elements están en el enum', () {
    final files = Directory('assets/imgs/elements')
        .listSync()
        .map((f) => f.uri.pathSegments.last.replaceAll('.webp', ''))
        .toSet();
    expect(files, GameElement.values.map((e) => e.name).toSet());
  });

  test(
      'elementos y estados de las armas del fixture resuelven a un GameElement',
      () {
    for (final w in loadFixture('weapons')) {
      for (final s in (w['specials'] as List).cast<Map<String, dynamic>>()) {
        final id =
            (s['kind'] == 'element' ? s['element'] : s['status']) as String;
        final e = GameElement.fromId(id);
        expect(e, isNotNull, reason: '${w['name']}: $id');
        expect(e!.isStatus, s['kind'] == 'status');
      }
    }
  });

  test('las resistencias de las armaduras del fixture son los 5 elementos', () {
    for (final a in loadFixture('armor')) {
      final keys = (a['resistances'] as Map).keys.cast<String>().toSet();
      expect(keys, GameElement.elements.map((e) => e.id).toSet());
    }
  });

  test('fromId ignora mayúsculas, espacios y guiones', () {
    expect(GameElement.fromId('Fire'), GameElement.fire);
    expect(GameElement.fromId('blast-blight'), GameElement.blastblight);
    expect(GameElement.fromId('Frost Blight'), GameElement.frostblight);
    expect(GameElement.fromId('impact'), isNull);
    expect(GameElement.fromId(null), isNull);
  });

  test('los 9 nombres traducidos existen en todos los idiomas y no se repiten',
      () {
    final shown = [...GameElement.elements, ...GameElement.weaponStatuses];
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      final labels = shown.map((e) => e.label(l10n)).toList();
      expect(labels.every((l) => l.isNotEmpty), isTrue, reason: '$locale');
      expect(labels.toSet().length, labels.length, reason: '$locale');
    }
    expect(const Locale('en'), isNotNull);
  });
}
