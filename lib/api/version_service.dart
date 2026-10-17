import 'package:flutter/foundation.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/api_config.dart';

/// Versión de los datos de la API (`/version`, fecha de la última importación).
/// Se pide una vez por arranque; [onResume] la vuelve a pedir si pasaron más
/// de [recheckAfter] y avisa a los oyentes si cambió.
class VersionService extends ChangeNotifier {
  VersionService(this._client, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  /// Lo mismo que el `max-age` de Cloudflare.
  static const recheckAfter = Duration(hours: 4);

  final ApiClient _client;
  final DateTime Function() _now;
  Future<String>? _version;
  DateTime? _checkedAt;

  /// Versión remota. Si falla (sin red) se vuelve a intentar en la próxima llamada.
  Future<String> current() => _version ??= _fetch();

  Future<String> _fetch() async {
    try {
      final data = await _client.getJson('${ApiConfig.host}/version');
      final version = (data as Map<String, dynamic>)['version'] as String;
      _checkedAt = _now();
      return version;
    } catch (_) {
      _version = null;
      rethrow;
    }
  }

  Future<void> onResume() async {
    final checkedAt = _checkedAt;
    if (checkedAt == null || _now().difference(checkedAt) <= recheckAfter) {
      return;
    }
    final old = await _version;
    _version = null;
    try {
      if (await current() != old) notifyListeners();
    } catch (_) {
      // Sin red: se queda la caché; se reintentará en la próxima carga.
    }
  }
}
