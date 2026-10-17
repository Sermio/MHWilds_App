import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/app_section.dart';
import 'package:mhwilds_app/utils/theme.dart';

Future<void> _pumpDrawer(WidgetTester tester, ThemeData theme) async {
  tester.view
    ..physicalSize = const Size(400, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Cdrawer(
        selectedSection: AppSection.weapons,
        onSectionSelected: (_) {},
      ),
    ),
  ));
}

int _tilesWithColor(WidgetTester tester, Color color) => tester
    .widgetList<Container>(find.byType(Container))
    .where((c) => (c.decoration as BoxDecoration?)?.color == color)
    .length;

void main() {
  for (final entry in {
    'claro': AppTheme.lightTheme,
    'oscuro': AppTheme.darkTheme,
  }.entries) {
    testWidgets('drawer ${entry.key}: solo la sección activa se destaca',
        (tester) async {
      await _pumpDrawer(tester, entry.value);
      final neutral = entry.value.colorScheme.surfaceContainerLow;

      expect(_tilesWithColor(tester, neutral), AppSection.values.length - 1);
    });
  }

  test('surfaceContainerLow es neutro, sin tinte dorado', () {
    for (final s in [AppTheme.lightScheme, AppTheme.darkScheme]) {
      final c = s.surfaceContainerLow;
      final spread = [c.r, c.g, c.b].reduce((a, b) => a > b ? a : b) -
          [c.r, c.g, c.b].reduce((a, b) => a < b ? a : b);
      expect(spread, lessThan(0.02));
    }
  });
}
