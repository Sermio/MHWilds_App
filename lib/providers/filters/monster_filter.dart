import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';
import 'package:mhwilds_app/utils/text_utils.dart';

class MonsterFilter extends CatalogFilter {
  const MonsterFilter({
    this.name = '',
    this.species,
    this.rank,
    this.locations = const [],
  });

  final String name;
  final String? species;
  final String? rank;

  /// Nombres de zona; basta con que el monstruo aparezca en una.
  final List<String> locations;

  MonsterFilter copyWith({
    String? name,
    String? Function()? species,
    String? Function()? rank,
    List<String>? locations,
  }) =>
      MonsterFilter(
        name: name ?? this.name,
        species: species != null ? species() : this.species,
        rank: rank != null ? rank() : this.rank,
        locations: locations ?? this.locations,
      );

  @override
  List<Object?> get props => [name, species, rank, locations];
}

/// Monstruos que cumplen [filter]. [normalizedNames] (id → nombre sin tildes)
/// evita recalcularlo en cada pulsación; si falta se calcula al vuelo.
List<Monster> filterMonsters(
  List<Monster> monsters,
  MonsterFilter filter, {
  Map<int, String>? normalizedNames,
}) {
  final search = removeDiacritics(filter.name);
  return monsters.where((m) {
    final matchesName = filter.name.isEmpty ||
        (normalizedNames?[m.id] ?? removeDiacritics(m.name)).contains(search);
    final matchesSpecies =
        filter.species == null || m.species == filter.species;
    final matchesRank =
        filter.rank == null || m.availableRanks.contains(filter.rank);
    final matchesLocation = filter.locations.isEmpty ||
        m.locations.any((location) => filter.locations.any(
            (loc) => location.name.toLowerCase().contains(loc.toLowerCase())));
    return matchesName && matchesSpecies && matchesRank && matchesLocation;
  }).toList();
}
