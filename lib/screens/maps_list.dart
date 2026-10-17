import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/location.dart';
import 'package:mhwilds_app/utils/asset_ids.g.dart';
import 'package:mhwilds_app/utils/spacing.dart';

class MapsList extends StatefulWidget {
  const MapsList({super.key});

  @override
  State<MapsList> createState() => _MapsListState();
}

class _MapsListState extends State<MapsList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocationsProvider>(context, listen: false);
      provider.fetchZones();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<LocationsProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: AsyncListBody<MapData>(
        state: provider.state,
        isOffline: provider.isOffline,
        loadingLabel: l10n.loadingMap,
        emptyTitle: l10n.noMapImagesFound,
        onRetry: provider.fetchZones,
        onRefresh: () => provider.refresh(force: true),
        builder: (context, zones) => ListView.builder(
          key: const PageStorageKey('maps-list'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          itemCount: zones.length,
          itemBuilder: (context, index) => _buildMapCard(context, zones[index]),
        ),
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, MapData zone) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final imagePath =
        locationMapAssets[zone.id]?.first ?? 'assets/imgs/maps/map.webp';

    final campCount = zone.camps?.length ?? 0;
    final zoneCount = zone.zoneCount ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
            if (zone.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MonsterMapDetails(mapId: zone.id!),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AssetThumb(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to static generic map image
                          return AssetThumb(
                            'assets/imgs/maps/map.webp',
                            fit: BoxFit.contain,
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            colorBlendMode: BlendMode.dstATop,
                          );
                        },
                      ),
                      // Gradient overlay for text contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          zone.name ?? l10n.unknownMap,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                const Shadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Body Info
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.sm,
                        children: [
                          // Zonas chip
                          _buildInfoBadge(
                            context,
                            Icons.grid_on,
                            '${l10n.zone}: $zoneCount',
                            colorScheme.primary,
                          ),
                          // Campamentos chip
                          _buildInfoBadge(
                            context,
                            Icons.campaign_outlined,
                            '${l10n.camps}: $campCount',
                            colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBadge(
      BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
