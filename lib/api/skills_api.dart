import 'package:http/http.dart' as http;
import 'package:mhwilds_app/models/skills.dart';
import 'dart:convert';

class SkillsApi {
  static Future<List<Skills>> fetchSkills() async {
    final response =
        await http.get(Uri.parse('https://wilds.mhdb.io/en/skills'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Skills.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar skills: ${response.statusCode}');
    }
  }
}
