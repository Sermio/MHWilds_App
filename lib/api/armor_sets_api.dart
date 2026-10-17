import 'dart:isolate';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'dart:convert';

class ArmorsApi {
  static Stream<Data<List<ArmorSet>>> watchArmorSets(
          {bool force = false, String? lang, CachedApi? api}) =>
      (api ?? CachedApi.shared)
          .watch('armor/sets', _parse, force: force, lang: lang);

  static Future<List<ArmorSet>> _parse(String body) => Isolate.run(() {
        final List<dynamic> jsonData = json.decode(body);
        return jsonData.map((e) => ArmorSet.fromJson(e)).toList();
      });
}
