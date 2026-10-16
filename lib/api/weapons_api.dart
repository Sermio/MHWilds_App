import 'dart:isolate';
import 'dart:convert';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class WeaponsApi {
  static Stream<Data<List<Weapon>>> watchWeapons(
          {bool force = false, CachedApi? api}) =>
      (api ?? CachedApi.shared).watch('weapons', _parse, force: force);

  static Future<List<Weapon>> _parse(String body) => Isolate.run(() {
        final List<dynamic> jsonData = json.decode(body);
        final List<Weapon> weapons = [];
        for (int i = 0; i < jsonData.length; i++) {
          try {
            weapons.add(Weapon.fromJson(jsonData[i]));
          } catch (_) {
            // Skip malformed entries.
          }
        }
        return weapons;
      });

  static Future<Weapon> fetchWeaponById(int id) async {
    try {
      final Map<String, dynamic> jsonData =
          await ApiClient.shared.getJson('weapons/$id');
      return Weapon.fromJson(jsonData);
    } catch (e) {
      throw Exception('Error fetching weapon: $e');
    }
  }
}
