import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/armor_sets_api.dart';
import 'package:mhwilds_app/models/armor_set.dart';

class ArmorSetProvider with ChangeNotifier {
  List<ArmorSet> _allArmorSets = [];
  List<ArmorSet> _filteredArmorSets = [];
  bool _isLoading = false;

  String _nameFilter = '';
  String? _kindFilter;

  List<ArmorSet> get armorSets => _filteredArmorSets;
  bool get isLoading => _isLoading;
  bool get hasData => _allArmorSets.isNotEmpty;

  Future<void> fetchArmorSets() async {
    if (_allArmorSets.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allArmorSets = await ArmorApi.fetchArmorSets(); // Ajusta la API
      _filteredArmorSets =
          List.from(_allArmorSets); // Inicializamos la lista filtrada
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, String? kind}) {
    _nameFilter = name ?? _nameFilter;
    _kindFilter = kind ?? _kindFilter;

    // Si no hay filtros aplicados, no filtramos las piezas.
    if (_nameFilter.isEmpty && _kindFilter == null) {
      _filteredArmorSets = List.from(_allArmorSets);
      for (var set in _filteredArmorSets) {
        set.pieces = List.from(
            set.pieces); // Restauramos las piezas originales sin ningún filtro
      }
    } else {
      _filteredArmorSets = _allArmorSets.where((set) {
        final matchesName = _nameFilter.isEmpty ||
            set.name.toLowerCase().contains(_nameFilter.toLowerCase());

        // Filtrar las piezas dentro del set según el 'kind'
        final filteredPieces = set.pieces.where((piece) {
          final matchesKind = _kindFilter == null || piece.kind == _kindFilter;
          return matchesKind;
        }).toList();

        // Solo incluir el set si tiene piezas que coinciden con el filtro de 'kind'
        return matchesName && filteredPieces.isNotEmpty;
      }).toList();

      // Actualizamos las piezas filtradas dentro de cada ArmorSet
      for (var set in _filteredArmorSets) {
        set.pieces = set.pieces.where((piece) {
          return _kindFilter == null || piece.kind == _kindFilter;
        }).toList();
      }
    }

    notifyListeners();
  }

  void clearFilters() async {
    _nameFilter = '';
    _kindFilter = null;

    // Llamamos a fetchArmorSets() para recargar todos los sets completos.
    await fetchArmorSets(); // Asegúrate de que esta llamada termine antes de continuar.

    // Después de recargar los sets, restablecemos los sets filtrados a su estado original
    _filteredArmorSets = List.from(_allArmorSets);

    notifyListeners(); // Notificamos a los listeners para que la UI se actualice.
  }
  // void clearFilters() {
  //   _nameFilter = '';
  //   _kindFilter = null;
  //   _filteredArmorSets = List.from(_allArmorSets); // Restaurar lista completa
  //   notifyListeners();
  // }
}
