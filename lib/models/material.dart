class MaterialItem {
  String name;
  String rarity;
  String source;

  MaterialItem({
    required this.name,
    required this.rarity,
    required this.source,
  });

  // Convertir de un Map<String, dynamic> a un objeto MaterialItem
  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      name: map['name'],
      rarity: map['rarity'],
      source: map['source'],
    );
  }

  // Convertir un objeto MaterialItem a un Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rarity': rarity,
      'source': source,
    };
  }
}
