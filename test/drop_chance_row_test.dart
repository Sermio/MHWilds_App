import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/drop_chance_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations_es.dart';
import 'package:mhwilds_app/utils/theme.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Set<String> _fixtureKinds() {
  final kinds = <String>{};
  void walk(Object? node) {
    if (node is Map) {
      if (node['conditions'] is List) {
        for (final c in node['conditions'] as List) {
          if (c is Map && c['kind'] is String) kinds.add(c['kind'] as String);
        }
      }
      node.values.forEach(walk);
    } else if (node is List) {
      node.forEach(walk);
    }
  }

  walk(jsonDecode(File('test/fixtures/monsters.json').readAsStringSync()));
  return kinds;
}

void main() {
  test('formatRewardKind pone mayúsculas y sustituye guiones', () {
    expect(formatRewardKind('carve-rotten-severed'), 'Carve Rotten Severed');
    expect(formatRewardKind('target  reward'), 'Target Reward');
    expect(formatRewardKind(''), '');
  });

  test('todos los tipos de los datos tienen traducción', () {
    final kinds = _fixtureKinds();
    expect(kinds, isNotEmpty);
    final es = AppLocalizationsEs();
    for (final kind in kinds) {
      expect(rewardKindLabel(es, kind), isNot(formatRewardKind(kind)),
          reason: 'falta traducir "$kind" en los ARB y en rewardKindLabel');
    }
  });

  test('un tipo desconocido cae en el nombre formateado', () {
    expect(rewardKindLabel(AppLocalizationsEs(), 'nuevo-tipo'), 'Nuevo Tipo');
  });

  testWidgets('la tabla muestra porcentaje, tipo traducido y barra',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const DropChanceTable(rows: [
        (chance: 25, kind: 'carve'),
        (chance: 100, kind: 'target-reward'),
      ]),
      locale: const Locale('es'),
    ));
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Despiece'), findsOneWidget);
    expect(find.text('Recompensa de objetivo'), findsOneWidget);
    final bars = tester
        .widgetList<LinearProgressIndicator>(
            find.byType(LinearProgressIndicator))
        .map((b) => b.value)
        .toList();
    expect(bars, [0.25, 1.0]);
  });

  testWidgets('no desborda a 200 % de texto', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(_wrap(const SizedBox(
        width: 300,
        child: DropChanceTable(
            rows: [(chance: 100, kind: 'carve-rotten-severed')]))));
    expect(tester.takeException(), isNull);
  });
}
