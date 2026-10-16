import 'dart:isolate';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'dart:convert';

class AmuletsApi {
  static Stream<Data<List<Amulet>>> watchAmulets(
          {bool force = false, CachedApi? api}) =>
      (api ?? CachedApi.shared).watch('charms', _parse, force: force);

  static Future<List<Amulet>> _parse(String body) => Isolate.run(() {
        final List<dynamic> jsonData = json.decode(body);
        return jsonData.map((e) => Amulet.fromJson(e)).toList();
      });
}
