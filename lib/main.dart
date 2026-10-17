import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/data_providers.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/utils/theme.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final startup = Stopwatch()..start();
  // Al volver a primer plano tras más de 4 h, comprueba si hay datos nuevos.
  AppLifecycleListener(onResume: CachedApi.shared.versions.onResume);
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: ApiClient.shared),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ...dataProviders(),
      ],
      child: const MyApp(),
    ),
  );
  // Tiempo hasta el primer frame de la app; el de la pantalla de carga cuenta.
  WidgetsBinding.instance.addPostFrameCallback((_) =>
      debugPrint('Startup: first frame in ${startup.elapsedMilliseconds} ms'));
}

/// Espera solo a lo local (idioma guardado e índice de iconos) antes de pintar,
/// así la primera petición (p. ej. monstruos) usa ya el idioma correcto.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return FutureBuilder<void>(
      future: Future.wait([
        localeProvider.localeReady,
        ItemIconAssetResolver.ensureIndexLoaded(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        return Consumer2<ThemeProvider, LocaleProvider>(
          builder: (context, themeProvider, localeProvider, _) {
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
