import 'package:flutter/material.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SkillsProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => ArmorSetProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => TalismansProvider(), lazy: true),
        ChangeNotifierProvider(
            create: (_) => DecorationsProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => ItemsProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => MonstersProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => LocationsProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => WeaponsProvider(), lazy: true),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
        );
      },
    );
  }
}
