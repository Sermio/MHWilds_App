import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/build_crafter_screen.dart';
import 'package:mhwilds_app/screens/build_optimizer_screen.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/maps_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/settings.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/colors.dart';

/// Secciones de la app, en el orden del menú lateral. Es la única fuente de
/// título, pantalla, icono y acciones de la AppBar: `HomeScreen` y `Cdrawer`
/// solo la recorren.
enum AppSection {
  monsters,
  weapons,
  armorSets,
  decorations,
  talismans,
  skills,
  items,
  locations,
  buildCrafter,
  buildOptimizer,
}

extension AppSectionView on AppSection {
  String title(AppLocalizations l10n) => switch (this) {
        AppSection.monsters => l10n.monsters,
        AppSection.weapons => l10n.weapons,
        AppSection.armorSets => l10n.armorSets,
        AppSection.decorations => l10n.decorations,
        AppSection.talismans => l10n.talismans,
        AppSection.skills => l10n.skills,
        AppSection.items => l10n.items,
        AppSection.locations => l10n.maps,
        AppSection.buildCrafter => l10n.buildCrafter,
        AppSection.buildOptimizer => l10n.buildOptimizer,
      };

  Widget get screen => switch (this) {
        AppSection.monsters => const MonstersList(),
        AppSection.weapons => const WeaponsList(),
        AppSection.armorSets => const ArmorSetList(),
        AppSection.decorations => const DecorationsList(),
        AppSection.talismans => const AmuletList(),
        AppSection.skills => const SkillList(),
        AppSection.items => const ItemList(),
        AppSection.locations => const MapsList(),
        AppSection.buildCrafter => const BuildCrafterScreen(),
        AppSection.buildOptimizer => const BuildOptimizerScreen(),
      };

  IconData get icon => switch (this) {
        AppSection.monsters => Icons.pets,
        AppSection.weapons => Icons.gps_fixed,
        AppSection.armorSets => Icons.shield,
        AppSection.decorations => Icons.diamond,
        AppSection.talismans => Icons.workspace_premium,
        AppSection.skills => Icons.flash_on,
        AppSection.items => Icons.inventory_2,
        AppSection.locations => Icons.map,
        AppSection.buildCrafter => Icons.handyman,
        AppSection.buildOptimizer => Icons.auto_graph,
      };

  Color iconColor(BuildContext context) => switch (this) {
        AppSection.monsters => Colors.red[400]!,
        AppSection.weapons => Colors.indigo[600]!,
        AppSection.armorSets => Colors.blue[600]!,
        AppSection.decorations => Colors.purple[400]!,
        AppSection.talismans => AppColors.goldAccent(context),
        AppSection.skills => Colors.green[600]!,
        AppSection.items => Colors.orange[600]!,
        AppSection.locations => Colors.blue[400]!,
        AppSection.buildCrafter => Colors.deepPurple.shade400,
        AppSection.buildOptimizer => Colors.teal[600]!,
      };

  /// Icono del menú: el del juego si hay, con [icon] como respaldo.
  Widget menuLeading(BuildContext context) {
    final color = iconColor(context);
    final fallback = Icon(icon, color: color, size: 30);
    Widget asset(String path) => Image.asset(path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => fallback,
        excludeFromSemantics: true);
    return switch (this) {
      AppSection.monsters => asset('assets/imgs/monster_icons/arkveld.webp'),
      AppSection.weapons => GearSpriteIcon(
          column: weaponColumnByKind['great-sword']!,
          rarity: 1,
          size: 30,
          fallback: fallback),
      AppSection.armorSets => GearSpriteIcon(
          column: armorColumnByKind['head']!,
          rarity: 1,
          size: 30,
          fallback: fallback),
      AppSection.decorations => asset('assets/imgs/drawer/decoration.png'),
      AppSection.talismans => GearSpriteIcon(
          column: talismanColumn, rarity: 1, size: 30, fallback: fallback),
      AppSection.skills =>
        SkillSpriteIcon(iconId: 1, size: 30, fallback: fallback),
      AppSection.items => asset('assets/imgs/drawer/potion.png'),
      AppSection.locations => asset('assets/imgs/drawer/camp.webp'),
      AppSection.buildCrafter || AppSection.buildOptimizer => fallback,
    };
  }

  /// Acciones de la AppBar; null usa las de `Cappbar` (solo Ajustes).
  List<Widget>? appBarActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final credits = switch (this) {
      AppSection.buildCrafter => showBuildCrafterCreditsDialog,
      AppSection.buildOptimizer => showBuildOptimizerCreditsDialog,
      _ => null,
    };
    if (credits == null) return null;
    return [
      IconButton(
        tooltip: l10n.creditsTooltip,
        icon: const Icon(Icons.help_outline),
        onPressed: () => credits(context),
      ),
      IconButton(
        tooltip: l10n.settings,
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
    ];
  }
}
