import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/api/cache_store.dart';
import 'package:mhwilds_app/api/cached_api.dart';

import 'fake_cached_api.dart';

const v1 = '2026-04-15T01:28:18+00:00';
const v2 = '2026-10-01T00:00:00+00:00';
final cachedLastModified = HttpDate.format(DateTime.utc(2026, 4, 20));
final freshLastModified = HttpDate.format(DateTime.utc(2026, 10, 2));

/// Servidor falso: `/version` y un endpoint `monsters` que responde [body]
/// o 304 si [notModified] y llega `If-Modified-Since`.
class _Server {
  String version = v1;
  String body = 'nuevo';
  String lastModified = freshLastModified;
  bool notModified = false;
  bool offline = false;
  final requests = <http.Request>[];

  Future<http.Response> call(http.Request r) async {
    if (offline) throw http.ClientException('offline');
    requests.add(r);
    if (r.url.path == '/version') {
      return http.Response(jsonEncode({'version': version}), 200);
    }
    if (notModified && r.headers['If-Modified-Since'] != null) {
      return http.Response('', 304);
    }
    return http.Response(body, 200, headers: {'last-modified': lastModified});
  }

  Iterable<http.Request> get endpointRequests =>
      requests.where((r) => r.url.path != '/version');
}

void main() {
  late _Server server;
  late MemoryCacheStore store;
  late CachedApi api;
  final oldFetchedAt = DateTime(2026, 4, 20);

  void seedCache({String version = v1}) =>
      store.entries['en/monsters'] = CacheEntry(
        body: 'viejo',
        fetchedAt: oldFetchedAt,
        version: version,
        lastModified: cachedLastModified,
      );

  // (cuerpo, stale) de cada emisión.
  Future<List<(String, bool)>> watch({bool force = false}) => api
      .watch('monsters', (b) async => b, force: force)
      .map((d) => (d.value, d.stale))
      .toList();

  setUp(() {
    ApiConfig.languageCode = 'en';
    server = _Server();
    store = MemoryCacheStore();
    api = fakeCachedApi(server.call, store);
  });

  test('caché vacía: pide el endpoint y lo guarda con la versión', () async {
    expect(await watch(), [('nuevo', false)]);
    expect(server.endpointRequests.single.headers['If-Modified-Since'], isNull);
    final saved = store.entries['en/monsters']!;
    expect(saved.body, 'nuevo');
    expect(saved.version, v1);
    expect(saved.lastModified, freshLastModified);
  });

  test('caché al día: sirve la caché y no pide el endpoint', () async {
    seedCache();

    expect(await watch(), [('viejo', true), ('viejo', false)]);
    expect(server.endpointRequests, isEmpty);
  });

  test('versión nueva con 200: guarda y emite los datos nuevos', () async {
    seedCache();
    server.version = v2;

    expect(await watch(), [('viejo', true), ('nuevo', false)]);
    expect(server.endpointRequests.single.headers['If-Modified-Since'],
        cachedLastModified);
    expect(store.entries['en/monsters']!.body, 'nuevo');
    expect(store.entries['en/monsters']!.version, v2);
  });

  test('versión nueva con 304: mantiene los datos y actualiza la fecha',
      () async {
    seedCache();
    server
      ..version = v2
      ..notModified = true;

    expect(await watch(), [('viejo', true), ('viejo', false)]);
    final saved = store.entries['en/monsters']!;
    expect(saved.body, 'viejo');
    expect(saved.fetchedAt.isAfter(oldFetchedAt), isTrue);
    // Se conserva la versión para volver a preguntar en el próximo arranque.
    expect(saved.version, v1);
  });

  test('offline con caché: emite la caché como stale y termina sin error',
      () async {
    seedCache();
    server.offline = true;

    expect(await watch(), [('viejo', true)]);
  });

  test('offline sin caché: falla con NetworkException', () async {
    server.offline = true;

    expect(watch(), throwsA(isA<NetworkException>()));
  });

  test('force pide el endpoint aunque la versión coincida', () async {
    seedCache();

    expect(await watch(force: true), [('viejo', true), ('nuevo', false)]);
    expect(server.endpointRequests, hasLength(1));
  });

  test('200 servido por la CDN antes de la importación no sube la versión',
      () async {
    seedCache();
    server
      ..version = v2
      ..lastModified = HttpDate.format(DateTime.utc(2026, 9, 1));

    await watch();
    expect(store.entries['en/monsters']!.version, v1);
  });

  test('cada idioma tiene su caché', () async {
    seedCache(); // en
    ApiConfig.languageCode = 'es';

    expect(await watch(), [('nuevo', false)]);
    expect(store.entries.keys, containsAll(['en/monsters', 'es/monsters']));
    expect(server.endpointRequests.single.url.path, '/es/monsters');
  });

  test('caché corrupta: se ignora y se vuelve a pedir', () async {
    seedCache();
    final api2 = fakeCachedApi(server.call, store);
    final out = await api2
        .watch('monsters',
            (b) async => b == 'viejo' ? throw const FormatException() : b)
        .map((d) => (d.value, d.stale))
        .toList();
    expect(out, [('nuevo', false)]);
  });

  group('CacheStore en disco', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('cache_store'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('guarda y lee cuerpo y metadatos por idioma/endpoint', () async {
      final disk = CacheStore(() async => dir);
      final entry = CacheEntry(
          body: '[1]',
          fetchedAt: DateTime.utc(2026, 1, 2),
          version: v1,
          lastModified: cachedLastModified);

      expect(await disk.read('en', 'armor/sets'), isNull);
      await disk.write('en', 'armor/sets', entry);
      final read = (await disk.read('en', 'armor/sets'))!;

      expect(read.body, '[1]');
      expect(read.fetchedAt, entry.fetchedAt);
      expect(read.version, v1);
      expect(read.lastModified, cachedLastModified);
      expect(await disk.read('es', 'armor/sets'), isNull);
    });
  });
}
