import 'package:mhwilds_app/api/announcements_api.dart';
import 'package:mhwilds_app/models/announcement.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Anuncios del repo y el último que el usuario ha visto (para el punto de
/// «nuevo» del drawer). No sigue el idioma: el JSON trae todos.
class AnnouncementsProvider extends CatalogProvider<Announcement, NoFilter> {
  AnnouncementsProvider({super.api}) : super(const NoFilter()) {
    _loadLastSeen();
  }

  static const lastSeenKey = 'announcements_last_seen_id';

  String? _lastSeenId;
  bool _lastSeenLoaded = false;

  /// El anuncio más reciente (el primero del archivo) aún no se ha visto.
  bool get hasUnseen =>
      _lastSeenLoaded && all.isNotEmpty && all.first.id != _lastSeenId;

  Future<void> _loadLastSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastSeenId = prefs.getString(lastSeenKey);
    } catch (_) {
      // Sin preferencias se trata como si no hubiera visto ninguno.
    }
    _lastSeenLoaded = true;
    notifyListeners();
  }

  /// Marca como visto el anuncio más reciente.
  Future<void> markSeen() async {
    if (!hasUnseen) return;
    _lastSeenId = all.first.id;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(lastSeenKey, _lastSeenId!);
    } catch (_) {
      // Solo se pierde el «visto» tras reiniciar la app.
    }
  }

  @override
  Stream<Data<List<Announcement>>> watch({required bool force}) =>
      AnnouncementsApi.watchAnnouncements(api: api);

  @override
  List<Announcement> applyFilter(List<Announcement> items, NoFilter filter) =>
      items;
}
