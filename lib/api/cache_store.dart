import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// JSON crudo de un endpoint y sus metadatos.
class CacheEntry {
  const CacheEntry({
    required this.body,
    required this.fetchedAt,
    this.version,
    this.lastModified,
  });

  final String body;
  final DateTime fetchedAt;

  /// Valor de `/version` con el que se guardó; null si no se pudo consultar.
  final String? version;

  /// Cabecera `last-modified` de la respuesta, para `If-Modified-Since`.
  final String? lastModified;

  String get ifModifiedSince => lastModified ?? HttpDate.format(fetchedAt);

  CacheEntry copyWith({DateTime? fetchedAt}) => CacheEntry(
        body: body,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        version: version,
        lastModified: lastModified,
      );
}

/// Caché en disco: `<soporte>/api_cache/<idioma>/<endpoint>.json` con el cuerpo
/// tal cual y `.meta.json` al lado. Cada idioma tiene la suya.
class CacheStore {
  CacheStore([Future<Directory> Function()? root])
      : _root = root ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _root;

  Future<File> _file(String lang, String endpoint, String ext) async {
    final dir = (await _root()).path;
    return File('$dir/api_cache/$lang/${endpoint.replaceAll('/', '_')}.$ext');
  }

  /// null si no hay caché o está incompleta/ilegible.
  Future<CacheEntry?> read(String lang, String endpoint) async {
    try {
      final meta = await _file(lang, endpoint, 'meta.json');
      final body = await _file(lang, endpoint, 'json');
      if (!await meta.exists() || !await body.exists()) return null;
      final m = json.decode(await meta.readAsString()) as Map<String, dynamic>;
      return CacheEntry(
        body: await body.readAsString(),
        fetchedAt: DateTime.parse(m['fetchedAt'] as String),
        version: m['version'] as String?,
        lastModified: m['lastModified'] as String?,
      );
    } catch (e) {
      debugPrint('CacheStore.read $lang/$endpoint: $e');
      return null;
    }
  }

  /// Sin fallar: si el disco da error, la app sigue con los datos en memoria.
  Future<void> write(String lang, String endpoint, CacheEntry entry) async {
    try {
      final body = await _file(lang, endpoint, 'json');
      await body.parent.create(recursive: true);
      // Primero el cuerpo y luego los metadatos: sin .meta no se lee nada.
      await body.writeAsString(entry.body, flush: true);
      await (await _file(lang, endpoint, 'meta.json')).writeAsString(
        json.encode({
          'version': entry.version,
          'fetchedAt': entry.fetchedAt.toIso8601String(),
          'lastModified': entry.lastModified,
        }),
        flush: true,
      );
    } catch (e) {
      debugPrint('CacheStore.write $lang/$endpoint: $e');
    }
  }
}
