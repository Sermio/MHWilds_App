import 'package:mhwilds_app/api/decorations_api.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/providers/filters/decoration_filter.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class DecorationsProvider
    extends CatalogProvider<DecorationItem, DecorationFilter> {
  DecorationsProvider({super.api}) : super(const DecorationFilter());

  List<DecorationItem> get decorations => all;
  List<DecorationItem> get filteredDecorations => visible;

  Future<void> fetchDecorations() => fetch();

  @override
  Stream<Data<List<DecorationItem>>> watch({required bool force}) =>
      DecorationsApi.watchDecorations(force: force, lang: language, api: api);

  @override
  List<DecorationItem> applyFilter(
          List<DecorationItem> items, DecorationFilter filter) =>
      filterDecorations(items, filter);
}
