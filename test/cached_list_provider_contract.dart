import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

import 'fake_cached_api.dart';
import 'fixture_loader.dart';

/// Comportamiento común de los providers que extienden [CachedListProvider]:
/// error y recuperación, datos de caché sin conexión e invalidación.
/// [filter] aplica un filtro que deja menos elementos que [total]; si se da,
/// además se comprueba que `refresh` lo conserva.
void cachedListProviderContract<P extends CachedListProvider>(
  String name, {
  required String fixture,
  required P Function(CachedApi api) create,
  required int Function(P p) total,
  void Function(P p)? filter,
  int Function(P p)? visible,
}) {
  group('$name (CachedListProvider)', () {
    final body = jsonEncode(loadFixture(fixture));
    var online = true;

    Future<http.Response> server(http.Request r) async {
      if (!online) throw http.ClientException('off');
      if (r.url.path == '/version') {
        return http.Response('{"version":"v1"}', 200);
      }
      return http.Response(body, 200,
          headers: {'content-type': 'application/json; charset=utf-8'});
    }

    setUp(() {
      online = true;
    });

    test('sin red y sin caché: Failure, y se recupera al reintentar', () async {
      online = false;
      final p = create(fakeCachedApi(server));
      await p.fetch();
      expect((p.state as Failure).error, isA<NetworkException>());
      expect(p.hasData, isFalse);

      online = true;
      await p.fetch();
      expect(p.state, isA<Data>());
      expect(total(p), greaterThan(0));
      expect(p.isOffline, isFalse);
    });

    test('sin red y con caché: Data(stale) y aviso de sin conexión', () async {
      final store = MemoryCacheStore();
      await create(fakeCachedApi(server, store)).fetch();

      online = false;
      final p = create(fakeCachedApi(server, store));
      await p.fetch();
      expect((p.state as Data).stale, isTrue);
      expect((p.state as Data).updatedAt, isNotNull);
      expect(p.isOffline, isTrue);

      online = true;
      await p.refresh(force: true);
      expect((p.state as Data).stale, isFalse);
      expect(p.isOffline, isFalse);
    });

    test('invalidate vacía los datos y vuelve a Idle', () async {
      final p = create(fakeCachedApi(server));
      await p.fetch();

      p.invalidate();

      expect(p.state, isA<Idle>());
      expect(p.hasData, isFalse);
      expect(total(p), 0);
    });

    if (filter != null && visible != null) {
      test('refresh conserva los filtros activos', () async {
        final p = create(fakeCachedApi(server));
        await p.fetch();
        final all = visible(p);
        filter(p);
        final shown = visible(p);
        expect(shown, lessThan(all));

        await p.refresh(force: true);

        expect(visible(p), shown);
      });
    }
  });
}
