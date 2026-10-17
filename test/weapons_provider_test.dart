import 'package:mhwilds_app/providers/weapons_provider.dart';

import 'cached_list_provider_contract.dart';
import 'package:mhwilds_app/providers/filters/weapon_filter.dart';

void main() {
  cachedListProviderContract<WeaponsProvider>(
    'WeaponsProvider',
    fixture: 'weapons',
    create: (api) => WeaponsProvider(api: api),
    total: (p) => p.weapons.length,
    filter: (p) => p.setFilter(WeaponFilter(name: p.weapons.first.name)),
    visible: (p) => p.weapons.length,
  );
}
