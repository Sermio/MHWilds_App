import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mhwilds_app/models/monster.dart';

class MonstersApi {
  static Future<List<Monster>> fetchMonsters() async {
    final response =
        await http.get(Uri.parse('https://wilds.mhdb.io/en/monsters'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final monsters = jsonData.map((e) => Monster.fromJson(e)).toList();

      monsters
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      return monsters;
    } else {
      throw Exception('Error loading monsters: ${response.statusCode}');
    }
  }

  static Future<Monster> fetchMonsterById(int monsterId) async {
    final response = await http
        .get(Uri.parse('https://wilds.mhdb.io/en/monsters/$monsterId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return Monster.fromJson(jsonData);
    } else {
      throw Exception(
          'Error al cargar el monstruo con ID $monsterId: ${response.statusCode}');
    }
  }
}
