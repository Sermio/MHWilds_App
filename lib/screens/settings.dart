import 'package:flutter/material.dart';
import 'package:mhwilds_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: SwitchListTile(
                  title: const Text('Dark mode'),
                  subtitle: Text(
                    themeProvider.mode == AppThemeMode.dark
                        ? 'On'
                        : 'Off (default)',
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
