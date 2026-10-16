import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/providers/en_names_cache.dart';

import 'fake_cached_api.dart';

void main() {
  final requests = <Uri>[];

  http.Response handler(http.Request r) {
    requests.add(r.url);
    if (r.url.path.endsWith('/version')) {
      return http.Response(json.encode({'version': 'v1'}), 200);
    }
    final id = r.url.pathSegments.last.length; // distinto por endpoint
    return http.Response(
        json.encode([
          {'id': 1, 'name': 'Name ${r.url.pathSegments.last} $id'},
          {'id': 2, 'name': ''},
        ]),
        200);
  }

  setUp(requests.clear);

  test('pide solo id y name en inglés y rellena los cuatro mapas', () async {
    final cache = EnNamesCache(fakeCachedApi((r) async => handler(r)));
    expect(cache.isLoaded, isFalse);
    await cache.loadEnNames();
    await cache.cacheReady;

    expect(cache.isLoaded, isTrue);
    expect(cache.getMonsterNameEn(1), 'Name monsters 8');
    expect(cache.getItemNameEn(1), 'Name items 5');
    expect(cache.getSkillNameEn(1), 'Name skills 6');
    expect(cache.getMapNameEn(1), 'Name locations 9');
    expect(cache.getMonsterNameEn(2), isNull);

    final data = requests.where((u) => !u.path.endsWith('/version'));
    expect(data, hasLength(4));
    for (final u in data) {
      expect(u.pathSegments.first, 'en');
      expect(u.queryParameters['p'], '{"id":true,"name":true}');
    }
  });

  test('antes de cargar no hay nombre para imágenes (placeholder)', () {
    final cache = EnNamesCache(fakeCachedApi((r) async => handler(r)));
    expect(cache.nameForMonsterImage(1, 'Rathalos'), isNull);
  });

  test('con caché en disco carga sin esperar a la red', () async {
    final store = MemoryCacheStore();
    final warm = EnNamesCache(fakeCachedApi((r) async => handler(r), store));
    await warm.loadEnNames();
    requests.clear();

    // Sin red: la caché basta y no se pide ningún listado.
    final offline = EnNamesCache(fakeCachedApi(
        (r) async => throw http.ClientException('offline'), store));
    await offline.loadEnNames();
    expect(offline.isLoaded, isTrue);
    expect(offline.getMonsterNameEn(1), 'Name monsters 8');
  });

  test('sin red y sin caché termina sin cargar', () async {
    final cache = EnNamesCache(
        fakeCachedApi((r) async => throw http.ClientException('offline')));
    await cache.loadEnNames();
    await cache.cacheReady;
    expect(cache.isLoaded, isFalse);
    expect(cache.nameForItemImage(1, 'x'), isNull);
  });
}
