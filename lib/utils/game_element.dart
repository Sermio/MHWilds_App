import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

/// Elementos y estados con icono propio en `assets/imgs/elements/`. La API no
/// los lista (`/ailments` devuelve `[]`), así que este es el único registro:
/// el nombre del valor es el id que usa la API y el nombre del archivo.
enum GameElement {
  fire(Icons.local_fire_department, isStatus: false),
  water(Icons.water_drop, isStatus: false),
  ice(Icons.ac_unit, isStatus: false),
  thunder(Icons.flash_on, isStatus: false),
  dragon(Icons.auto_awesome, isStatus: false),
  paralysis(Icons.electric_bolt),
  poison(Icons.warning),
  sleep(Icons.bedtime),
  blastblight(Icons.local_fire_department),
  // Estados de los monstruos; su nombre traducido llega con T38.
  blast(Icons.local_fire_department),
  fireblight(Icons.local_fire_department),
  waterblight(Icons.water_drop),
  iceblight(Icons.ac_unit),
  thunderblight(Icons.flash_on),
  dragonblight(Icons.auto_awesome),
  frostblight(Icons.ac_unit),
  webbed(Icons.star),
  bleeding(Icons.star),
  frenzy(Icons.star);

  const GameElement(this.icon, {this.isStatus = true});

  /// Icono de respaldo si falta la imagen.
  final IconData icon;
  final bool isStatus;

  String get id => name;
  String get asset => 'assets/imgs/elements/$name.webp';

  /// Los cinco elementos de daño y de resistencia de armaduras.
  static const elements = [fire, water, ice, thunder, dragon];

  /// Estados que pueden llevar las armas.
  static const weaponStatuses = [paralysis, poison, sleep, blastblight];

  /// `fromId('Fire')`, `fromId('blast-blight')`… Null si no hay icono.
  static GameElement? fromId(String? raw) {
    if (raw == null) return null;
    final id = raw.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
    for (final e in values) {
      if (e.name == id) return e;
    }
    return null;
  }

  /// Icono de respaldo para cualquier id (`Icons.star` si no es conocido).
  static IconData iconOf(String? raw) => fromId(raw)?.icon ?? Icons.star;

  /// Nombre traducido. Los estados de monstruo aún sin traducir caen al id.
  String label(AppLocalizations l10n) => switch (this) {
        fire => l10n.elementFire,
        water => l10n.elementWater,
        ice => l10n.elementIce,
        thunder => l10n.elementThunder,
        dragon => l10n.elementDragon,
        paralysis => l10n.elementParalysis,
        poison => l10n.elementPoison,
        sleep => l10n.elementSleep,
        blastblight => l10n.elementBlastblight,
        _ => _capitalize(name),
      };
}

/// Etiqueta de cualquier id de elemento, estado, vial o recubrimiento
/// (`'poison'` → traducido, `'close-range'` → `'Close range'`).
String gameElementLabel(AppLocalizations l10n, String id) =>
    GameElement.fromId(id)?.label(l10n) ??
    _capitalize(id.trim().replaceAll(RegExp(r'[-_]'), ' '));

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
