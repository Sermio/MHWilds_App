import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/locations_api.dart';
import 'package:mhwilds_app/models/location.dart';

class LocationsProvider with ChangeNotifier {
  List<Zone> _zones = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Zone> get zones => _zones;

  bool get hasData => _zones.isNotEmpty;

  Future<void> fetchZones() async {
    if (_zones.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _zones = await LocationsApi
          .fetchLocations(); // Llamada a la API para obtener las zonas
    } catch (e) {
      print("Error fetching zones: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
