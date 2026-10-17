import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/locale_provider.dart';
import 'package:mhwilds_app/screens/bug_report_screen.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:mhwilds_app/utils/locale_utils.dart';
import 'package:mhwilds_app/utils/review_service.dart';
import 'package:provider/provider.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:mhwilds_app/utils/spacing.dart';

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
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.appearance,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.7)),
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
                    final subtitle = getLocaleDisplayName(currentLocale, '');
                    return ListTile(
                      title: Text(l10n.language),
                      subtitle: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
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
          const SizedBox(height: 24),
          Text(
            l10n.rateAppAction,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: ListTile(
              leading: Icon(Icons.star_outline, color: colorScheme.primary),
              title: Text(l10n.rateAppAction),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () => ReviewService.openStore(),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: ListTile(
              leading: Icon(Icons.bug_report_outlined, color: colorScheme.primary),
              title: Text(l10n.reportBug),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const BugReportScreen()),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final packageInfo = snapshot.data!;
                return Center(
                  child: Text(
                    'v${packageInfo.version}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
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
    const supportedLocales = AppLocalizations.supportedLocales;

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
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    l10n.language,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...supportedLocales.map((locale) {
                        final isSelected =
                            currentLocale.languageCode == locale.languageCode &&
                                currentLocale.countryCode == locale.countryCode;
                        return ListTile(
                          title: Text(
                              getLocaleDisplayName(locale, '')),
                          trailing: isSelected
                              ? Icon(Icons.check, color: colorScheme.primary)
                              : null,
                          onTap: () {
                            localeProvider.setLocale(locale);
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
}
