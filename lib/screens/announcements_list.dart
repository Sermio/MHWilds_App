import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/components/c_appbar.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/announcement.dart';
import 'package:mhwilds_app/providers/announcements_provider.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Lista de anuncios. Mientras está abierta, el más reciente queda como visto.
class AnnouncementsList extends StatefulWidget {
  const AnnouncementsList({super.key});

  @override
  State<AnnouncementsList> createState() => _AnnouncementsListState();
}

class _AnnouncementsListState extends State<AnnouncementsList> {
  late final AnnouncementsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = context.read<AnnouncementsProvider>()..addListener(_markSeen);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.fetch();
      _markSeen();
    });
  }

  // También cubre los anuncios que llegan con la pantalla ya abierta.
  void _markSeen() {
    if (_provider.hasUnseen) _provider.markSeen();
  }

  @override
  void dispose() {
    _provider.removeListener(_markSeen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<AnnouncementsProvider>();
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: Cappbar(title: l10n.announcements, actions: const []),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: AsyncListBody<Announcement>(
        state: provider.state,
        isOffline: provider.isOffline,
        loadingLabel: l10n.loadingAnnouncements,
        emptyTitle: l10n.noAnnouncements,
        onRetry: provider.fetch,
        onRefresh: () => provider.refresh(force: true),
        // Como un chat: los más recientes abajo (el archivo los trae primero) y
        // al subir se ven los antiguos. `reverse` también abre la lista abajo.
        builder: (context, items) => ListView.builder(
          reverse: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: items.length,
          itemBuilder: (context, i) =>
              _AnnouncementCard(items[i], languageCode: languageCode),
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard(this.announcement, {required this.languageCode});

  final Announcement announcement;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = announcement.url;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(color: AppColors.goldSoft, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MaterialLocalizations.of(context)
                    .formatMediumDate(announcement.date),
                style: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(announcement.titleFor(languageCode),
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              AnnouncementBody(announcement.bodyFor(languageCode)),
              if (url != null)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: () =>
                        launchUrl(url, mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new),
                    label: Text(AppLocalizations.of(context)!.openLink),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cuerpo de un anuncio: las líneas que empiezan por «• » se pintan como
/// viñetas con sangría; el resto, como párrafos.
class AnnouncementBody extends StatelessWidget {
  const AnnouncementBody(this.text, {super.key});

  final String text;

  static const _bullet = '• ';

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in text.split('\n'))
          if (line.startsWith(_bullet))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text('•',
                        style: style?.copyWith(
                            color: AppColors.goldAccent(context),
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                      child:
                          Text(line.substring(_bullet.length), style: style)),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(line, style: style),
            ),
      ],
    );
  }
}
