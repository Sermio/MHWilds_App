import 'dart:io';

import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/api/cache_store.dart';
import 'package:mhwilds_app/api/version_service.dart';
import 'package:mhwilds_app/utils/load_state.dart';

/// Endpoints de lista con caché en disco y revalidación (stale-while-revalidate).
class CachedApi {
  CachedApi(this.client, this.store, [VersionService? versions])
      : versions = versions ?? VersionService(client);

  static CachedApi shared = CachedApi(ApiClient.shared, CacheStore());

  final ApiClient client;
  final CacheStore store;
  final VersionService versions;

  /// Emite primero la caché del idioma actual (`stale: true`), si la hay, y
  /// después el resultado de revalidarla (`stale: false`). Sin red y con caché
  /// el flujo termina tras la primera emisión; sin red y sin caché, lanza.
  /// [force] pide el endpoint aunque la versión no haya cambiado.
  /// [parse] convierte el JSON crudo; si falla, no se guarda nada.
  Stream<Data<T>> watch<T>(
    String endpoint,
    Future<T> Function(String body) parse, {
    bool force = false,
  }) async* {
    final lang = ApiConfig.languageCode;
    var cached = await store.read(lang, endpoint);
    late T value;
    if (cached != null) {
      try {
        value = await parse(cached.body);
      } catch (_) {
        cached = null; // Caché corrupta o de un formato viejo: se ignora.
      }
    }
    if (cached != null) {
      yield Data(value, stale: true, updatedAt: cached.fetchedAt);
    }

    String? remote;
    try {
      remote = await versions.current();
    } catch (_) {
      if (cached != null && !force) return;
    }
    if (cached != null && !force && remote == cached.version) {
      yield Data(value, updatedAt: cached.fetchedAt);
      return;
    }

    final ApiResponse r;
    final T fresh;
    try {
      r = await client.get(endpoint,
          lang: lang, ifModifiedSince: cached?.ifModifiedSince);
      if (r.notModified && cached != null) {
        // Se mantiene la versión guardada: si el 304 venía de una CDN
        // desfasada, el próximo arranque vuelve a preguntar.
        final touched = cached.copyWith(fetchedAt: DateTime.now());
        await store.write(lang, endpoint, touched);
        yield Data(value, updatedAt: touched.fetchedAt);
        return;
      }
      fresh = await parse(r.body);
    } catch (_) {
      if (cached == null) rethrow;
      return;
    }
    final entry = CacheEntry(
      body: r.body,
      fetchedAt: DateTime.now(),
      version:
          _isFromVersion(r.lastModified, remote) ? remote : cached?.version,
      lastModified: r.lastModified,
    );
    await store.write(lang, endpoint, entry);
    yield Data(fresh, updatedAt: entry.fetchedAt);
  }

  /// Una respuesta cacheada por la CDN antes de la importación (last-modified
  /// anterior a la versión) no se marca con la versión nueva.
  static bool _isFromVersion(String? lastModified, String? version) {
    if (lastModified == null || version == null) return true;
    final v = DateTime.tryParse(version);
    try {
      return v == null || !HttpDate.parse(lastModified).isBefore(v);
    } on FormatException {
      return true;
    }
  }
}
