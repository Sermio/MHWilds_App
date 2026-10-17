import 'package:mhwilds_app/providers/cached_list_provider.dart';

/// Criterios de una lista: inmutable y con igualdad por valor. `==` con el
/// filtro vacío indica que no hay ningún criterio activo.
abstract class CatalogFilter {
  const CatalogFilter();

  /// Valores que definen el filtro (las listas se comparan por contenido).
  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      _same(props, (other as CatalogFilter).props);

  @override
  int get hashCode => Object.hashAll(props.map(_hash));

  static bool _same(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final x = a[i], y = b[i];
      if (x is List && y is List) {
        if (!_same(x, y)) return false;
      } else if (x != y) {
        return false;
      }
    }
    return true;
  }

  static int _hash(Object? v) =>
      v is List ? Object.hashAll(v.map(_hash)) : v.hashCode;
}

/// Para catálogos sin filtros (p. ej. las zonas del mapa).
class NoFilter extends CatalogFilter {
  const NoFilter();

  @override
  List<Object?> get props => const [];
}

/// Base de los providers de catálogo: carga con caché ([CachedListProvider]),
/// un filtro inmutable [F] y la lista ya filtrada. El filtro vive aquí, no en
/// la pantalla, así que sobrevive a salir y volver a una sección.
///
/// Cada entidad define su `F` y una función pura `List<T> filterX(List<T>, F)`
/// (testeable sin provider) que [applyFilter] solo invoca.
abstract class CatalogProvider<T, F extends CatalogFilter>
    extends CachedListProvider<T> {
  CatalogProvider(this.emptyFilter, {super.api}) : _filter = emptyFilter;

  /// Filtro sin criterios; también es el estado tras [onReset].
  final F emptyFilter;
  F _filter;
  List<T> _all = [];
  List<T> _visible = [];

  F get filter => _filter;

  /// Todos los datos, ya preparados por [prepare] y sin filtrar.
  List<T> get all => _all;

  /// Los datos que pasan el filtro actual.
  List<T> get visible => _visible;

  bool get hasActiveFilter => _filter != emptyFilter;

  /// Ordena o normaliza los datos recibidos. Puede mutar y devolver [data].
  List<T> prepare(List<T> data) => data;

  /// Aplica [filter] a [items]. Debe ser una llamada a una función pura.
  List<T> applyFilter(List<T> items, F filter);

  void setFilter(F filter) {
    _filter = filter;
    _visible = applyFilter(_all, _filter);
    notifyListeners();
  }

  void clearFilters() => setFilter(emptyFilter);

  @override
  void onData(List<T> data) {
    _all = prepare(data);
    // Conserva el filtro activo si llegan datos nuevos.
    _visible = applyFilter(_all, _filter);
  }

  @override
  void onReset() {
    _all = [];
    _visible = [];
    _filter = emptyFilter;
  }
}
