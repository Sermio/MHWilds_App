import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/filters/monster_filter.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:mhwilds_app/utils/utils.dart';

import 'fake_cached_api.dart';
import 'fixture_loader.dart';

void main() {
  final fixture = loadFixture('monsters');
  final body = jsonEncode(fixture);
  final monsters = fixture.map(Monster.fromJson).toList();
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

  test('monsterById usa el del provider sin pedir por id', () async {
    var calls = 0;
    final provider = MonstersProvider(
      api: fakeCachedApi(server),
      fetchById: (id) async {
        calls++;
        return monsters.first;
      },
    );
    await provider.fetchMonsters();

    final m = await provider.monsterById(monsters.last.id);

    expect(m.id, monsters.last.id);
    expect(calls, 0);
  });

  test('monsterById pide por id si el provider no lo tiene', () async {
    final ids = <int>[];
    final provider = MonstersProvider(
        api: fakeCachedApi(server),
        fetchById: (id) async {
          ids.add(id);
          return monsters.first;
        });

    final m = await provider.monsterById(monsters.first.id);

    expect(m, same(monsters.first));
    expect(ids, [monsters.first.id]);
  });

  test('setFilter ignora tildes y mayúsculas en el nombre', () async {
    final provider = MonstersProvider(api: fakeCachedApi(server));
    await provider.fetchMonsters();
    final first = provider.allMonsters.first;

    provider.setFilter(
        MonsterFilter(name: removeDiacritics(first.name).toUpperCase()));

    expect(provider.filteredMonsters, contains(first));
  });

  test('fetchMonsters expone Failure y se recupera al reintentar', () async {
    online = false;
    final provider = MonstersProvider(api: fakeCachedApi(server));
    await provider.fetchMonsters();
    expect((provider.state as Failure).error, isA<NetworkException>());
    expect(provider.hasData, isFalse);

    online = true;
    await provider.fetchMonsters();
    expect(provider.state, isA<Data<List<Monster>>>());
    expect(provider.allMonsters.length, monsters.length);
    expect(provider.isOffline, isFalse);
  });

  test('sin red y con caché: Data(stale) y aviso de sin conexión', () async {
    final store = MemoryCacheStore();
    await MonstersProvider(api: fakeCachedApi(server, store)).fetchMonsters();

    online = false;
    final provider = MonstersProvider(api: fakeCachedApi(server, store));
    await provider.fetchMonsters();

    final state = provider.state as Data<List<Monster>>;
    expect(state.stale, isTrue);
    expect(state.updatedAt, isNotNull);
    expect(provider.allMonsters.length, monsters.length);
    expect(provider.isOffline, isTrue);

    online = true;
    await provider.refresh(force: true);
    expect((provider.state as Data).stale, isFalse);
    expect(provider.isOffline, isFalse);
  });

  test('refresh conserva los filtros activos', () async {
    final provider = MonstersProvider(api: fakeCachedApi(server));
    await provider.fetchMonsters();
    final name = provider.allMonsters.first.name;
    provider.setFilter(MonsterFilter(name: name));
    final filtered = provider.filteredMonsters.length;

    await provider.refresh(force: true);

    expect(provider.filteredMonsters.length, filtered);
    expect(filtered, lessThan(monsters.length));
  });

  test('el filtro sobrevive a cambiar de pantalla y se vacía al invalidar',
      () async {
    final provider = MonstersProvider(api: fakeCachedApi(server));
    await provider.fetchMonsters();
    final name = provider.allMonsters.first.name;
    provider.setFilter(MonsterFilter(name: name));
    expect(provider.hasActiveFilter, isTrue);

    // Otra pantalla lee el mismo provider: el filtro sigue ahí.
    expect(provider.filter.name, name);

    provider.clearFilters();
    expect(provider.hasActiveFilter, isFalse);
    expect(provider.filteredMonsters.length, monsters.length);

    provider.setFilter(MonsterFilter(name: name));
    provider.invalidate();
    expect(provider.filter, const MonsterFilter());
    expect(provider.filteredMonsters, isEmpty);
  });
}
