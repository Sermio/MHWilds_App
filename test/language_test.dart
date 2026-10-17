import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/providers/data_providers.dart';
import 'package:mhwilds_app/providers/filters/monster_filter.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_cached_api.dart';
import 'fixture_loader.dart';

void main() {
  final body = jsonEncode(loadFixture('monsters'));
  late List<Uri> requests;

  Future<http.Response> server(http.Request r) async {
    requests.add(r.url);
    if (r.url.path == '/version') {
      return http.Response('{"version":"v1"}', 200);
    }
    return http.Response(body, 200,
        headers: {'content-type': 'application/json; charset=utf-8'});
  }

  Iterable<String> dataPaths() =>
      requests.where((u) => u.path != '/version').map((u) => u.path);

  setUp(() {
    requests = [];
    SharedPreferences.setMockInitialValues({});
  });

  test('ApiConfig.languageFor: pt → pt-BR y vacío → inglés', () {
    expect(ApiConfig.languageFor('es'), 'es');
    expect(ApiConfig.languageFor('pt'), 'pt-BR');
    expect(ApiConfig.languageFor('pt-BR'), 'pt-BR');
    expect(ApiConfig.languageFor(null), 'en');
    expect(ApiConfig.languageFor(''), 'en');
  });

  group('setLanguage', () {
    test('sin datos cargados solo recuerda el idioma para la primera carga',
        () async {
      final p = MonstersProvider(api: fakeCachedApi(server));
      p.setLanguage('es');
      await Future<void>.delayed(Duration.zero);
      expect(requests, isEmpty);
      expect(p.state, isA<Idle>());

      await p.fetchMonsters();
      expect(dataPaths(), ['/es/monsters']);
    });

    test('con datos cargados recarga en el idioma nuevo y vacía el filtro',
        () async {
      final p = MonstersProvider(api: fakeCachedApi(server));
      await p.fetchMonsters();
      p.setFilter(const MonsterFilter(name: 'rey'));
      expect(dataPaths(), ['/en/monsters']);

      p.setLanguage('es');
      expect(p.language, 'es');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(dataPaths(), ['/en/monsters', '/es/monsters']);
      expect(p.state, isA<Data>());
      expect(p.hasActiveFilter, isFalse);
    });

    test('volver a un idioma ya cargado se sirve desde la caché', () async {
      final store = MemoryCacheStore();
      final p = MonstersProvider(api: fakeCachedApi(server, store));
      await p.fetchMonsters();
      p.setLanguage('es');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      requests.clear();

      p.setLanguage('en');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(p.state, isA<Data>());
      expect(p.allMonsters, isNotEmpty);
      expect(dataPaths(), isEmpty, reason: 'versión igual: sin red de datos');
    });

    test('mismo idioma: no hace nada', () async {
      final p = MonstersProvider(api: fakeCachedApi(server));
      await p.fetchMonsters();
      requests.clear();
      p.setLanguage('en');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(requests, isEmpty);
    });

    test('el detalle por id usa el idioma actual', () async {
      final p = MonstersProvider(api: fakeCachedApi(server));
      expect(p.language, 'en');
      p.setLanguage('de');
      expect(p.language, 'de');
    });
  });

  testWidgets('dataProviders sigue a LocaleProvider (cambio de idioma recarga)',
      (tester) async {
    final locale = LocaleProvider();
    await tester.runAsync(() => locale.localeReady);
    late BuildContext ctx;

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>.value(value: locale),
        ...dataProviders(api: fakeCachedApi(server)),
      ],
      child: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));

    final monsters = ctx.read<MonstersProvider>();
    final weapons = ctx.read<WeaponsProvider>();
    expect(monsters.language, 'en');
    await tester.runAsync(monsters.fetchMonsters);
    expect(dataPaths(), ['/en/monsters']);

    await tester.runAsync(() => locale.setLocale(const Locale('es')));
    await tester.pump(); // el ProxyProvider recibe el idioma nuevo
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();

    expect(monsters.language, 'es');
    expect(weapons.language, 'es');
    expect(dataPaths(), ['/en/monsters', '/es/monsters']);
    // Las armas nunca se cargaron: solo recuerdan el idioma.
    expect(weapons.state, isA<Idle>());

    await tester.runAsync(() => locale.setLocale(const Locale('pt', 'BR')));
    await tester.pump();
    expect(monsters.language, 'pt-BR');
  });
}
