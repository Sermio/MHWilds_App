import 'dart:convert';
import 'dart:io';

/// Carga `test/fixtures/<name>.json` (generado por scripts/fetch_fixtures.dart).
List<Map<String, dynamic>> loadFixture(String name) {
  final raw = File('test/fixtures/$name.json').readAsStringSync();
  return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
}
