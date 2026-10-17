import 'package:mhwilds_app/api/cached_api.dart';
import 'package:mhwilds_app/providers/announcements_provider.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/cached_list_provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Un provider de datos que sigue el idioma de [LocaleProvider]: cada cambio
/// de idioma llega a `setLanguage`, que recarga los datos en el idioma nuevo
/// (de la caché en disco si ya existen). Sustituye al idioma global y a la
/// invalidación manual desde Ajustes.
ChangeNotifierProxyProvider<LocaleProvider, P>
    _followingLocale<P extends CachedListProvider<dynamic>>(
            P Function() create) =>
        ChangeNotifierProxyProvider<LocaleProvider, P>(
          lazy: true,
          create: (context) =>
              create()..setLanguage(context.read<LocaleProvider>().apiLanguage),
          update: (_, locale, provider) =>
              provider!..setLanguage(locale.apiLanguage),
        );

/// Providers de datos de la app, todos enlazados al idioma actual.
/// [api] permite sustituir el acceso a la API (tests).
List<SingleChildWidget> dataProviders({CachedApi? api}) => [
      _followingLocale(() => SkillsProvider(api: api)),
      _followingLocale(() => ArmorSetProvider(api: api)),
      _followingLocale(() => TalismansProvider(api: api)),
      _followingLocale(() => DecorationsProvider(api: api)),
      _followingLocale(() => ItemsProvider(api: api)),
      _followingLocale(() => MonstersProvider(api: api)),
      _followingLocale(() => LocationsProvider(api: api)),
      _followingLocale(() => WeaponsProvider(api: api)),
      // Trae todos los idiomas en un archivo: no sigue a LocaleProvider.
      ChangeNotifierProvider(create: (_) => AnnouncementsProvider(api: api)),
    ];
