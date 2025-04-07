import 'package:flutter/material.dart';
import 'package:mhwilds_app/screens/amulets_list.dart';
import 'package:mhwilds_app/screens/armor_pieces_list.dart';
import 'package:mhwilds_app/screens/armor_pieces_list2.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/decorations_list2.dart';
import 'package:mhwilds_app/screens/materials_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/skills_list2.dart';

class Cdrawer extends StatelessWidget {
  final Function(Widget) onItemSelected;

  const Cdrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          menuHeader(),
          Expanded(child: SingleChildScrollView(child: menuItems())),
        ],
      ),
    );
  }

  Widget menuHeader() {
    return Image.asset(
      'assets/imgs/drawer/header.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget menuItems() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        runSpacing: 5,
        children: [
          Column(
            children: [
              ListTile(
                title: const Text(
                  'Monsters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/monster_icons/chatacabra.png',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const MonstersList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Decorations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/decorations/jewel.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const DecorationsList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/drawer/skill.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const SkillsList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Materials',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/materials/default_material.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const MaterialsList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Armor pieces',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/drawer/armor.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const ArmorPiecesList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Decorations2',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/decorations/jewel.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const DecorationsList2()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Amulets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/decorations/jewel.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const AmuletList()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Armors2',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/decorations/jewel.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const ArmorPiecesList2()),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Skills2',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset(
                  'assets/imgs/decorations/jewel.webp',
                  width: 35,
                  height: 35,
                ),
                onTap: () => onItemSelected(const SkillList2()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
