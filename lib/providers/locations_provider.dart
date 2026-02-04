import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/locations_api.dart';
import 'package:mhwilds_app/models/location.dart';

class LocationsProvider with ChangeNotifier {
  List<MapData> _zones = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<MapData> get zones => _zones;

  bool get hasData => _zones.isNotEmpty;

  /// Invalida la caché para forzar nueva petición (p. ej. al cambiar idioma).
  void invalidate() {
    _zones = [];
    notifyListeners();
  }

  Future<void> fetchZones() async {
    if (_zones.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _zones = await LocationsApi.fetchLocations();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching zones: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
