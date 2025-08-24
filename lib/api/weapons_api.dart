import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mhwilds_app/models/weapon.dart';

class WeaponsApi {
  static const String baseUrl = 'https://wilds.mhdb.io/en';

  static Future<List<Weapon>> fetchWeapons() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/weapons'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Weapon> weapons = [];
        int successCount = 0;
        int errorCount = 0;

        for (int i = 0; i < jsonData.length; i++) {
          try {
            final weapon = Weapon.fromJson(jsonData[i]);
            weapons.add(weapon);
            successCount++;
          } catch (e) {
            errorCount++;
          }
        }

        return weapons;
      } else {
        throw Exception('Failed to load weapons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weapons: $e');
    }
  }

  static Future<Weapon> fetchWeaponById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/weapons/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Weapon.fromJson(jsonData);
      } else {
        throw Exception('Failed to load weapon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weapon: $e');
    }
  }
}
