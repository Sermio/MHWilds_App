import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/announcements_api.dart';
import 'package:mhwilds_app/components/announcements_button.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/announcement.dart';
import 'package:mhwilds_app/providers/announcements_provider.dart';
import 'package:mhwilds_app/screens/announcements_list.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_cached_api.dart';

final _repoJson = File('announcements/announcements.json').readAsStringSync();

MockServer _serve(String body, {int status = 200}) =>
    (_) async => http.Response.bytes(utf8.encode(body), status,
        headers: {'content-type': 'application/json; charset=utf-8'});

typedef MockServer = Future<http.Response> Function(http.Request);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  announcementBodyTests();

  group('JSON del repo', () {
    test('se parsea y cumple docs/ANUNCIOS.md', () async {
      final list = await AnnouncementsApi.parse(_repoJson);
      expect(list, isNotEmpty);
      expect(list.map((a) => a.id).toSet(), hasLength(list.length),
          reason: 'los id no se repiten');
      for (final a in list) {
        expect(a.title['en'], isNotEmpty, reason: '${a.id}: title.en');
        expect(a.body['en'], isNotEmpty, reason: '${a.id}: body.en');
      }
    });
  });

  group('idioma', () {
    const texts = {'en': 'Hi', 'es': 'Hola', 'pt': 'Olá'};

    test('usa el idioma pedido, también con región', () {
      expect(Announcement.localized(texts, 'es'), 'Hola');
      expect(Announcement.localized(texts, 'pt-BR'), 'Olá');
      expect(Announcement.localized(texts, 'es_419'), 'Hola');
    });

    test('cae a en si falta el idioma', () {
      expect(Announcement.localized(texts, 'de'), 'Hi');
      expect(Announcement.localized(const {'fr': 'Salut'}, 'de'), 'Salut');
    });
  });

  group('errores', () {
    test('JSON roto sin copia en disco: Failure, sin lanzar', () async {
      final p = AnnouncementsProvider(api: fakeCachedApi(_serve('{"oops"')));
      await p.fetch();
      expect(p.state, isA<Failure>());
    });

    test('JSON roto o sin red con copia en disco: se queda la copia', () async {
      final store = MemoryCacheStore();
      await AnnouncementsProvider(api: fakeCachedApi(_serve(_repoJson), store))
          .fetch();

      for (final server in [
        _serve('{"announcements": [{"id": 1}]}'),
        _serve('', status: 503),
      ]) {
        final p = AnnouncementsProvider(api: fakeCachedApi(server, store));
        await p.fetch();
        expect(p.all, isNotEmpty);
        expect(p.isOffline, isTrue);
      }
    });
  });

  Future<AnnouncementsProvider> pumpButton(WidgetTester tester, String body,
      {Locale locale = const Locale('en')}) async {
    final p = AnnouncementsProvider(api: fakeCachedApi(_serve(body)));
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: p,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Center(child: AnnouncementsButton())),
      ),
    ));
    await tester.pumpAndSettle();
    return p;
  }

  bool dotVisible(WidgetTester tester) =>
      tester.widget<Badge>(find.byType(Badge)).isLabelVisible;

  testWidgets('punto de nuevo: aparece con un id no visto y se va al abrir',
      (tester) async {
    await pumpButton(tester, _repoJson, locale: const Locale('es'));
    expect(dotVisible(tester), isTrue);
    final first = (await AnnouncementsApi.parse(_repoJson)).first;
    expect(find.byTooltip('Anuncios (nuevo)'), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.byType(AnnouncementsList), findsOneWidget);
    expect(find.text(first.titleFor('es')), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(dotVisible(tester), isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(AnnouncementsProvider.lastSeenKey), first.id);
  });

  testWidgets('orden de chat: el más reciente abajo', (tester) async {
    const body = '''{"announcements": [
      {"id": "new", "date": "2026-11-01", "title": {"en": "Newest"}, "body": {"en": "b"}},
      {"id": "old", "date": "2026-10-01", "title": {"en": "Oldest"}, "body": {"en": "b"}}
    ]}''';
    await pumpButton(tester, body);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Newest')).dy,
        greaterThan(tester.getTopLeft(find.text('Oldest')).dy));
  });

  testWidgets('sin punto si el último id ya se vio', (tester) async {
    final first = (await AnnouncementsApi.parse(_repoJson)).first;
    SharedPreferences.setMockInitialValues(
        {AnnouncementsProvider.lastSeenKey: first.id});
    await pumpButton(tester, _repoJson);
    expect(dotVisible(tester), isFalse);
  });

  testWidgets('lista vacía: estado vacío y sin punto', (tester) async {
    await pumpButton(tester, '{"announcements": []}');
    expect(dotVisible(tester), isFalse);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.text('No announcements yet'), findsOneWidget);
  });

  testWidgets('petición fallida sin copia: error con reintentar',
      (tester) async {
    await pumpButton(tester, '');
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });
}

void announcementBodyTests() {
  testWidgets('cuerpo: viñetas con sangría y párrafos', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: AnnouncementBody('Intro\n• uno\n• dos')),
    ));
    expect(find.text('Intro'), findsOneWidget);
    expect(find.text('uno'), findsOneWidget);
    expect(find.text('•'), findsNWidgets(2));
  });
}
