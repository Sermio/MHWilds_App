import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/models/item.dart';
import 'dart:convert';

class ItemsApi {
  static Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse(ApiConfig.url('items')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar item: ${response.statusCode}');
    }
  }
}
