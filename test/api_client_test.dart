import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/api_config.dart';

ApiClient _api(MockClientHandler h) => ApiClient(MockClient(h), Duration.zero);

void main() {
  test('getJson: construye URL con idioma, query y cabeceras', () async {
    late http.Request req;
    final api = _api((r) async {
      req = r;
      return http.Response('[1]', 200);
    });
    final data = await api.getJson('skills',
        lang: 'es', query: {'q': 'x'}, headers: {'X-A': 'b'});
    expect(data, [1]);
    expect(req.url.toString(), '${ApiConfig.host}/es/skills?q=x');
    expect(req.headers['X-A'], 'b');
  });

  test('reintenta una vez ante 5xx y luego funciona', () async {
    var calls = 0;
    final api = _api((_) async =>
        ++calls == 1 ? http.Response('', 503) : http.Response('{"a":1}', 200));
    expect(await api.getJson('x'), {'a': 1});
    expect(calls, 2);
  });

  test('5xx persistente: ApiHttpException tras 2 intentos', () async {
    var calls = 0;
    final api = _api((_) async {
      calls++;
      return http.Response('', 500);
    });
    await expectLater(
        api.getJson('x'),
        throwsA(isA<ApiHttpException>()
            .having((e) => e.statusCode, 'statusCode', 500)));
    expect(calls, 2);
  });

  test('4xx no se reintenta', () async {
    var calls = 0;
    final api = _api((_) async {
      calls++;
      return http.Response('', 404);
    });
    await expectLater(api.getJson('x'),
        throwsA(isA<ApiHttpException>().having((e) => e.statusCode, 's', 404)));
    expect(calls, 1);
  });

  test('error de red: reintenta y lanza NetworkException', () async {
    var calls = 0;
    final api = _api((_) async {
      calls++;
      throw http.ClientException('sin red');
    });
    await expectLater(api.getJson('x'), throwsA(isA<NetworkException>()));
    expect(calls, 2);
  });

  test('TimeoutException se trata como error de red', () async {
    final api = _api((_) async => throw TimeoutException('lento'));
    await expectLater(api.getJson('x'), throwsA(isA<NetworkException>()));
  });

  test('JSON inválido: ApiParseException', () {
    final api = _api((_) async => http.Response('<html>', 200));
    expect(api.getJson('x'), throwsA(isA<ApiParseException>()));
  });

  test('last-modified e If-Modified-Since / 304', () async {
    String? sent;
    final api = _api((r) async {
      sent = r.headers['If-Modified-Since'];
      return sent == null
          ? http.Response('[]', 200, headers: {'last-modified': 'Mon, 01 Jan'})
          : http.Response('', 304, headers: {'last-modified': sent!});
    });
    final first = await api.get('x');
    expect(first.lastModified, 'Mon, 01 Jan');
    expect(first.notModified, isFalse);

    final second = await api.get('x', ifModifiedSince: first.lastModified);
    expect(sent, 'Mon, 01 Jan');
    expect(second.notModified, isTrue);
    expect(await api.getJson('x', ifModifiedSince: 'Mon, 01 Jan'), isNull);
  });
}
