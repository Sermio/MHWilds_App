import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mhwilds_app/api/api_config.dart';

/// Error de red: sin conexión, DNS, timeout...
class NetworkException implements Exception {
  NetworkException(this.cause);
  final Object cause;
  @override
  String toString() => 'NetworkException: $cause';
}

/// Respuesta HTTP fuera de 2xx/304.
class ApiHttpException implements Exception {
  ApiHttpException(this.statusCode);
  final int statusCode;
  @override
  String toString() => 'ApiHttpException: HTTP $statusCode';
}

/// El cuerpo no es JSON válido.
class ApiParseException implements Exception {
  ApiParseException(this.cause);
  final Object cause;
  @override
  String toString() => 'ApiParseException: $cause';
}

/// Respuesta cruda. [notModified] es true ante un 304 (el cuerpo viene vacío).
class ApiResponse {
  const ApiResponse(this.body, {this.lastModified, this.notModified = false});
  final String body;
  final String? lastModified;
  final bool notModified;

  dynamic decode() {
    try {
      return json.decode(body);
    } on FormatException catch (e) {
      throw ApiParseException(e);
    }
  }
}

/// Cliente HTTP único de la app: timeout, un reintento y excepciones tipadas.
class ApiClient {
  ApiClient(
      [http.Client? client,
      this.retryDelay = const Duration(milliseconds: 300)])
      : _client = client ?? http.Client();

  /// Instancia usada por las clases estáticas de `lib/api/`; se expone con Provider.
  static ApiClient shared = ApiClient();

  static const timeout = Duration(seconds: 15);

  final http.Client _client;
  final Duration retryDelay;

  /// GET a [path] (relativo al host + idioma, o una URL absoluta `https://`).
  /// [lang] sustituye al idioma actual.
  /// [ifModifiedSince] se envía como `If-Modified-Since`.
  Future<ApiResponse> get(
    String path, {
    String? lang,
    Map<String, String>? query,
    Map<String, String>? headers,
    String? ifModifiedSince,
  }) async {
    final base =
        lang == null ? ApiConfig.baseUrl : ApiConfig.baseUrlForLanguage(lang);
    final p = path.startsWith('/') ? path.substring(1) : path;
    var uri = Uri.parse(path.startsWith('https://') ? path : '$base/$p');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: {...uri.queryParameters, ...query});
    }
    final allHeaders = {
      ...?headers,
      if (ifModifiedSince != null) 'If-Modified-Since': ifModifiedSince,
    };

    for (var attempt = 0;; attempt++) {
      Object failure;
      try {
        final r = await _client.get(uri, headers: allHeaders).timeout(timeout);
        if (r.statusCode == 304) {
          return ApiResponse('',
              lastModified: r.headers['last-modified'], notModified: true);
        }
        if (r.statusCode >= 200 && r.statusCode < 300) {
          return ApiResponse(r.body, lastModified: r.headers['last-modified']);
        }
        if (r.statusCode < 500) throw ApiHttpException(r.statusCode);
        failure = ApiHttpException(r.statusCode);
      } on TimeoutException catch (e) {
        failure = NetworkException(e);
      } on http.ClientException catch (e) {
        failure = NetworkException(e);
      } on SocketException catch (e) {
        failure = NetworkException(e);
      }
      if (attempt == 1) throw failure;
      await Future<void>.delayed(retryDelay);
    }
  }

  /// JSON decodificado; `null` si el servidor responde 304.
  /// Para leer `last-modified` usa [get].
  Future<dynamic> getJson(
    String path, {
    String? lang,
    Map<String, String>? query,
    Map<String, String>? headers,
    String? ifModifiedSince,
  }) async {
    final r = await get(path,
        lang: lang,
        query: query,
        headers: headers,
        ifModifiedSince: ifModifiedSince);
    return r.notModified ? null : r.decode();
  }
}
