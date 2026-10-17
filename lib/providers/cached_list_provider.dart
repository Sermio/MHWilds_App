import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/utils/load_state.dart';

/// Base de los providers de listas: carga con caché y revalidación
/// (stale-while-revalidate) y expone un [LoadState]. Cada subclase solo
/// indica de dónde vienen los datos y qué hacer con ellos.
abstract class CachedListProvider<T> with ChangeNotifier {
  CachedListProvider({CachedApi? api}) : api = api ?? CachedApi.shared {
    this.api.versions.addListener(_onNewVersion);
  }

  final CachedApi api;

  String _language = ApiConfig.defaultLanguage;

  /// Idioma de la API con el que se piden los datos.
  String get language => _language;

  /// Cambia el idioma de los datos (lo llama el `ProxyProvider` de
  /// `LocaleProvider`). Si ya había datos cargados o en carga, se vacía la
  /// memoria y se vuelve a cargar en el idioma nuevo: de la caché en disco si
  /// ya existe, de la API si no. Si no se había cargado nada, solo recuerda el
  /// idioma para la primera carga.
  void setLanguage(String language) {
    if (language == _language) return;
    final wasActive = _state is! Idle;
    _language = language;
    if (!wasActive) return;
    // Se invoca desde `update` de un provider, es decir, durante un build: la
    // invalidación (que notifica) y la recarga esperan a que termine.
    final generation = ++_languageChanges;
    scheduleMicrotask(() {
      if (generation != _languageChanges) return;
      invalidate();
      unawaited(fetch());
    });
  }

  int _languageChanges = 0;
  LoadState<List<T>> _state = const Idle();
  bool _revalidating = false;
  // Se incrementa en [invalidate] para descartar cargas en curso del idioma anterior.
  int _generation = 0;

  /// Flujo de la API: caché primero y datos revalidados después.
  Stream<Data<List<T>>> watch({required bool force});

  /// Ordena, indexa y reaplica los filtros activos con los datos recibidos.
  void onData(List<T> data);

  /// Vacía los datos y filtros de la subclase.
  void onReset();

  LoadState<List<T>> get state => _state;
  bool get isLoading => _state is Loading;
  bool get hasData => _state is Data;

  /// Datos de caché que no se han podido revalidar (sin conexión).
  bool get isOffline =>
      !_revalidating && _state is Data<List<T>> && (_state as Data).stale;

  /// Vacía la memoria (p. ej. al cambiar idioma). La caché en disco de cada
  /// idioma se conserva, así que la próxima carga es instantánea si ya existía.
  void invalidate() {
    _generation++;
    _revalidating = false;
    onReset();
    _state = const Idle();
    notifyListeners();
  }

  /// Carga la lista si aún no está; si falla deja [state] en [Failure]
  /// (se reintenta llamando de nuevo).
  Future<void> fetch() async {
    if (_state is Data || _revalidating) return;
    await refresh();
  }

  /// Muestra la caché al instante y la revalida con la API.
  /// [force] (pull-to-refresh) pide la API aunque la versión no haya cambiado.
  Future<void> refresh({bool force = false}) async {
    if (_revalidating) return;
    final generation = _generation;
    _revalidating = true;
    if (_state is! Data) _state = const Loading();
    notifyListeners();

    try {
      await for (final data in watch(force: force)) {
        if (generation != _generation) return;
        onData(data.value);
        _state = data;
        notifyListeners();
      }
    } catch (e) {
      if (generation == _generation && _state is! Data) _state = Failure(e);
    } finally {
      if (generation == _generation) {
        _revalidating = false;
        notifyListeners();
      }
    }
  }

  void _onNewVersion() {
    if (_state is Data) refresh();
  }

  @override
  void dispose() {
    api.versions.removeListener(_onNewVersion);
    super.dispose();
  }
}
