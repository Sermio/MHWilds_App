import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/providers/catalog_provider.dart';

class DecorationFilter extends CatalogFilter {
  const DecorationFilter({this.name = '', this.type});

  final String name;
  final String? type;

  DecorationFilter copyWith({String? name, String? Function()? type}) =>
      DecorationFilter(
        name: name ?? this.name,
        type: type != null ? type() : this.type,
      );

  @override
  List<Object?> get props => [name, type];
}

/// Decoraciones que cumplen [filter], de mayor a menor nivel y luego por nombre.
List<DecorationItem> filterDecorations(
    List<DecorationItem> decorations, DecorationFilter filter) {
  final name = filter.name.toLowerCase();
  final type = filter.type?.toLowerCase();
  final result = decorations.where((d) {
    final matchesName = name.isEmpty || d.name.toLowerCase().contains(name);
    final matchesType = type == null || d.kind.toLowerCase() == type;
    return matchesName && matchesType;
  }).toList();
  result.sort((a, b) {
    final slotCompare = b.displayLevel.compareTo(a.displayLevel);
    if (slotCompare != 0) return slotCompare;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return result;
}
