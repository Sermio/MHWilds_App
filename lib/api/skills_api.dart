import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class SkillsApi {
  static Stream<Data<List<Skills>>> watchSkills(
          {bool force = false, String? lang, CachedApi? api}) =>
      (api ?? CachedApi.shared)
          .watch('skills', _parse, force: force, lang: lang);

  static Future<List<Skills>> _parse(String body) async =>
      (json.decode(body) as List<dynamic>)
          .map((e) => Skills.fromJson(e))
          .toList();

  /// Una sola petición con `q={"id":{"$in":[...]}}`. Devuelve las skills en el
  /// orden de [ids] (la API no garantiza orden); los ids inexistentes se omiten.
  static Future<List<Skills>> fetchSkillsByIds(Set<int> ids,
      {String? lang, http.Client? client}) async {
    if (ids.isEmpty) return [];
    final api = client == null ? ApiClient.shared : ApiClient(client);
    final data = await api.getJson('skills', lang: lang, query: {
      'q': json.encode({
        'id': {r'$in': ids.toList()}
      }),
    }) as List<dynamic>;
    final byId = {
      for (final e in data)
        (e as Map<String, dynamic>)['id'] as int: Skills.fromJson(e),
    };
    return [
      for (final id in ids)
        if (byId[id] != null) byId[id]!
    ];
  }

  static Future<Skills> fetchSkillById(int skillId, {String? lang}) async {
    final Map<String, dynamic> jsonData =
        await ApiClient.shared.getJson('skills/$skillId', lang: lang);
    return Skills.fromJson(jsonData);
  }
}
