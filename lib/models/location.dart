class MapData {
  final String? name;
  final int? zoneCount;
  final List<Camp>? camps;
  final int? id;
  final int? gameId;

  MapData({
    this.name,
    this.zoneCount,
    this.camps,
    this.id,
    this.gameId,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      name: json['name'] as String?,
      zoneCount: json['zoneCount'] as int?,
      camps: (json['camps'] as List<dynamic>?)
          ?.map((e) => Camp.fromJson(e))
          .toList(),
      id: json['id'] as int?,
      gameId: json['gameId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'zoneCount': zoneCount,
      'camps': camps?.map((e) => e.toJson()).toList(),
      'id': id,
      'gameId': gameId,
    };
  }
}

class Camp {
  final Location? location;
  final String? name;
  final int? zone;
  final int? floor;
  final String? risk;
  final Position? position;
  final int? id;
  final int? gameId;

  Camp({
    this.location,
    this.name,
    this.zone,
    this.floor,
    this.risk,
    this.position,
    this.id,
    this.gameId,
  });

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      name: json['name'] as String?,
      zone: json['zone'] as int?,
      floor: json['floor'] as int?,
      risk: json['risk'] as String?,
      position:
          json['position'] != null ? Position.fromJson(json['position']) : null,
      id: json['id'] as int?,
      gameId: json['gameId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'name': name,
      'zone': zone,
      'floor': floor,
      'risk': risk,
      'position': position?.toJson(),
      'id': id,
      'gameId': gameId,
    };
  }
}

class Location {
  final int? id;

  Location({this.id});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(id: json['id'] as int?);
  }

  Map<String, dynamic> toJson() => {'id': id};
}

class Position {
  final double? x;
  final double? y;
  final double? z;

  Position({this.x, this.y, this.z});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
      };
}
