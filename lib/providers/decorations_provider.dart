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

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _decorations = [];
    _filteredDecorations = [];
    notifyListeners();
  }

  Future<void> fetchDecorations() async {
    if (_decorations.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _decorations = await DecorationsApi.fetchDecorations();

      _filteredDecorations = List.from(_decorations);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

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

  void clearFilters() {
    _filteredDecorations = _decorations;
    notifyListeners();
  }
}
