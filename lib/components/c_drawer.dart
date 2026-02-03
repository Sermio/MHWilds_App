import 'package:flutter/material.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/colors.dart';

class Cdrawer extends StatelessWidget {
  final Function(Widget) onItemSelected;

  const Cdrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.surfaceContainerHighest,
                colorScheme.surface,
              ],
            ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.goldSoft,
            AppColors.goldSoft.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldSoft.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/imgs/drawer/logo512.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'MHWilds Assistant',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            title: 'Monsters',
            subtitle: 'Database of all monsters',
            icon: Icons.pets,
            iconColor: Colors.red[400]!,
            onTap: () => onItemSelected(const MonstersList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Items',
            subtitle: 'Materials and resources',
            icon: Icons.inventory_2,
            iconColor: Colors.orange[600]!,
            onTap: () => onItemSelected(const ItemList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Decorations',
            subtitle: 'Skill gems and jewels',
            icon: Icons.diamond,
            iconColor: Colors.purple[400]!,
            onTap: () => onItemSelected(const DecorationsList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Talismans',
            subtitle: 'Powerful accessories',
            icon: Icons.workspace_premium,
            iconColor: AppColors.goldSoft,
            onTap: () => onItemSelected(const AmuletList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Armor Sets',
            subtitle: 'Complete armor collections',
            icon: Icons.shield,
            iconColor: Colors.blue[600]!,
            onTap: () => onItemSelected(const ArmorSetList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Weapons',
            subtitle: 'Combat weapons and tools',
            icon: Icons.gps_fixed,
            iconColor: Colors.indigo[600]!,
            onTap: () => onItemSelected(const WeaponsList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            context,
            title: 'Skills',
            subtitle: 'Combat abilities and effects',
            icon: Icons.flash_on,
            iconColor: Colors.green[600]!,
            onTap: () => onItemSelected(const SkillList()),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.outlineVariant,
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: iconColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
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
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: colorScheme.onSurface.withOpacity(0.5),
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
