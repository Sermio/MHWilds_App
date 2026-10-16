import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/locations_provider.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/location.dart';

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

    if (provider.state is Idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<LocationsProvider>(context, listen: false);
        if (p.state is Idle) p.fetchZones();
      });
    }

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
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: zones.length,
          itemBuilder: (context, index) => _buildMapCard(context, zones[index]),
        ),
      ),
    );
  }

  Widget _buildMapCard(BuildContext context, MapData zone) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final enNamesCache = Provider.of<EnNamesCache>(context, listen: false);

    final englishMapName = enNamesCache.nameForMapImage(
          zone.id ?? 0,
          zone.name ?? '',
        ) ??
        zone.name ??
        '';

    final folder =
        englishMapName.toLowerCase().replaceAll(' ', '_').replaceAll("'", '_');
    final imagePath = 'assets/imgs/maps/$folder/${folder}1.webp';

    final campCount = zone.camps?.length ?? 0;
    final zoneCount = zone.zoneCount ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(20),
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Body Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Zonas chip
                    _buildInfoBadge(
                      context,
                      Icons.grid_on,
                      '${l10n.zone}: $zoneCount',
                      colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    // Campamentos chip
                    _buildInfoBadge(
                      context,
                      Icons.campaign_outlined,
                      '${l10n.camps}: $campCount',
                      colorScheme.secondary,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
