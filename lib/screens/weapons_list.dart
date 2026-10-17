import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/filter_panel_layout.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_card.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_filters.dart';
import 'package:mhwilds_app/screens/weapons_list/weapon_series_tree.dart';
import 'package:provider/provider.dart';

// WeaponDisplayUtils también lo usa weapon_details.dart.
export 'package:mhwilds_app/screens/weapons_list/display_utils.dart'
    show WeaponDisplayUtils;

class WeaponsList extends StatefulWidget {
  const WeaponsList({super.key});

  @override
  State<WeaponsList> createState() => _WeaponsListState();
}

class _WeaponsListState extends State<WeaponsList> {
  // El filtro vive en WeaponsProvider; aquí solo los controladores de texto.
  late final TextEditingController _searchNameController;
  late final TextEditingController _searchSeriesController;
  bool _filtersVisible = false;
  bool _isTreeView = false;

  @override
  void initState() {
    super.initState();
    final filter = context.read<WeaponsProvider>().filter;
    _searchNameController = TextEditingController(text: filter.name);
    _searchSeriesController = TextEditingController(text: filter.series);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weaponsProvider =
          Provider.of<WeaponsProvider>(context, listen: false);
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);
      weaponsProvider.fetchWeapons();
      if (!skillsProvider.hasData && !skillsProvider.isLoading) {
        skillsProvider.fetchSkills();
      }
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    _searchNameController.clear();
    _searchSeriesController.clear();
    context.read<WeaponsProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final weaponsProvider = Provider.of<WeaponsProvider>(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: FilterPanelLayout(
        panel: !_filtersVisible
            ? null
            : WeaponsFiltersPanel(
                provider: weaponsProvider,
                nameController: _searchNameController,
                seriesController: _searchSeriesController,
                onReset: _resetFilters,
              ),
        child: Stack(
          children: [
            _buildWeaponsList(
                context, weaponsProvider, weaponsProvider.weapons),
            Positioned(
              top: weaponsProvider.isOffline ? 48 : 8,
              right: 16,
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    icon: const Icon(Icons.view_list),
                    label: Text(l10n.listView),
                  ),
                  ButtonSegment(
                    value: true,
                    icon: const Icon(Icons.account_tree),
                    label: Text(l10n.treeView),
                  ),
                ],
                selected: {_isTreeView},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isTreeView = newSelection.first;
                  });
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return colorScheme.primaryContainer;
                      }
                      return colorScheme.surface.withValues(alpha: 0.9);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _filtersVisible ? l10n.close : l10n.filters,
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildWeaponsList(BuildContext context,
      WeaponsProvider weaponsProvider, List<Weapon> filteredWeapons) {
    final l10n = AppLocalizations.of(context)!;

    final seriesGroups = _isTreeView
        ? groupWeaponsBySeries(filteredWeapons, l10n.noSeries)
        : <String, List<Weapon>>{};
    final seriesKeys = seriesGroups.keys.toList()..sort();

    return AsyncListBody<Weapon>(
      state: weaponsProvider.state,
      isOffline: weaponsProvider.isOffline,
      loadingLabel: l10n.loadingWeapons,
      emptyTitle: l10n.noWeaponsFound,
      emptySubtitle: l10n.tryAdjustingFilters,
      onRetry: weaponsProvider.fetchWeapons,
      onRefresh: () => weaponsProvider.refresh(force: true),
      isEmpty: (_) => filteredWeapons.isEmpty,
      builder: (context, _) => ListView.builder(
        key: PageStorageKey(_isTreeView ? 'weapons-tree' : 'weapons-list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120, top: 64),
        itemCount: _isTreeView ? seriesKeys.length : filteredWeapons.length,
        itemBuilder: (context, index) {
          if (_isTreeView) {
            final seriesName = seriesKeys[index];
            return WeaponSeriesTile(
              seriesName: seriesName,
              weapons: seriesGroups[seriesName]!,
              initiallyExpanded: seriesKeys.length == 1,
            );
          }
          return WeaponCard(weapon: filteredWeapons[index]);
        },
      ),
    );
  }
}
