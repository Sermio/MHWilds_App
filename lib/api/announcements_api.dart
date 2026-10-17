import 'dart:convert';

import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/models/announcement.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class AnnouncementsApi {
  static const url =
      'https://raw.githubusercontent.com/Sermio/MHWilds_App/main/announcements/announcements.json';

  /// El archivo trae todos los idiomas: una sola copia en disco (la de `en`).
  /// Siempre se pide (`force`): la versión de la API de datos no lo cubre.
  static Stream<Data<List<Announcement>>> watchAnnouncements(
          {CachedApi? api}) =>
      (api ?? CachedApi.shared).watch(url, parse,
          force: true,
          lang: ApiConfig.defaultLanguage,
          cacheKey: 'announcements');

  static Future<List<Announcement>> parse(String body) async =>
      Announcement.listFromJson(json.decode(body) as Map<String, dynamic>);
}
