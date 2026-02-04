import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EnNamesCache()..loadEnNames()),
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

/// Espera a que el idioma guardado esté cargado antes de mostrar la UI,
/// así la primera petición (p. ej. monstruos) usa ya el idioma correcto.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final enNamesCache = Provider.of<EnNamesCache>(context);

    return FutureBuilder<void>(
      future: Future.wait([
        localeProvider.localeReady,
        enNamesCache.cacheReady,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return Consumer2<ThemeProvider, LocaleProvider>(
          builder: (context, themeProvider, localeProvider, _) {
            ApiConfig.languageCode = localeProvider.locale?.languageCode ??
                WidgetsBinding.instance.platformDispatcher.locale.languageCode;
            return MaterialApp(
              title: 'MHWilds Assistant',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              debugShowCheckedModeBanner: false,
              locale: localeProvider.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const HomeScreen(),
            );
          },
        );
      },
    );
  }
}
