import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'fake_cached_api.dart';
import 'fixture_loader.dart';

/// Endpoint de la API → fixture de `test/fixtures`.
const _fixtureByEndpoint = {
  'monsters': 'monsters',
  'weapons': 'weapons',
  'armor/sets': 'armor_sets',
  'decorations': 'decorations',
  'charms': 'charms',
  'skills': 'skills',
  'items': 'items',
  'locations': 'locations',
};

/// Providers de datos reales alimentados con los fixtures, sin red ni disco.
class FixtureProviders {
  FixtureProviders._();

  late final MonstersProvider monsters;
  late final WeaponsProvider weapons;
  late final ArmorSetProvider armorSets;
  late final DecorationsProvider decorations;
  late final TalismansProvider talismans;
  late final SkillsProvider skills;
  late final ItemsProvider items;
  late final LocationsProvider locations;
  late final EnNamesCache enNames;

  static Future<FixtureProviders> load(WidgetTester tester) async {
    final bodies = {
      for (final e in _fixtureByEndpoint.entries)
        e.key: jsonEncode(loadFixture(e.value)),
    };
    Future<http.Response> server(http.Request r) async {
      final path = r.url.path.replaceFirst('/en/', '');
      if (r.url.path == '/version') {
        return http.Response('{"version":"v1"}', 200);
      }
      final body = bodies[path];
      if (body == null) return http.Response('[]', 200);
      return http.Response(body, 200,
          headers: {'content-type': 'application/json; charset=utf-8'});
    }

    final api = fakeCachedApi(server);
    final p = FixtureProviders._()
      ..monsters = MonstersProvider(api: api)
      ..weapons = WeaponsProvider(api: api)
      ..armorSets = ArmorSetProvider(api: api)
      ..decorations = DecorationsProvider(api: api)
      ..talismans = TalismansProvider(api: api)
      ..skills = SkillsProvider(api: api)
      ..items = ItemsProvider(api: api)
      ..locations = LocationsProvider(api: api)
      ..enNames = EnNamesCache(api);
    await tester.runAsync(() => Future.wait([
          p.monsters.fetch(),
          p.weapons.fetch(),
          p.armorSets.fetch(),
          p.decorations.fetch(),
          p.talismans.fetch(),
          p.skills.fetch(),
          p.items.fetch(),
          p.locations.fetch(),
          p.enNames.loadEnNames(),
        ]));
    return p;
  }

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<MonstersProvider>.value(value: monsters),
        ChangeNotifierProvider<WeaponsProvider>.value(value: weapons),
        ChangeNotifierProvider<ArmorSetProvider>.value(value: armorSets),
        ChangeNotifierProvider<DecorationsProvider>.value(value: decorations),
        ChangeNotifierProvider<TalismansProvider>.value(value: talismans),
        ChangeNotifierProvider<SkillsProvider>.value(value: skills),
        ChangeNotifierProvider<ItemsProvider>.value(value: items),
        ChangeNotifierProvider<LocationsProvider>.value(value: locations),
        ChangeNotifierProvider<EnNamesCache>.value(value: enNames),
      ];
}

/// Monta [screen] a 360×640 dp, con el texto al 200 %, en alemán y en el tema
/// [theme] (claro por defecto). Falla si el árbol lanza cualquier excepción,
/// en particular un `RenderFlex overflowed`.
Future<void> pumpAtStress(
  WidgetTester tester,
  Widget screen, {
  required FixtureProviders data,
  ThemeData? theme,
  double textScale = 2.0,
  Locale locale = const Locale('de'),
}) async {
  tester.view
    ..physicalSize = const Size(360, 640)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Se guardan los errores con su diagnóstico completo (incluye el widget
  // culpable y la línea que lo creó), que `takeException` descarta.
  _errors.clear();
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    _errors.add(details);
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);

  await tester.pumpWidget(MultiProvider(
    providers: data.providers,
    child: MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: screen,
    ),
  ));
  // Algunos detalles cargan imágenes/animaciones; unas pasadas bastan.
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Recorre una lista de arriba abajo para que se construyan más tarjetas
/// (los `ListView` solo construyen las visibles).
Future<void> scrollThrough(WidgetTester tester, {int pages = 8}) async {
  final scrollable = find.byType(Scrollable).first;
  for (var i = 0; i < pages; i++) {
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

final _errors = <FlutterErrorDetails>[];

/// Falla, con el widget culpable de cada uno, si hubo algún overflow de
/// layout (`RenderFlex overflowed`, `RenderBox overflowed`…).
/// Otras aserciones de debug no hacen fallar el test.
void expectNoOverflow(WidgetTester tester, {String? reason}) {
  final report = _errors
      .where((d) => d.exception.toString().contains('overflowed'))
      .map((d) {
    final text = d.toString().split('\n');
    final where = text.where((l) =>
        l.contains('overflowed by') ||
        l.contains('error-causing widget') ||
        l.contains('file:///'));
    return (where.isEmpty ? text.take(6) : where.take(4)).join('\n');
  }).join('\n---\n');
  _errors.clear();
  while (tester.takeException() != null) {}
  expect(report, isEmpty, reason: reason);
}
