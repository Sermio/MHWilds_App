import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/models/decoration.dart';

class DecorationsApi {
  static Future<List<DecorationItem>> fetchDecorations() async {
    final response = await http.get(Uri.parse(ApiConfig.url('decorations')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => DecorationItem.fromJson(e)).toList();
    } else {
      throw Exception('Error loading decorations: ${response.statusCode}');
    }
  }
}
