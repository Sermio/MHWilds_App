import 'package:http/http.dart' as http;
import 'package:mhwilds_app/models/skills.dart';
import 'dart:convert';

class SkillsApi {
  static Future<List<Skill2>> fetchSkills() async {
    final response =
        await http.get(Uri.parse('https://wilds.mhdb.io/en/skills'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Skill2.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar skills: ${response.statusCode}');
    }
  }
}
