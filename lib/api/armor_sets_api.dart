import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'dart:convert';

class ArmorsApi {
  static Future<List<ArmorSet>> fetchArmorSets() async {
    final response = await http.get(Uri.parse(ApiConfig.url('armor/sets')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => ArmorSet.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar armors sets: ${response.statusCode}');
    }
  }
}
