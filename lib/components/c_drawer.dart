import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/screens/build_optimizer_screen.dart';
import 'package:mhwilds_app/utils/colors.dart';

class Cdrawer extends StatelessWidget {
  final Function(Widget) onItemSelected;
  final Widget selectedScreen;
  static final Color _selectedHighlightColor = Colors.orange[600]!;

  const Cdrawer({
    super.key,
    required this.onItemSelected,
    required this.selectedScreen,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
          ),
          child: Column(
            children: [
              menuHeader(context),
              Expanded(child: SingleChildScrollView(child: menuItems(context))),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.white : Colors.black87;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.goldSoft.withOpacity(0.92),
            AppColors.goldSoft.withOpacity(0.72),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.black : Colors.white).withOpacity(0.35),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.black : Colors.white).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: (isDark ? Colors.black : Colors.white).withOpacity(0.55),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/imgs/drawer/logo512.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 56,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            title: l10n.monsters,
            subtitle: l10n.menuMonstersSubtitle,
            leadingIcon: Image.asset(
              'assets/imgs/monster_icons/arkveld.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.pets,
                color: Colors.red[400],
                size: 30,
              ),
            ),
            icon: Icons.pets,
            iconColor: Colors.red[400]!,
            isSelected: selectedScreen is MonstersList,
            onTap: () => onItemSelected(const MonstersList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.items,
            subtitle: l10n.menuItemsSubtitle,
            leadingIcon: Image.asset(
              'assets/imgs/drawer/potion.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.inventory_2,
                color: Colors.orange[600],
                size: 30,
              ),
            ),
            icon: Icons.inventory_2,
            iconColor: Colors.orange[600]!,
            isSelected: selectedScreen is ItemList,
            onTap: () => onItemSelected(const ItemList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.decorations,
            subtitle: l10n.menuDecorationsSubtitle,
            leadingIcon: Image.asset(
              'assets/imgs/drawer/decoration.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.diamond,
                color: Colors.purple[400],
                size: 30,
              ),
            ),
            icon: Icons.diamond,
            iconColor: Colors.purple[400]!,
            isSelected: selectedScreen is DecorationsList,
            onTap: () => onItemSelected(const DecorationsList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.talismans,
            subtitle: l10n.menuTalismansSubtitle,
            leadingIcon: GearSpriteIcon(
              column: talismanColumn,
              rarity: 1,
              size: 30,
              fallback: Icon(
                Icons.workspace_premium,
                color: AppColors.goldSoft,
                size: 30,
              ),
            ),
            icon: Icons.workspace_premium,
            iconColor: AppColors.goldSoft,
            isSelected: selectedScreen is AmuletList,
            onTap: () => onItemSelected(const AmuletList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.armorSets,
            subtitle: l10n.menuArmorSetsSubtitle,
            leadingIcon: GearSpriteIcon(
              column: armorColumnByKind['head']!,
              rarity: 1,
              size: 30,
              fallback: Icon(
                Icons.shield,
                color: Colors.blue[600],
                size: 30,
              ),
            ),
            icon: Icons.shield,
            iconColor: Colors.blue[600]!,
            isSelected: selectedScreen is ArmorSetList,
            onTap: () => onItemSelected(const ArmorSetList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.weapons,
            subtitle: l10n.menuWeaponsSubtitle,
            leadingIcon: GearSpriteIcon(
              column: weaponColumnByKind['great-sword']!,
              rarity: 1,
              size: 30,
              fallback: Icon(
                Icons.gps_fixed,
                color: Colors.indigo[600],
                size: 30,
              ),
            ),
            icon: Icons.gps_fixed,
            iconColor: Colors.indigo[600]!,
            isSelected: selectedScreen is WeaponsList,
            onTap: () => onItemSelected(const WeaponsList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.skills,
            subtitle: l10n.menuSkillsSubtitle,
            leadingIcon: SkillSpriteIcon(
              iconId: 1,
              size: 30,
              fallback: Icon(
                Icons.flash_on,
                color: Colors.green[600],
                size: 30,
              ),
            ),
            icon: Icons.flash_on,
            iconColor: Colors.green[600]!,
            isSelected: selectedScreen is SkillList,
            onTap: () => onItemSelected(const SkillList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context: context,
            title: l10n.buildOptimizer,
            subtitle: l10n.buildOptimizerMenuSubtitle,
            leadingIcon: Icon(
              Icons.auto_graph,
              color: Colors.teal[600],
              size: 30,
            ),
            icon: Icons.auto_graph,
            iconColor: Colors.teal[600]!,
            isSelected: selectedScreen is BuildOptimizerScreen,
            onTap: () => onItemSelected(const BuildOptimizerScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isSelected,
    Widget? leadingIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? _selectedHighlightColor.withOpacity(0.12)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected
              ? _selectedHighlightColor.withOpacity(0.35)
              : colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono con fondo circular
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: leadingIcon ??
                        Icon(
                          icon,
                          color: iconColor,
                          size: 30,
                        ),
                  ),
                ),
                const SizedBox(width: 16),

                // Texto del menú
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Flecha de navegación
                Icon(
                  Icons.arrow_forward_ios,
                  color: isSelected
                      ? _selectedHighlightColor
                      : colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
