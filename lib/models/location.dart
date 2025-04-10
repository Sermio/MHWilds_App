class Zone {
  final int id;
  final int zoneCount;
  final String name;
  final List<Camp> camps;

  Zone({
    required this.id,
    required this.zoneCount,
    required this.name,
    required this.camps,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] ?? 0,
      zoneCount: json['zoneCount'] ?? 0,
      name: json['name'] ?? '',
      camps: json['camps'] != null
          ? (json['camps'] as List).map((camp) => Camp.fromJson(camp)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zoneCount': zoneCount,
      'name': name,
      'camps': camps.map((camp) => camp.toJson()).toList(),
    };
  }
}

class Camp {
  final int id;
  final int zone;
  final String name;

  Camp({
    required this.id,
    required this.zone,
    required this.name,
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      id: json['id'] ?? 0,
      zone: json['zone'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'zone': zone,
      'name': name,
    };
  }
}
