import 'package:mhwilds_app/providers/skills_provider.dart';

import 'cached_list_provider_contract.dart';

void main() {
  cachedListProviderContract<SkillsProvider>(
    'SkillsProvider',
    fixture: 'skills',
    create: (api) => SkillsProvider(api: api),
    total: (p) => p.skills.length,
    filter: (p) => p.applyFilters(name: p.skills.first.name),
    visible: (p) => p.skills.length,
  );
}
