import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mhwilds_app/models/location.dart';

class LocationsApi {
  static Future<List<Zone>> fetchLocations() async {
    final response =
        await http.get(Uri.parse('https://wilds.mhdb.io/en/locations'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Zone.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar locations: ${response.statusCode}');
    }
  }
}
