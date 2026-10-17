import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/screens/armor_piece_details/armor_stats_section.dart';
import 'package:mhwilds_app/screens/weapon_details/weapon_stats_section.dart';
import 'package:mhwilds_app/utils/theme.dart';

import 'fixture_loader.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view
    ..physicalSize = const Size(400, 1600)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ));
}

/// Todas las filas de estadística deben ocupar el mismo ancho (nombre a la
/// izquierda, valor a la derecha); si no, algunas quedan centradas.
void _expectRowsFullWidth(WidgetTester tester, {required int minRows}) {
  final rows = find.byType(LabelValueRow);
  expect(rows, findsAtLeastNWidgets(minRows));
  final widths = [
    for (var i = 0; i < rows.evaluate().length; i++)
      tester.getSize(rows.at(i)).width
  ];
  expect(widths.toSet().length, 1, reason: 'anchos de fila: $widths');
}

void main() {
  testWidgets('armadura: todas las filas de stats ocupan el mismo ancho',
      (tester) async {
    final armor = ArmorPiece.fromJson(loadFixture('armor').first);
    await _pump(tester, ArmorStatsSection(armor: armor));

    _expectRowsFullWidth(tester, minRows: 5);
  });

  testWidgets('arma (cuerno de caza): todas las filas ocupan el mismo ancho',
      (tester) async {
    final horn = Weapon.fromJson(
        loadFixture('weapons').firstWhere((w) => w['kind'] == 'hunting-horn'));
    await _pump(tester, WeaponStatsSection(weapon: horn));

    _expectRowsFullWidth(tester, minRows: 6);
  });

  testWidgets('arma (hacha cargada): todas las filas ocupan el mismo ancho',
      (tester) async {
    final cb = Weapon.fromJson(
        loadFixture('weapons').firstWhere((w) => w['kind'] == 'charge-blade'));
    await _pump(tester, WeaponStatsSection(weapon: cb));

    _expectRowsFullWidth(tester, minRows: 4);
  });
}
