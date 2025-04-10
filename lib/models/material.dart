class MaterialItem {
  String name;
  String rarity;
  String source;

  MaterialItem({
    required this.name,
    required this.rarity,
    required this.source,
  });

  factory MaterialItem.fromMap(Map<String, dynamic> map) {
    return MaterialItem(
      name: map['name'],
      rarity: map['rarity'],
      source: map['source'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rarity': rarity,
      'source': source,
    };
  }
}
