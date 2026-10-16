import 'package:mhwilds_app/api/locations_api.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/utils/load_state.dart';

class LocationsProvider extends CachedListProvider<MapData> {
  LocationsProvider({super.api});

  List<MapData> _zones = [];

  List<MapData> get zones => _zones;

  Future<void> fetchZones() => fetch();

  @override
  Stream<Data<List<MapData>>> watch({required bool force}) =>
      LocationsApi.watchLocations(force: force, api: api);

  @override
  void onData(List<MapData> data) {
    _zones = data;
    _zones.sort((a, b) =>
        (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase()));
  }

  @override
  void onReset() => _zones = [];
}
