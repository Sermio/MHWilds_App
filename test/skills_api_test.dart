import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mhwilds_app/api/skills_api.dart';

void main() {
  test('fetchSkillsByIds: una petición con filtro in y orden de ids', () async {
    late Uri requested;
    var calls = 0;
    final client = MockClient((req) async {
      calls++;
      requested = req.url;
      // La API responde en otro orden que el pedido.
      return http.Response(
          json.encode([
            {'id': 2, 'name': 'B', 'description': '', 'ranks': []},
            {'id': 1, 'name': 'A', 'description': '', 'ranks': []},
          ]),
          200);
    });

    final skills = await SkillsApi.fetchSkillsByIds({1, 2, 3}, client: client);

    expect(calls, 1);
    expect(requested.path, endsWith('/skills'));
    expect(json.decode(requested.queryParameters['q']!), {
      'id': {
        r'$in': [1, 2, 3]
      }
    });
    expect(skills.map((s) => s.id), [1, 2]);
  });

  test('fetchSkillsByIds: error HTTP lanza excepción', () {
    final client = MockClient((_) async => http.Response('', 500));
    expect(SkillsApi.fetchSkillsByIds({1}, client: client), throwsException);
  });
}
