import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mhwilds_app/api/cached_api.dart';

/// Cache de nombres en inglés por ID para construir URLs de imágenes.
/// Las imágenes (fextralife, etc.) usan nombres en inglés; al cambiar el idioma
/// de la API los nombres vienen traducidos, por lo que las URLs fallan.
/// Este provider obtiene una sola vez los listados en inglés y expone
/// el nombre EN por id para usarlo solo al construir URLs de imagen.
///
/// Pide solo `id` y `name` de cada endpoint y lo guarda con [CachedApi]: tras
/// el primer arranque se rellena desde disco sin esperar a la red. Nada espera
/// a esta caché; quien la necesita escucha el provider y enseña un placeholder
/// hasta que está lista.
class EnNamesCache extends ChangeNotifier {
  EnNamesCache([CachedApi? api]) : _api = api ?? CachedApi.shared;

  final CachedApi _api;

  final Map<int, String> _monsterNames = {};
  final Map<int, String> _itemNames = {};
  final Map<int, String> _skillNames = {};
  final Map<int, String> _mapNames = {};
  bool _loaded = false;
  bool _loading = false;

  final Completer<void> _cacheReadyCompleter = Completer<void>();

  /// Completa cuando el cache ha terminado de cargar (o ha fallado).
  /// Esperar a este Future antes de mostrar imágenes evita usar nombres traducidos.
  Future<void> get cacheReady => _cacheReadyCompleter.future;

  bool get isLoaded => _loaded;
  bool get isLoading => _loading;

  String? getMonsterNameEn(int id) => _monsterNames[id];
  String? getItemNameEn(int id) => _itemNames[id];
  String? getSkillNameEn(int id) => _skillNames[id];
  String? getMapNameEn(int id) => _mapNames[id];

  /// Nombre en inglés para usar en URLs/assets de imagen.
  /// Si el cache no está cargado, devuelve null (no usar fallback traducido).
  /// Si el cache está cargado pero no tiene el ID, devuelve currentName como fallback.
  String? nameForMonsterImage(int id, String currentName) {
    if (!_loaded) return null; // Cache no listo, no usar nombre traducido
    return _monsterNames[id] ??
        currentName; // Si no está en cache, usar el nombre actual
  }

  String? nameForItemImage(int id, String currentName) {
    if (!_loaded) return null;
    return _itemNames[id] ?? currentName;
  }

  String? nameForSkillImage(int id, String currentName) {
    if (!_loaded) return null;
    return _skillNames[id] ?? currentName;
  }

  String? nameForMapImage(int id, String currentName) {
    if (!_loaded) return null;
    return _mapNames[id] ?? currentName;
  }

  /// Carga los listados en inglés (monsters, items, skills, locations) y
  /// rellena el cache. Se llama una vez al crear el provider.
  Future<void> loadEnNames() async {
    if (_loading || _loaded) {
      if (_loaded && !_cacheReadyCompleter.isCompleted) {
        _cacheReadyCompleter.complete();
      }
      return;
    }
    _loading = true;
    notifyListeners();

    try {
      await Future.wait([
        _load('monsters', _monsterNames),
        _load('items', _itemNames),
        _load('skills', _skillNames),
        _load('locations', _mapNames),
      ]);
      _loaded = true;
    } catch (e) {
      debugPrint('EnNamesCache: error loading en names: $e');
    } finally {
      _loading = false;
      if (!_cacheReadyCompleter.isCompleted) {
        _cacheReadyCompleter.complete();
      }
      notifyListeners();
    }
  }

  /// Rellena [target] con `endpoint?p={"id":true,"name":true}`. Termina con la
  /// primera emisión (la caché en disco si existe); la revalidación contra la
  /// red sigue en segundo plano y actualiza el mapa cuando llega.
  Future<void> _load(String endpoint, Map<int, String> target) {
    final first = Completer<void>();
    _api
        .watch(
      endpoint,
      _parse,
      lang: 'en',
      query: const {'p': '{"id":true,"name":true}'},
      cacheKey: '${endpoint}_names',
    )
        .listen(
      (data) {
        target
          ..clear()
          ..addAll(data.value);
        if (!first.isCompleted) {
          first.complete();
        } else {
          notifyListeners();
        }
      },
      onError: (Object e, StackTrace st) {
        if (!first.isCompleted) first.completeError(e, st);
      },
      onDone: () {
        if (!first.isCompleted) first.complete();
      },
    );
    return first.future;
  }

  static Future<Map<int, String>> _parse(String body) async {
    final names = <int, String>{};
    for (final e in json.decode(body) as List<dynamic>) {
      if (e is Map<String, dynamic>) {
        final id = e['id'] as int?;
        final name = e['name'] as String?;
        if (id != null && name != null && name.isNotEmpty) names[id] = name;
      }
    }
    return names;
  }
}
