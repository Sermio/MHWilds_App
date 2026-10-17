import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/announcements_provider.dart';
import 'package:mhwilds_app/screens/app_section.dart';
import 'package:mhwilds_app/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_cached_api.dart';

Future<void> _pumpDrawer(WidgetTester tester, ThemeData theme) async {
  tester.view
    ..physicalSize = const Size(400, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ChangeNotifierProvider(
    create: (_) => AnnouncementsProvider(
        api: fakeCachedApi((_) async => http.Response('{}', 200))),
    child: MaterialApp(
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
    ),
  ));
}

int _tilesWithColor(WidgetTester tester, Color color) => tester
    .widgetList<Container>(find.byType(Container))
    .where((c) => (c.decoration as BoxDecoration?)?.color == color)
    .length;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

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

  testWidgets('cabecera: altavoz de 48 dp sin desbordar con texto al 200 %',
      (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpDrawer(tester, AppTheme.lightTheme);
    tester.view.physicalSize = const Size(280, 2400);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final button = find.byTooltip('Announcements');
    expect(tester.getSize(button), const Size(48, 48));
  });

  test('surfaceContainerLow es cálido (r >= g >= b), no el tinte del seed', () {
    for (final s in [AppTheme.lightScheme, AppTheme.darkScheme]) {
      final c = s.surfaceContainerLow;
      expect(c.r, greaterThanOrEqualTo(c.g));
      expect(c.g, greaterThanOrEqualTo(c.b));
    }
  });
}
