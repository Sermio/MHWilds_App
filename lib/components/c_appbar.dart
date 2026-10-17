import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/app_bar_background.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/settings.dart';

class Cappbar extends StatelessWidget implements PreferredSizeWidget {
  const Cappbar({super.key, this.title = "", this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: actions ??
          [
            IconButton(
              tooltip: AppLocalizations.of(context)!.settings,
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
          ],
      flexibleSpace: const AppBarBackground(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
