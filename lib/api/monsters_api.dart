import 'dart:isolate';
import 'dart:convert';

import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class MonstersApi {
  static Stream<Data<List<Monster>>> watchMonsters(
          {bool force = false, CachedApi? api}) =>
      (api ?? CachedApi.shared).watch('monsters', _parse, force: force);

  static Future<List<Monster>> _parse(String body) => Isolate.run(() {
        final List<dynamic> jsonData = json.decode(body);
        final monsters = jsonData.map((e) => Monster.fromJson(e)).toList();
        monsters.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return monsters;
      });

  static Future<Monster> fetchMonsterById(int monsterId) async {
    final Map<String, dynamic> jsonData =
        await ApiClient.shared.getJson('monsters/$monsterId');
    return Monster.fromJson(jsonData);
  }
}
