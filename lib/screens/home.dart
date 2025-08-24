import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedScreen = const MonstersList();
  String _appBarTitle = "Monsters";

  void _changeScreen(Widget newScreen) {
    setState(() {
      if (newScreen is MonstersList) {
        _appBarTitle = "Monsters";
      } else if (newScreen is DecorationsList) {
        _appBarTitle = "Decorations";
      } else if (newScreen is ArmorSetList) {
        _appBarTitle = "Armor Sets";
      } else if (newScreen is SkillList) {
        _appBarTitle = "Skills";
      } else if (newScreen is AmuletList) {
        _appBarTitle = "Talismans";
      } else if (newScreen is ItemList) {
        _appBarTitle = "Items";
      }
      _selectedScreen = newScreen;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Cappbar(
        title: _appBarTitle,
      ),
      drawer: Cdrawer(onItemSelected: _changeScreen),
      body: _selectedScreen,
    );
  }
}
