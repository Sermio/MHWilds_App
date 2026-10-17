import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class SkillFilter extends CatalogFilter {
  const SkillFilter({this.name = '', this.kind});

  final String name;
  final String? kind;

  SkillFilter copyWith({String? name, String? Function()? kind}) => SkillFilter(
        name: name ?? this.name,
        kind: kind != null ? kind() : this.kind,
      );

  @override
  List<Object?> get props => [name, kind];
}

List<Skills> filterSkills(List<Skills> skills, SkillFilter filter) {
  final name = filter.name.toLowerCase();
  return skills.where((skill) {
    final matchesName = name.isEmpty || skill.name.toLowerCase().contains(name);
    final matchesKind = filter.kind == null || skill.kind == filter.kind;
    return matchesName && matchesKind;
  }).toList();
}
