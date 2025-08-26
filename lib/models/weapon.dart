import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/models/armor_piece.dart';

class Weapon {
  final int id;
  final int gameId;
  final String name;
  final String description;
  final String kind;
  final int rarity;
  final Damage damage;
  final List<WeaponSkill> skills;
  final List<int> slots;
  final int defenseBonus;
  final String? elderseal;
  final int affinity;
  final Sharpness sharpness;
  final List<int> handicraft;
  final dynamic specials; // Cambiado a dynamic para manejar diferentes tipos
  final WeaponCrafting crafting;

  // Nuevos campos opcionales para estructuras especiales
  final HuntingHornMelody? melody;
  final List<BowgunAmmo>? ammo;
  final String? shell;
  final int? shellLevel;
  final SwitchAxePhial? phial; // Cambiado a SwitchAxePhial para switch-axe
  final List<String>? coatings;
  final int? kinsectLevel;
  final HuntingHornBubble? echoBubble;
  final HuntingHornWave? echoWave;
  final Sharpness? specialSharpness; // Sharpness adicional en specials
  final List<int>? specialHandicraft; // Handicraft adicional en specials

  Weapon({
    required this.id,
    required this.gameId,
    required this.name,
    required this.description,
    required this.kind,
    required this.rarity,
    required this.damage,
    required this.skills,
    required this.slots,
    required this.defenseBonus,
    this.elderseal,
    required this.affinity,
    required this.sharpness,
    required this.handicraft,
    required this.specials,
    required this.crafting,
    // Nuevos campos opcionales
    this.melody,
    this.ammo,
    this.shell,
    this.shellLevel,
    this.phial,
    this.coatings,
    this.kinsectLevel,
    this.echoBubble,
    this.echoWave,
    this.specialSharpness,
    this.specialHandicraft,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    try {
      // Parse damage with error handling
      Damage damage;
      try {
        damage = Damage.fromJson(json['damage'] ?? {});
      } catch (e) {
        print('Error parsing damage: $e');
        damage = Damage(raw: 0, display: 0);
      }

      // Parse skills with error handling
      List<WeaponSkill> skills = [];
      try {
        skills = (json['skills'] as List? ?? [])
            .map((skillJson) => WeaponSkill.fromJson(skillJson))
            .toList();
      } catch (e) {
        print('Error parsing skills: $e');
        skills = [];
      }

      // Parse sharpness with error handling
      Sharpness sharpness;
      try {
        sharpness = Sharpness.fromJson(json['sharpness'] ?? {});
      } catch (e) {
        print('Error parsing sharpness: $e');
        sharpness = Sharpness(
            red: 0,
            orange: 0,
            yellow: 0,
            green: 0,
            blue: 0,
            white: 0,
            purple: 0);
      }

      // Parse crafting with error handling
      WeaponCrafting crafting;
      try {
        crafting = WeaponCrafting.fromJson(json['crafting'] ?? {});
      } catch (e) {
        print('Error parsing crafting: $e');
        crafting = WeaponCrafting(
          weapon: WeaponReference(name: '', id: 0),
          craftable: false,
          branches: [],
          craftingMaterials: [],
          craftingZennyCost: 0,
          upgradeMaterials: [],
          upgradeZennyCost: 0,
          id: 0,
        );
      }

      final weapon = Weapon(
        id: json['id'] as int? ?? 0,
        gameId: json['gameId'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        kind: json['kind'] as String? ?? '',
        rarity: json['rarity'] as int? ?? 0,
        damage: damage,
        skills: skills,
        slots: (json['slots'] as List? ?? []).map((e) => e as int).toList(),
        defenseBonus: json['defenseBonus'] as int? ?? 0,
        elderseal: json['elderseal'] as String?,
        affinity: json['affinity'] as int? ?? 0,
        sharpness: sharpness,
        handicraft:
            (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
        specials: _parseSpecials(json['specials'], json['kind']),
        crafting: crafting,
        // Nuevos campos opcionales con manejo robusto de errores
        melody: _safeParseMelody(json['melody']),
        ammo: _safeParseAmmo(json['ammo']),
        shell: json['shell'] as String?,
        shellLevel: json['shellLevel'] as int?,
        phial: _safeParsePhial(json['phial']),
        coatings: json['coatings'] != null
            ? (json['coatings'] as List? ?? []).cast<String>()
            : null,
        kinsectLevel: json['kinsectLevel'] as int?,
        echoBubble: _safeParseEchoBubble(json['echoBubble']),
        echoWave: _safeParseEchoWave(json['echoWave']),
        specialSharpness: json['sharpness'] != null
            ? Sharpness.fromJson(json['sharpness'])
            : null,
        specialHandicraft: json['handicraft'] != null
            ? (json['handicraft'] as List? ?? []).map((e) => e as int).toList()
            : null,
      );

      return weapon;
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  // Métodos auxiliares para parsing seguro
  static HuntingHornMelody? _safeParseMelody(dynamic melodyData) {
    try {
      if (melodyData == null) return null;
      if (melodyData is Map<String, dynamic>) {
        return HuntingHornMelody.fromJson(melodyData);
      }
      return null;
    } catch (e) {
      print('Error parsing melody: $e');
      return null;
    }
  }

  static List<BowgunAmmo>? _safeParseAmmo(dynamic ammoData) {
    try {
      if (ammoData == null) return null;
      if (ammoData is List) {
        return ammoData
            .map((ammoJson) {
              try {
                return BowgunAmmo.fromJson(ammoJson);
              } catch (e) {
                print('Error parsing individual ammo: $e');
                return null;
              }
            })
            .whereType<BowgunAmmo>()
            .toList();
      }
      return null;
    } catch (e) {
      print('Error parsing ammo list: $e');
      return null;
    }
  }

  static HuntingHornBubble? _safeParseEchoBubble(dynamic bubbleData) {
    try {
      if (bubbleData == null) return null;
      if (bubbleData is Map<String, dynamic>) {
        return HuntingHornBubble.fromJson(bubbleData);
      }
      return null;
    } catch (e) {
      print('Error parsing echo bubble: $e');
      return null;
    }
  }

  static HuntingHornWave? _safeParseEchoWave(dynamic waveData) {
    try {
      if (waveData == null) return null;
      if (waveData is Map<String, dynamic>) {
        return HuntingHornWave.fromJson(waveData);
      }
      return null;
    } catch (e) {
      print('Error parsing echo wave: $e');
      return null;
    }
  }

  static SwitchAxePhial? _safeParsePhial(dynamic phialData) {
    try {
      if (phialData == null) return null;
      if (phialData is Map<String, dynamic>) {
        return SwitchAxePhial.fromJson(phialData);
      }
      return null;
    } catch (e) {
      print('Error parsing phial: $e');
      return null;
    }
  }

  // Método auxiliar para parsear specials según el tipo de arma
  static dynamic _parseSpecials(dynamic specialsData, String weaponKind) {
    try {
      if (specialsData == null) return null;

      // Si specialsData es una lista, verificar si contiene daño elemental o de status
      if (specialsData is List) {
        // Verificar si hay algún special con daño elemental o de status
        final hasElementalOrStatusDamage = specialsData.any((special) {
          if (special is Map<String, dynamic>) {
            final kind = special['kind'];
            final damage = special['damage'];
            final element = special['element'];
            final status = special['status'];

            return (kind == 'element' || kind == 'status') &&
                damage != null &&
                damage['raw'] > 0;
          }
          return false;
        });

        // También buscar phial damage si existe
        final hasPhialDamage = specialsData.any((special) {
          if (special is Map<String, dynamic>) {
            return special['phial'] != null &&
                special['phial']['damage'] != null &&
                special['phial']['damage']['raw'] > 0;
          }
          return false;
        });

        // Si tiene daño elemental/status o phial, retornar la lista original para parsing manual
        if (hasElementalOrStatusDamage || hasPhialDamage) {
          return specialsData;
        }
      }

      return specialsData;
    } catch (e) {
      // En caso de error, retornar los datos originales para parsing manual
      return specialsData;
    }
  }
}

// Modelos específicos para cada tipo de arma

class BowSpecials {
  final List<String> coatings;
  final Sharpness? sharpness;
  final List<int> handicraft;

  BowSpecials({
    required this.coatings,
    this.sharpness,
    this.handicraft = const [],
  });

  factory BowSpecials.fromJson(Map<String, dynamic> json) {
    return BowSpecials(
      coatings: (json['coatings'] as List? ?? []).cast<String>(),
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class ChargeBladeSpecials {
  final String phial;
  final Sharpness? sharpness;
  final List<int> handicraft;

  ChargeBladeSpecials({
    required this.phial,
    this.sharpness,
    this.handicraft = const [],
  });

  factory ChargeBladeSpecials.fromJson(Map<String, dynamic> json) {
    return ChargeBladeSpecials(
      phial: json['phial'] as String? ?? 'unknown',
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class GunlanceSpecials {
  final String shell;
  final int shellLevel;
  final Sharpness? sharpness;
  final List<int> handicraft;

  GunlanceSpecials({
    required this.shell,
    required this.shellLevel,
    this.sharpness,
    this.handicraft = const [],
  });

  factory GunlanceSpecials.fromJson(Map<String, dynamic> json) {
    return GunlanceSpecials(
      shell: json['shell'] as String? ?? 'unknown',
      shellLevel: json['shellLevel'] as int? ?? 0,
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class HeavyBowgunSpecials {
  final List<BowgunAmmo> ammo;
  final Sharpness? sharpness;
  final List<int> handicraft;

  HeavyBowgunSpecials({
    required this.ammo,
    this.sharpness,
    this.handicraft = const [],
  });

  factory HeavyBowgunSpecials.fromJson(Map<String, dynamic> json) {
    return HeavyBowgunSpecials(
      ammo: (json['ammo'] as List? ?? [])
          .map((ammoJson) => BowgunAmmo.fromJson(ammoJson))
          .toList(),
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class LightBowgunSpecials {
  final List<BowgunAmmo> ammo;
  final String specialAmmo;
  final Sharpness? sharpness;
  final List<int> handicraft;

  LightBowgunSpecials({
    required this.ammo,
    required this.specialAmmo,
    this.sharpness,
    this.handicraft = const [],
  });

  factory LightBowgunSpecials.fromJson(Map<String, dynamic> json) {
    return LightBowgunSpecials(
      ammo: (json['ammo'] as List? ?? [])
          .map((ammoJson) => BowgunAmmo.fromJson(ammoJson))
          .toList(),
      specialAmmo: json['specialAmmo'] as String? ?? 'unknown',
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class BowgunAmmo {
  final String kind;
  final int level;
  final int capacity;
  final bool? rapid; // Solo para Light Bowgun
  final int id;

  BowgunAmmo({
    required this.kind,
    required this.level,
    required this.capacity,
    this.rapid,
    required this.id,
  });

  factory BowgunAmmo.fromJson(Map<String, dynamic> json) {
    return BowgunAmmo(
      kind: json['kind'] as String? ?? 'unknown',
      level: json['level'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      rapid: json['rapid'] as bool?,
      id: json['id'] as int? ?? 0,
    );
  }
}

class HuntingHornSpecials {
  final HuntingHornMelody? melody;
  final HuntingHornBubble? echoBubble;
  final HuntingHornWave? echoWave;
  final Sharpness? sharpness;
  final List<int> handicraft;

  HuntingHornSpecials({
    this.melody,
    this.echoBubble,
    this.echoWave,
    this.sharpness,
    this.handicraft = const [],
  });

  factory HuntingHornSpecials.fromJson(Map<String, dynamic> json) {
    return HuntingHornSpecials(
      melody: json['melody'] != null
          ? HuntingHornMelody.fromJson(json['melody'])
          : null,
      echoBubble: json['echoBubble'] != null
          ? HuntingHornBubble.fromJson(json['echoBubble'])
          : null,
      echoWave: json['echoWave'] != null
          ? HuntingHornWave.fromJson(json['echoWave'])
          : null,
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class HuntingHornMelody {
  final int id;
  final int gameId;
  final List<String> notes;
  final List<HuntingHornSong> songs;

  HuntingHornMelody({
    required this.id,
    required this.gameId,
    required this.notes,
    required this.songs,
  });

  factory HuntingHornMelody.fromJson(Map<String, dynamic> json) {
    return HuntingHornMelody(
      id: json['id'] as int? ?? 0,
      gameId: json['gameId'] as int? ?? 0,
      notes: (json['notes'] as List? ?? []).cast<String>(),
      songs: (json['songs'] as List? ?? [])
          .map((songJson) => HuntingHornSong.fromJson(songJson))
          .toList(),
    );
  }
}

class HuntingHornSong {
  final int effectId;
  final List<String> sequence;
  final String name;
  final int id;

  HuntingHornSong({
    required this.effectId,
    required this.sequence,
    required this.name,
    required this.id,
  });

  factory HuntingHornSong.fromJson(Map<String, dynamic> json) {
    return HuntingHornSong(
      effectId: json['effectId'] as int? ?? 0,
      sequence: (json['sequence'] as List? ?? []).cast<String>(),
      name: json['name'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}

class HuntingHornBubble {
  final int id;
  final int gameId;
  final String kind;
  final String name;

  HuntingHornBubble({
    required this.id,
    required this.gameId,
    required this.kind,
    required this.name,
  });

  factory HuntingHornBubble.fromJson(Map<String, dynamic> json) {
    return HuntingHornBubble(
      id: json['id'] as int? ?? 0,
      gameId: json['gameId'] as int? ?? 0,
      kind: json['kind'] as String? ?? 'unknown',
      name: json['name'] as String? ?? '',
    );
  }
}

class HuntingHornWave {
  final int id;
  final int gameId;
  final String kind;
  final String name;

  HuntingHornWave({
    required this.id,
    required this.gameId,
    required this.kind,
    required this.name,
  });

  factory HuntingHornWave.fromJson(Map<String, dynamic> json) {
    return HuntingHornWave(
      id: json['id'] as int? ?? 0,
      gameId: json['gameId'] as int? ?? 0,
      kind: json['kind'] as String? ?? 'unknown',
      name: json['name'] as String? ?? '',
    );
  }
}

class InsectGlaiveSpecials {
  final int kinsectLevel;
  final Sharpness? sharpness;
  final List<int> handicraft;

  InsectGlaiveSpecials({
    required this.kinsectLevel,
    this.sharpness,
    this.handicraft = const [],
  });

  factory InsectGlaiveSpecials.fromJson(Map<String, dynamic> json) {
    return InsectGlaiveSpecials(
      kinsectLevel: json['kinsectLevel'] as int? ?? 0,
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class SwitchAxeSpecials {
  final SwitchAxePhial phial;
  final Sharpness? sharpness;
  final List<int> handicraft;

  SwitchAxeSpecials({
    required this.phial,
    this.sharpness,
    this.handicraft = const [],
  });

  factory SwitchAxeSpecials.fromJson(Map<String, dynamic> json) {
    return SwitchAxeSpecials(
      phial: SwitchAxePhial.fromJson(json['phial'] ?? {}),
      sharpness: json['sharpness'] != null
          ? Sharpness.fromJson(json['sharpness'])
          : null,
      handicraft:
          (json['handicraft'] as List? ?? []).map((e) => e as int).toList(),
    );
  }
}

class SwitchAxePhial {
  final String kind;
  final Damage? damage; // Opcional porque no todas las weapons lo tienen

  SwitchAxePhial({required this.kind, this.damage});

  factory SwitchAxePhial.fromJson(Map<String, dynamic> json) {
    return SwitchAxePhial(
      kind: json['kind'] as String? ?? 'unknown',
      damage: json['damage'] != null ? Damage.fromJson(json['damage']) : null,
    );
  }
}

class WeaponSpecial {
  final int id;
  final String element;
  final String kind;
  final Damage damage;
  final bool hidden;

  WeaponSpecial({
    required this.id,
    required this.element,
    required this.kind,
    required this.damage,
    required this.hidden,
  });

  factory WeaponSpecial.fromJson(Map<String, dynamic> json) {
    try {
      return WeaponSpecial(
        id: json['id'] as int? ?? 0,
        element: json['element'] as String? ?? '',
        kind: json['kind'] as String? ?? '',
        damage: Damage.fromJson(json['damage'] ?? {}),
        hidden: json['hidden'] as bool? ?? false,
      );
    } catch (e) {
      print('Error parsing WeaponSpecial: $e');
      return WeaponSpecial(
        id: 0,
        element: 'unknown',
        kind: 'unknown',
        damage: Damage(raw: 0, display: 0),
        hidden: false,
      );
    }
  }

  // Método para obtener el nombre legible del special
  String get displayName {
    if (element.isNotEmpty && element != 'unknown') {
      return element[0].toUpperCase() + element.substring(1);
    }
    return kind[0].toUpperCase() + kind.substring(1);
  }

  // Método para obtener la descripción del special
  String get description {
    if (damage.raw > 0) {
      return '${damage.display} ${element} damage';
    }
    return element.isNotEmpty ? element : kind;
  }
}

class Damage {
  final int raw;
  final int display;

  Damage({
    required this.raw,
    required this.display,
  });

  factory Damage.fromJson(Map<String, dynamic> json) {
    return Damage(
      raw: json['raw'] as int? ?? 0,
      display: json['display'] as int? ?? 0,
    );
  }
}

class WeaponSkill {
  final Skills skill;
  final int level;
  final String description;
  final int id;

  WeaponSkill({
    required this.skill,
    required this.level,
    required this.description,
    required this.id,
  });

  factory WeaponSkill.fromJson(Map<String, dynamic> json) {
    return WeaponSkill(
      skill: Skills.fromJson(json['skill'] ?? {}),
      level: json['level'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}

class Sharpness {
  final int red;
  final int orange;
  final int yellow;
  final int green;
  final int blue;
  final int white;
  final int purple;

  Sharpness({
    required this.red,
    required this.orange,
    required this.yellow,
    required this.green,
    required this.blue,
    required this.white,
    required this.purple,
  });

  factory Sharpness.fromJson(Map<String, dynamic> json) {
    return Sharpness(
      red: json['red'] as int? ?? 0,
      orange: json['orange'] as int? ?? 0,
      yellow: json['yellow'] as int? ?? 0,
      green: json['green'] as int? ?? 0,
      blue: json['blue'] as int? ?? 0,
      white: json['white'] as int? ?? 0,
      purple: json['purple'] as int? ?? 0,
    );
  }
}

class WeaponCrafting {
  final WeaponReference weapon;
  final bool craftable;
  final WeaponReference? previous;
  final List<WeaponReference> branches;
  final List<Material> craftingMaterials;
  final int craftingZennyCost;
  final List<Material> upgradeMaterials;
  final int upgradeZennyCost;
  final int id;

  WeaponCrafting({
    required this.weapon,
    required this.craftable,
    this.previous,
    required this.branches,
    required this.craftingMaterials,
    required this.craftingZennyCost,
    required this.upgradeMaterials,
    required this.upgradeZennyCost,
    required this.id,
  });

  factory WeaponCrafting.fromJson(Map<String, dynamic> json) {
    return WeaponCrafting(
      weapon: WeaponReference.fromJson(json['weapon'] ?? {}),
      craftable: json['craftable'] as bool? ?? false,
      previous: json['previous'] != null
          ? WeaponReference.fromJson(json['previous'])
          : null,
      branches: (json['branches'] as List? ?? [])
          .map((branchJson) => WeaponReference.fromJson(branchJson))
          .toList(),
      craftingMaterials: (json['craftingMaterials'] as List? ?? [])
          .map((materialJson) => Material.fromJson(materialJson))
          .toList(),
      craftingZennyCost: json['craftingZennyCost'] as int? ?? 0,
      upgradeMaterials: (json['upgradeMaterials'] as List? ?? [])
          .map((materialJson) => Material.fromJson(materialJson))
          .toList(),
      upgradeZennyCost: json['upgradeZennyCost'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
    );
  }
}

class WeaponReference {
  final String name;
  final int id;

  WeaponReference({
    required this.name,
    required this.id,
  });

  factory WeaponReference.fromJson(Map<String, dynamic> json) {
    return WeaponReference(
      name: json['name'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}
