import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/announcements_provider.dart';
import 'package:mhwilds_app/screens/announcements_list.dart';
import 'package:provider/provider.dart';

/// Altavoz que abre los anuncios, con un punto si hay uno sin ver. Pide los
/// anuncios al construirse (al abrir el drawer), no al arrancar la app.
class AnnouncementsButton extends StatefulWidget {
  const AnnouncementsButton({super.key, this.color});

  final Color? color;

  @override
  State<AnnouncementsButton> createState() => _AnnouncementsButtonState();
}

class _AnnouncementsButtonState extends State<AnnouncementsButton> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<AnnouncementsProvider>().fetch());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasUnseen =
        context.select<AnnouncementsProvider, bool>((p) => p.hasUnseen);
    final label = hasUnseen ? l10n.announcementsNew : l10n.announcements;
    final scheme = Theme.of(context).colorScheme;
    // Botón con fondo y borde para que no parezca un icono suelto sobre el dorado.
    return IconButton.filled(
      tooltip: label,
      style: IconButton.styleFrom(
        fixedSize: const Size(48, 48),
        backgroundColor: scheme.surface.withValues(alpha: 0.55),
        foregroundColor: widget.color ?? scheme.onSurface,
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
        elevation: 1,
      ),
      icon: Badge(
        isLabelVisible: hasUnseen,
        smallSize: 10,
        child: const Icon(Icons.campaign_outlined),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnnouncementsList()),
      ),
    );
  }
}
