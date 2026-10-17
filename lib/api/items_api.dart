import 'dart:convert';

import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class ItemsApi {
  static Stream<Data<List<Item>>> watchItems(
          {bool force = false, String? lang, CachedApi? api}) =>
      (api ?? CachedApi.shared)
          .watch('items', _parse, force: force, lang: lang);

  static Future<List<Item>> _parse(String body) async =>
      (json.decode(body) as List<dynamic>)
          .map((e) => Item.fromJson(e))
          .toList();
}
