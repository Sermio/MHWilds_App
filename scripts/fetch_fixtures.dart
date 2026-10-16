// Descarga y recorta JSON de https://wilds.mhdb.io/en/ a test/fixtures/.
// Uso (desde la raíz): dart run scripts/fetch_fixtures.dart
// Los tests nunca hacen red; este script se ejecuta a mano y los fixtures se commitean.
import 'dart:convert';
import 'dart:io';

const _base = 'https://wilds.mhdb.io/en';
const _perFile = 3;

/// endpoint -> nombre de archivo
const _endpoints = {
  'monsters': 'monsters',
  'armor': 'armor',
  'armor/sets': 'armor_sets',
  'decorations': 'decorations',
  'charms': 'charms',
  'items': 'items',
  'skills': 'skills',
  'locations': 'locations',
};

Future<List<dynamic>> _get(HttpClient client, String path) async {
  final req = await client.getUrl(Uri.parse('$_base/$path'));
  final res = await req.close();
  if (res.statusCode != 200) {
    throw HttpException('$path -> ${res.statusCode}');
  }
  return jsonDecode(await res.transform(utf8.decoder).join()) as List<dynamic>;
}

void _write(String name, Object data) {
  File('test/fixtures/$name.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  stdout.writeln('test/fixtures/$name.json');
}

Future<void> main() async {
  final client = HttpClient();
  try {
    for (final e in _endpoints.entries) {
      final list = await _get(client, e.key);
      _write(e.value, list.take(_perFile).toList());
    }

    // Armas: primera y última de cada tipo (la última suele traer más campos).
    final weapons = await _get(client, 'weapons');
    final byKind = <String, List<dynamic>>{};
    for (final w in weapons) {
      byKind.putIfAbsent((w as Map)['kind'] as String, () => []).add(w);
    }
    _write('weapons', [
      for (final list in byKind.values) ...{list.first, list.last},
    ]);
  } finally {
    client.close();
  }
}
