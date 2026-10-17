import 'package:mhwilds_app/api/locations_api.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class LocationsProvider extends CatalogProvider<MapData, NoFilter> {
  LocationsProvider({super.api}) : super(const NoFilter());

  List<MapData> get zones => all;

  Future<void> fetchZones() => fetch();

  @override
  Stream<Data<List<MapData>>> watch({required bool force}) =>
      LocationsApi.watchLocations(force: force, api: api);

  @override
  List<MapData> prepare(List<MapData> data) => data
    ..sort((a, b) =>
        (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));

  @override
  List<MapData> applyFilter(List<MapData> items, NoFilter filter) => items;
}
