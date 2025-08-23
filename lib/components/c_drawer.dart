import 'package:flutter/material.dart';
import 'package:mhwilds_app/screens/amulets_list.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/utils/colors.dart';

class Cdrawer extends StatelessWidget {
  final Function(Widget) onItemSelected;

  const Cdrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            menuHeader(),
            Expanded(child: SingleChildScrollView(child: menuItems())),
          ],
        ),
      ),
    );
  }

  Widget menuHeader() {
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
              // Logo principal
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
              const Text(
                'MHWilds Assistant',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItems() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildMenuItem(
            title: 'Monsters',
            subtitle: 'Database of all monsters',
            icon: Icons.pets,
            iconColor: Colors.red[400]!,
            onTap: () => onItemSelected(const MonstersList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            title: 'Items',
            subtitle: 'Materials and resources',
            icon: Icons.inventory_2,
            iconColor: Colors.orange[600]!,
            onTap: () => onItemSelected(const ItemList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            title: 'Decorations',
            subtitle: 'Skill gems and jewels',
            icon: Icons.diamond,
            iconColor: Colors.purple[400]!,
            onTap: () => onItemSelected(const DecorationsList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            title: 'Amulets',
            subtitle: 'Powerful accessories',
            icon: Icons.workspace_premium,
            iconColor: AppColors.goldSoft,
            onTap: () => onItemSelected(const AmuletList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            title: 'Armor Sets',
            subtitle: 'Complete armor collections',
            icon: Icons.shield,
            iconColor: Colors.blue[600]!,
            onTap: () => onItemSelected(const ArmorSetList()),
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
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

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
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

                // Texto del menú
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Flecha de navegación
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
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
