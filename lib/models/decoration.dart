class DecorationItem {
  final String decorationName;
  final String decorationType;
  final String decorationRarity;
  final String decorationSlot;
  final String decorationSkill;
  final String decorationDescription;
  final String decorationMeldingCost;

  DecorationItem({
    required this.decorationName,
    required this.decorationType,
    required this.decorationRarity,
    required this.decorationSlot,
    required this.decorationSkill,
    required this.decorationDescription,
    required this.decorationMeldingCost,
  });

  factory DecorationItem.fromMap(Map<String, dynamic> map) {
    return DecorationItem(
      decorationName: map['decoration_name'] ?? 'Unknown',
      decorationType: map['decoration_type'] ?? 'Unknown',
      decorationRarity: map['decoration_rarity'] ?? 'Unknown',
      decorationSlot: map['decoration_slot'] ?? 'Unknown',
      decorationSkill: map['decoration_skill'] ?? 'Unknown',
      decorationDescription: map['decoration_description'] ?? 'Unknown',
      decorationMeldingCost: map['decoration_melding_cost'] ?? 'Unknown',
    );
  }
}
