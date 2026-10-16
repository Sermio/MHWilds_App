import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/version_service.dart';

void main() {
  late List<Uri> requests;
  late String version;
  late bool offline;
  late DateTime now;
  late VersionService service;

  setUp(() {
    requests = [];
    version = 'v1';
    offline = false;
    now = DateTime(2026, 10, 17, 10);
    service = VersionService(
      ApiClient(MockClient((r) async {
        if (offline) throw http.ClientException('offline');
        requests.add(r.url);
        return http.Response(jsonEncode({'version': version}), 200);
      }), Duration.zero),
      now: () => now,
    );
  });

  test('pide /version una sola vez por arranque', () async {
    expect(await service.current(), 'v1');
    expect(await service.current(), 'v1');
    expect(
        requests.map((u) => u.toString()), ['https://wilds.mhdb.io/version']);
  });

  test('si falla, la siguiente llamada lo reintenta', () async {
    offline = true;
    await expectLater(service.current(), throwsA(isA<NetworkException>()));
    offline = false;
    expect(await service.current(), 'v1');
  });

  test('al volver a primer plano solo repregunta tras más de 4 h', () async {
    var notified = 0;
    service.addListener(() => notified++);
    await service.current();

    now = now.add(const Duration(hours: 3));
    version = 'v2';
    await service.onResume();
    expect(requests, hasLength(1));
    expect(notified, 0);

    now = now.add(const Duration(hours: 2));
    await service.onResume();
    expect(requests, hasLength(2));
    expect(await service.current(), 'v2');
    expect(notified, 1);
  });
}
