import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/utils/update_checker.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/screens/build_optimizer_screen.dart';
import 'package:mhwilds_app/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _buildOptimizerNewsSeenKey =
      'build_optimizer_news_seen_v1';
  Widget _selectedScreen = const MonstersList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppUpdateChecker.checkAndShowUpdateDialog(context);
      await _showBuildOptimizerNewsOnce();
    });
  }

  Future<void> _showBuildOptimizerNewsOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadySeen = prefs.getBool(_buildOptimizerNewsSeenKey) ?? false;
    if (alreadySeen || !mounted) return;

    await showBuildOptimizerNewsDialog(context);
    await prefs.setBool(_buildOptimizerNewsSeenKey, true);
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
    if (screen is BuildOptimizerScreen) return l10n.buildOptimizer;
    return l10n.monsters;
  }

  void _changeScreen(Widget newScreen) {
    setState(() => _selectedScreen = newScreen);
    Navigator.pop(context);
  }

  List<Widget>? _appBarActions() {
    if (_selectedScreen is BuildOptimizerScreen) {
      return [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => showBuildOptimizerCreditsDialog(context),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
        ),
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Cappbar(
        title: _titleForScreen(context, _selectedScreen),
        actions: _appBarActions(),
      ),
      drawer: Cdrawer(
        onItemSelected: _changeScreen,
        selectedScreen: _selectedScreen,
      ),
      body: _selectedScreen,
    );
  }
}
