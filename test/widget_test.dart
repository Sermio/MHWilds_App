import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Offline providers so the smoke test never touches the network.
class _OfflineLocationsProvider extends LocationsProvider {
  @override
  Future<void> fetchZones() async {}
}

class _EmptyMonstersProvider extends MonstersProvider {
  @override
  LoadState<List<Monster>> get state => const Data([]);

  @override
  Future<void> refresh({bool force = false}) async {}
}

Widget _buildApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<MonstersProvider>(
          create: (_) => _EmptyMonstersProvider()),
      ChangeNotifierProvider<LocationsProvider>(
          create: (_) => _OfflineLocationsProvider()),
      ChangeNotifierProvider(create: (_) => EnNamesCache()),
    ],
    child: const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('HomeScreen opens on the Monsters section', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Monsters')),
      findsOneWidget,
    );
    // No data loaded: the list shows its empty state instead of crashing.
    expect(find.text('No monsters found'), findsOneWidget);
  });

  testWidgets('Drawer lists the main sections', (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    final drawer = find.byType(Drawer);
    expect(drawer, findsOneWidget);
    for (final title in ['Weapons', 'Armor Sets', 'Decorations']) {
      expect(find.descendant(of: drawer, matching: find.text(title)),
          findsOneWidget,
          reason: '"$title" should be in the drawer');
    }
  });
}
