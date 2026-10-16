import 'package:mhwilds_app/api/decorations_api.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class DecorationsProvider extends CachedListProvider<DecorationItem> {
  DecorationsProvider({super.api});

  List<DecorationItem> _decorations = [];
  List<DecorationItem> _filteredDecorations = [];
  // Filtros activos, para reaplicarlos cuando llegan datos nuevos.
  String? _name;
  String? _type;

  List<DecorationItem> get decorations => _decorations;
  List<DecorationItem> get filteredDecorations => _filteredDecorations;

  Future<void> fetchDecorations() => fetch();

  @override
  Stream<Data<List<DecorationItem>>> watch({required bool force}) =>
      DecorationsApi.watchDecorations(force: force, api: api);

  @override
  void onData(List<DecorationItem> data) {
    _decorations = data;
    _filter();
  }

  @override
  void onReset() {
    _decorations = [];
    _filteredDecorations = [];
    _name = _type = null;
  }

  void applyFilters({String? name, String? type}) {
    _name = name;
    _type = type;
    _filter();
    notifyListeners();
  }

  void _filter() {
    final name = _name;
    final type = _type;
    _filteredDecorations = _decorations.where((decoration) {
      final bool matchesName = name == null ||
          decoration.name.toLowerCase().contains(name.toLowerCase());
      final bool matchesType =
          type == null || decoration.kind.toLowerCase() == type.toLowerCase();
      return matchesName && matchesType;
    }).toList();

    _filteredDecorations.sort((a, b) {
      final slotCompare = b.displayLevel.compareTo(a.displayLevel);
      if (slotCompare != 0) return slotCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  void clearFilters() {
    _name = _type = null;
    _filter();
    notifyListeners();
  }
}
