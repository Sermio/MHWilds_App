import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/api_config.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/utils/locale_utils.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.appearance,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Consumer<LocaleProvider>(
                  builder: (context, localeProvider, _) {
                    final currentLocale = localeProvider.locale;
                    final subtitle = getLocaleDisplayName(
                      currentLocale,
                      l10n.systemDefault,
                    );
                    return ListTile(
                      title: Text(l10n.language),
                      subtitle: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () =>
                          _showLanguageSelector(context, localeProvider),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant,
                  indent: 16,
                  endIndent: 16,
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return SwitchListTile(
                      title: Text(l10n.darkMode),
                      subtitle: Text(
                        themeProvider.mode == AppThemeMode.dark
                            ? l10n.on
                            : l10n.offDefault,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      value: themeProvider.mode == AppThemeMode.dark,
                      onChanged: (value) {
                        themeProvider.setMode(
                          value ? AppThemeMode.dark : AppThemeMode.light,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    LocaleProvider localeProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentLocale = localeProvider.locale;
    final supportedLocales = AppLocalizations.supportedLocales;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.language,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(l10n.systemDefault),
                        trailing: currentLocale == null
                            ? Icon(Icons.check, color: colorScheme.primary)
                            : null,
                        onTap: () {
                          ApiConfig.languageCode = WidgetsBinding
                              .instance.platformDispatcher.locale.languageCode;
                          localeProvider.setLocale(null);
                          _invalidateDataProviders(ctx);
                          Navigator.pop(ctx);
                        },
                      ),
                      ...supportedLocales.map((locale) {
                        final isSelected = currentLocale != null &&
                            currentLocale.languageCode == locale.languageCode &&
                            currentLocale.countryCode == locale.countryCode;
                        return ListTile(
                          title: Text(
                              getLocaleDisplayName(locale, l10n.systemDefault)),
                          trailing: isSelected
                              ? Icon(Icons.check, color: colorScheme.primary)
                              : null,
                          onTap: () {
                            ApiConfig.languageCode = locale.languageCode;
                            localeProvider.setLocale(locale);
                            _invalidateDataProviders(ctx);
                            Navigator.pop(ctx);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Invalida la caché de todos los providers de datos para que la próxima
  /// vez que se abra cada pantalla se vuelva a pedir la API con el nuevo idioma.
  void _invalidateDataProviders(BuildContext context) {
    Provider.of<MonstersProvider>(context, listen: false).invalidate();
    Provider.of<WeaponsProvider>(context, listen: false).invalidate();
    Provider.of<ArmorSetProvider>(context, listen: false).invalidate();
    Provider.of<DecorationsProvider>(context, listen: false).invalidate();
    Provider.of<ItemsProvider>(context, listen: false).invalidate();
    Provider.of<LocationsProvider>(context, listen: false).invalidate();
    Provider.of<SkillsProvider>(context, listen: false).invalidate();
    Provider.of<TalismansProvider>(context, listen: false).invalidate();
  }
}
