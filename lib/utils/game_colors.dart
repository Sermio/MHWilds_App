import 'package:flutter/material.dart';

/// Colores con significado del juego (elementos, rarezas, afilado, zonas…),
/// con variante clara y oscura. Léelos con `GameColors.of(context)`.
///
/// La variante clara conserva los valores históricos. En oscuro solo cambian
/// los que no alcanzaban el contraste mínimo sobre la superficie `#121212`.
@immutable
class GameColors extends ThemeExtension<GameColors> {
  const GameColors({
    required this.elements,
    required this.coatings,
    required this.kinds,
    required this.rarities,
    required this.sharpnessRed,
    required this.sharpnessOrange,
    required this.sharpnessYellow,
    required this.sharpnessGreen,
    required this.sharpnessBlue,
    required this.sharpnessWhite,
    required this.sharpnessPurple,
    required this.zones,
    required this.neutral,
  });

  /// Elementos y estados (`fire`, `poison`…), en minúsculas.
  final Map<String, Color> elements;

  /// Revestimientos del arco (`power`, `close-range`…) y los que comparten
  /// nombre con un estado.
  final Map<String, Color> coatings;

  /// Tipos de arma (`great-sword`…) y piezas de armadura (`head`…).
  final Map<String, Color> kinds;

  /// Rareza 0..12, muestreada de la hoja de sprites.
  final List<Color> rarities;

  final Color sharpnessRed;
  final Color sharpnessOrange;
  final Color sharpnessYellow;
  final Color sharpnessGreen;
  final Color sharpnessBlue;
  final Color sharpnessWhite;
  final Color sharpnessPurple;

  /// Fondo por id de zona (1..5).
  final Map<int, Color> zones;

  /// Color de reserva para claves desconocidas.
  final Color neutral;

  static const Color _zoneDefault = Colors.white;

  static final GameColors light = GameColors(
    elements: {
      'fire': Colors.red[600]!,
      'water': Colors.blue[600]!,
      'thunder': Colors.yellow[600]!,
      'ice': Colors.cyan[600]!,
      'dragon': Colors.purple[600]!,
      'poison': Colors.green[600]!,
      'paralysis': Colors.amber[600]!,
      'sleep': Colors.indigo[600]!,
      'blast': Colors.orange[600]!,
      'exhaust': Colors.grey[600]!,
    },
    coatings: {
      'power': Colors.red[600]!,
      'paralysis': Colors.amber[600]!,
      'poison': Colors.green[600]!,
      'sleep': Colors.indigo[600]!,
      'blast': Colors.orange[600]!,
      'exhaust': Colors.grey[600]!,
      'close-range': Colors.blue[600]!,
      'pierce': Colors.purple[600]!,
    },
    kinds: _kinds,
    rarities: _rarities,
    sharpnessRed: Colors.red[400]!,
    sharpnessOrange: Colors.orange[400]!,
    sharpnessYellow: Colors.yellow[600]!,
    sharpnessGreen: Colors.green[400]!,
    sharpnessBlue: Colors.blue[400]!,
    sharpnessWhite: Colors.white,
    sharpnessPurple: Colors.purple[400]!,
    zones: _zones,
    neutral: Colors.grey[600]!,
  );

  static final GameColors dark = GameColors(
    // Los tonos 600 no llegan a 4,5:1 sobre #121212; se usa el 400.
    elements: {
      'fire': Colors.red[400]!,
      'water': Colors.blue[400]!,
      'thunder': Colors.yellow[600]!,
      'ice': Colors.cyan[400]!,
      'dragon': Colors.purple[300]!,
      'poison': Colors.green[400]!,
      'paralysis': Colors.amber[600]!,
      'sleep': Colors.indigo[300]!,
      'blast': Colors.orange[600]!,
      'exhaust': Colors.grey[400]!,
    },
    coatings: {
      'power': Colors.red[400]!,
      'paralysis': Colors.amber[600]!,
      'poison': Colors.green[400]!,
      'sleep': Colors.indigo[300]!,
      'blast': Colors.orange[600]!,
      'exhaust': Colors.grey[400]!,
      'close-range': Colors.blue[400]!,
      'pierce': Colors.purple[300]!,
    },
    kinds: _kinds,
    rarities: [
      for (final c in _rarities) _liftToContrast(c, const Color(0xFF121212)),
    ],
    sharpnessRed: Colors.red[400]!,
    sharpnessOrange: Colors.orange[400]!,
    sharpnessYellow: Colors.yellow[600]!,
    sharpnessGreen: Colors.green[400]!,
    sharpnessBlue: Colors.blue[400]!,
    sharpnessWhite: Colors.white,
    sharpnessPurple: Colors.purple[400]!,
    zones: _zones,
    neutral: Colors.grey[400]!,
  );

