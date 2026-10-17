import 'package:http/testing.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cache_store.dart';
import 'package:mhwilds_app/api/cached_api.dart';

/// [CacheStore] en memoria: los tests no tocan el disco ni `path_provider`.
class MemoryCacheStore extends CacheStore {
  final entries = <String, CacheEntry>{};

  @override
  Future<CacheEntry?> read(String lang, String endpoint) async =>
      entries['$lang/$endpoint'];

  @override
  Future<void> write(String lang, String endpoint, CacheEntry entry) async =>
      entries['$lang/$endpoint'] = entry;
}

/// [CachedApi] contra un [MockClient] sin esperas entre reintentos.
CachedApi fakeCachedApi(MockClientHandler handler, [CacheStore? store]) =>
    CachedApi(ApiClient(MockClient(handler), Duration.zero),
        store ?? MemoryCacheStore());
