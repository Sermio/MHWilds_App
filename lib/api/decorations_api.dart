import 'dart:convert';

import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class DecorationsApi {
  static Stream<Data<List<DecorationItem>>> watchDecorations(
          {bool force = false, String? lang, CachedApi? api}) =>
      (api ?? CachedApi.shared)
          .watch('decorations', _parse, force: force, lang: lang);

  static Future<List<DecorationItem>> _parse(String body) async =>
      (json.decode(body) as List<dynamic>)
          .map((e) => DecorationItem.fromJson(e))
          .toList();
}
