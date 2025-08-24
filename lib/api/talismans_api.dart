import 'package:http/http.dart' as http;
import 'package:mhwilds_app/models/talisman.dart';
import 'dart:convert';

class AmuletsApi {
  static Future<List<Amulet>> fetchAmulets() async {
    final response =
        await http.get(Uri.parse('https://wilds.mhdb.io/en/charms'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Amulet.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar talismans: ${response.statusCode}');
    }
  }
}
