import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/decorations_api.dart';
import 'package:mhwilds_app/models/decoration.dart';

class DecorationsProvider with ChangeNotifier {
  List<DecorationItem> _decorations = [];
  List<DecorationItem> _filteredDecorations = [];
  bool _isLoading = false;

  List<DecorationItem> get decorations => _decorations;
  List<DecorationItem> get filteredDecorations => _filteredDecorations;

  bool get hasData => _decorations.isNotEmpty;
  bool get isLoading => _isLoading;

  // Método para cargar las decoraciones (puede ser desde un API o base de datos)
  Future<void> fetchDecorations() async {
    // Si ya hay decoraciones cargadas, no las volvemos a cargar.
    if (_decorations.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Aquí es donde deberías llamar al API para obtener las decoraciones.
      _decorations = await DecorationsApi
          .fetchDecorations(); // Asegúrate de tener esta llamada API configurada
      // _originalDecorations = List.from(_decorations);
      _filteredDecorations = List.from(_decorations);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  // Método para aplicar filtros basados en nombre o tipo
  void applyFilters({String? name, String? type}) {
    _filteredDecorations = _decorations.where((decoration) {
      bool matchesName = name == null ||
          decoration.name.toLowerCase().contains(name.toLowerCase());
      bool matchesType =
          type == null || decoration.kind.toLowerCase() == type.toLowerCase();
      return matchesName && matchesType;
    }).toList();
    notifyListeners();
  }

  // Método para limpiar filtros
  void clearFilters() {
    _filteredDecorations = _decorations;
    notifyListeners();
  }
}
