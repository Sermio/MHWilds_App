import 'dart:convert';

import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class LocationsApi {
  static Stream<Data<List<MapData>>> watchLocations(
          {bool force = false, String? lang, CachedApi? api}) =>
      (api ?? CachedApi.shared)
          .watch('locations', _parse, force: force, lang: lang);

  static Future<List<MapData>> _parse(String body) async =>
      (json.decode(body) as List<dynamic>)
          .map((e) => MapData.fromJson(e))
          .toList();
}