  static final Map<String, Color> _kinds = {
    'great-sword': Colors.red[400]!,
    'long-sword': Colors.orange[400]!,
    'sword-shield': Colors.blue[400]!,
    'dual-blades': Colors.purple[400]!,
    'hammer': Colors.brown[400]!,
    'hunting-horn': Colors.green[400]!,
    'lance': Colors.indigo[400]!,
    'gunlance': Colors.teal[400]!,
    'switch-axe': Colors.deepOrange[400]!,
    'charge-blade': Colors.cyan[400]!,
    'insect-glaive': Colors.lime[400]!,
    'bow': Colors.amber[400]!,
    'light-bowgun': Colors.pink[400]!,
    'heavy-bowgun': Colors.deepPurple[400]!,
    'head': Colors.red[400]!,
    'chest': Colors.blue[400]!,
    'arms': Colors.green[400]!,
    'waist': Colors.orange[400]!,
    'legs': Colors.purple[400]!,
  };

  // Muestreada de cada fila de la hoja de sprites (rareza 0..12).
  static const List<Color> _rarities = [
    Color(0xFF747474),
    Color(0xFF8A918C),
    Color(0xFFB1ADA7),
    Color(0xFF8EA01F),
    Color(0xFF33943F),
    Color(0xFF429290),
    Color(0xFF3F49AF),
    Color(0xFF7945B9),
    Color(0xFFA15332),
    Color(0xFF98304C),
    Color(0xFF069AC1),
    Color(0xFFC19413),
    Color(0xFF87B2C4),
  ];

  // 1 Oilwell Basin, 2 Windward Plains, 3 Scarlet Forest, 4 Ruins of Wyveria,
  // 5 Iceshard Cliffs.
  static final Map<int, Color> _zones = {
    1: const Color.fromARGB(242, 142, 141, 141),
    2: const Color.fromARGB(255, 249, 207, 37),
    3: Colors.green.shade700,
    4: const Color.fromARGB(221, 141, 110, 99),
    5: const Color.fromARGB(167, 1, 150, 170),
  };

  /// Aclara [color] mezclándolo con blanco hasta alcanzar 4,5:1 sobre
  /// [background]; si ya lo cumple, lo devuelve tal cual.
  static Color _liftToContrast(Color color, Color background) {
    var c = color;
    for (var i = 0; i < 20 && _contrast(c, background) < 4.5; i++) {
      c = Color.lerp(c, Colors.white, 0.1)!;
    }
    return c;
  }

  static double _contrast(Color a, Color b) {
    final la = a.computeLuminance(), lb = b.computeLuminance();
    return (la > lb ? la + 0.05 : lb + 0.05) /
        (la > lb ? lb + 0.05 : la + 0.05);
  }

  /// Extensión del tema actual; la clara si el tema no la registra (tests con
  /// un `MaterialApp` sin tema de la app).
  static GameColors of(BuildContext context) =>
      Theme.of(context).extension<GameColors>() ?? light;

  Color element(String name) => elementOrNull(name) ?? neutral;

  /// Color de un elemento o estado, o null si no tiene. Acepta las variantes
  /// de la API (`blastblight`, `paralyze`, `Fire`…).
  Color? elementOrNull(String name) {
    final id = name.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    return elements[switch (id) {
      'paralyze' => 'paralysis',
      'blastblight' => 'blast',
      _ => id,
    }];
  }

  Color coating(String name) => coatings[name.toLowerCase()] ?? neutral;

  Color kind(String name) => kinds[name] ?? Colors.grey[400]!;

  Color rarity(int rarity) => rarities[rarity.clamp(0, rarities.length - 1)];

  Color zone(int mapId) => zones[mapId] ?? _zoneDefault;

  @override
  GameColors copyWith({Map<String, Color>? elements}) => GameColors(
        elements: elements ?? this.elements,
        coatings: coatings,
        kinds: kinds,
        rarities: rarities,
        sharpnessRed: sharpnessRed,
        sharpnessOrange: sharpnessOrange,
        sharpnessYellow: sharpnessYellow,
        sharpnessGreen: sharpnessGreen,
        sharpnessBlue: sharpnessBlue,
        sharpnessWhite: sharpnessWhite,
        sharpnessPurple: sharpnessPurple,
        zones: zones,
        neutral: neutral,
      );

  /// Los colores del juego no se interpolan: el cambio de tema los sustituye.
  @override
  GameColors lerp(GameColors? other, double t) =>
      t < 0.5 ? this : other ?? this;
}
