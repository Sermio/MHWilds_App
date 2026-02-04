import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:mhwilds_app/api/api_config.dart';

/// Cache de nombres en inglés por ID para construir URLs de imágenes.
/// Las imágenes (fextralife, etc.) usan nombres en inglés; al cambiar el idioma
/// de la API los nombres vienen traducidos, por lo que las URLs fallan.
/// Este provider obtiene una sola vez los listados en inglés y expone
/// el nombre EN por id para usarlo solo al construir URLs de imagen.
class EnNamesCache extends ChangeNotifier {
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

  /// Carga los listados en inglés (monsters, items, skills) y rellena el cache.
  Future<void> loadEnNames() async {
    if (_loading || _loaded) {
      if (_loaded && !_cacheReadyCompleter.isCompleted) {
        _cacheReadyCompleter.complete();
      }
      return;
    }
    _loading = true;
    notifyListeners();

    final base = ApiConfig.baseUrlForLanguage('en');
    try {
      await Future.wait([
        _fetchMonsters(base),
        _fetchItems(base),
        _fetchSkills(base),
        _fetchLocations(base),
      ]);
      _loaded = true;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('EnNamesCache: error loading en names: $e');
      }
    } finally {
      _loading = false;
      if (!_cacheReadyCompleter.isCompleted) {
        _cacheReadyCompleter.complete();
      }
      notifyListeners();
    }
  }

  Future<void> _fetchMonsters(String base) async {
    final response = await http.get(Uri.parse('$base/monsters'));
    if (response.statusCode != 200) return;
    final list = json.decode(response.body) as List<dynamic>?;
    if (list == null) return;
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        final id = e['id'] as int?;
        final name = e['name'] as String?;
        if (id != null && name != null && name.isNotEmpty) {
          _monsterNames[id] = name;
        }
      }
    }
  }

  Future<void> _fetchItems(String base) async {
    final response = await http.get(Uri.parse('$base/items'));
    if (response.statusCode != 200) return;
    final list = json.decode(response.body) as List<dynamic>?;
    if (list == null) return;
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        final id = e['id'] as int?;
        final name = e['name'] as String?;
        if (id != null && name != null && name.isNotEmpty) {
          _itemNames[id] = name;
        }
      }
    }
  }

  Future<void> _fetchSkills(String base) async {
    final response = await http.get(Uri.parse('$base/skills'));
    if (response.statusCode != 200) return;
    final list = json.decode(response.body) as List<dynamic>?;
    if (list == null) return;
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        final id = e['id'] as int?;
        final name = e['name'] as String?;
        if (id != null && name != null && name.isNotEmpty) {
          _skillNames[id] = name;
        }
      }
    }
  }

  Future<void> _fetchLocations(String base) async {
    final response = await http.get(Uri.parse('$base/locations'));
    if (response.statusCode != 200) return;
    final list = json.decode(response.body) as List<dynamic>?;
    if (list == null) return;
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        final id = e['id'] as int?;
        final name = e['name'] as String?;
        if (id != null && name != null && name.isNotEmpty) {
          _mapNames[id] = name;
        }
      }
    }
  }
}
