import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/models/location.dart';

class LocationsApi {
  static Future<List<MapData>> fetchLocations() async {
    final response = await http.get(Uri.parse(ApiConfig.url('locations')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => MapData.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar locations: ${response.statusCode}');
    }
  }
}
