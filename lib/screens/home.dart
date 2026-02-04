import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/utils/update_checker.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _selectedScreen = const MonstersList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateChecker.checkAndShowUpdateDialog(context);
    });
  }

  String _titleForScreen(BuildContext context, Widget screen) {
    final l10n = AppLocalizations.of(context)!;
    if (screen is MonstersList) return l10n.monsters;
    if (screen is DecorationsList) return l10n.decorations;
    if (screen is ArmorSetList) return l10n.armorSets;
    if (screen is SkillList) return l10n.skills;
    if (screen is AmuletList) return l10n.talismans;
    if (screen is ItemList) return l10n.items;
    if (screen is WeaponsList) return l10n.weapons;
    return l10n.monsters;
  }

  void _changeScreen(Widget newScreen) {
    setState(() => _selectedScreen = newScreen);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Cappbar(
        title: _titleForScreen(context, _selectedScreen),
      ),
      drawer: Cdrawer(onItemSelected: _changeScreen),
      body: _selectedScreen,
    );
  }
}
