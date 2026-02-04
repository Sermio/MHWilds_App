import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'dart:convert';

class SkillsApi {
  static Future<List<Skills>> fetchSkills() async {
    final response = await http.get(Uri.parse(ApiConfig.url('skills')));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Skills.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar skills: ${response.statusCode}');
    }
  }

  static Future<Skills> fetchSkillById(int skillId) async {
    final response =
        await http.get(Uri.parse(ApiConfig.url('skills/$skillId')));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Skills.fromJson(jsonData);
    } else {
      throw Exception(
          'Error al cargar la skill con ID $skillId: ${response.statusCode}');
    }
  }
}
