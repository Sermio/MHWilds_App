import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/screens/armor_pieces_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/materials_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
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
      } else if (newScreen is MaterialsList) {
        _appBarTitle = "Materials";
      } else if (newScreen is ArmorSetList) {
        _appBarTitle = "Armor Pieces";
      } else if (newScreen is SkillList) {
        _appBarTitle = "Skills";
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
