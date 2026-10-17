import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/filter_panel_layout.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/components/set_piece_tag.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/utils/spacing.dart';

class SkillList extends StatefulWidget {
  const SkillList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SkillListState2 createState() => _SkillListState2();
}

class _SkillListState2 extends State<SkillList> {
  // El filtro vive en SkillsProvider; aquí solo el controlador del texto.
  late final TextEditingController _searchNameController;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();
    _searchNameController =
        TextEditingController(text: context.read<SkillsProvider>().filter.name);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      skillsProvider.fetchSkills();
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    _searchNameController.clear();
    context.read<SkillsProvider>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final skillsProvider = Provider.of<SkillsProvider>(context);
    final filteredSkills = skillsProvider.skills;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: FilterPanelLayout(
        panel: !_filtersVisible
            ? null
            : _buildFiltersSection(context, skillsProvider),
        child: Stack(
          children: [
            // Lista de habilidades
            AsyncListBody<Skills>(
              state: skillsProvider.state,
              isOffline: skillsProvider.isOffline,
              loadingLabel: l10n.loadingSkills,
              emptyTitle: l10n.noSkillsFound,
              emptySubtitle: l10n.tryAdjustingFilters,
              onRetry: skillsProvider.fetchSkills,
              onRefresh: () => skillsProvider.refresh(force: true),
              isEmpty: (_) => filteredSkills.isEmpty,
              builder: (context, _) => ListView.builder(
                key: const PageStorageKey('skills-list'),
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120, top: AppSpacing.lg),
                itemCount: filteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = filteredSkills[index];

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg)
                            .copyWith(bottom: 16),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SkillDetails(
                                skillsIds: [skill.id],
                                skillsLevels: const [1],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header de la habilidad
                              Row(
                                children: [
                                  // Icono de la habilidad
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: SkillSpriteIcon(
                                        iconId: skill.icon?.id,
                                        iconKind: skill.icon?.kind,
                                        size: 60,
                                        fallback: Icon(
                                          Icons.auto_awesome,
                                          color: _getTypeColor(skill.kind),
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                skill.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            if (skill.ranks.any(
                                                (r) => r.setPiecesRequired > 0))
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: AppSpacing.sm),
                                                child: SetPieceTag(
                                                  count: skill.ranks
                                                      .firstWhere((r) =>
                                                          r.setPiecesRequired >
                                                          0)
                                                      .setPiecesRequired,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.sm,
                                              vertical: AppSpacing.xs),
                                          decoration: BoxDecoration(
                                            color: _getTypeColor(skill.kind)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: _getTypeColor(skill.kind)
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: _buildSkillTypeBadge(
                                            context,
                                            skill.kind,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Descripción
                              if (skill.description.isNotEmpty) ...[
                                Text(
                                  skill.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.8),
                                          height: 1.4),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: _filtersVisible
            ? AppLocalizations.of(context)!.close
            : AppLocalizations.of(context)!.filters,
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    SkillsProvider skillsProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      maxHeight: 250,
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: _resetFilters,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: _searchNameController,
          onTextChanged: (query) => skillsProvider
              .setFilter(skillsProvider.filter.copyWith(name: query)),
          hintText: l10n.enterSkillName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.gridMenu(
          id: 'type',
          label: l10n.type,
          // El filtro guarda el tipo en minúsculas; las opciones, capitalizado.
          value: _capitalized(skillsProvider.filter.kind),
          onSelectChanged: (selectedType) => skillsProvider.setFilter(
              skillsProvider.filter.copyWith(
                  kind: () => (selectedType as String?)?.toLowerCase())),
          options: ['Weapon', 'Armor', 'Group', 'Set']
              .map(
                (type) => ListFilterOption(
                  value: type,
                  label: _getSkillTypeLabel(context, type),
                  leading: _buildSkillTypeFilterIcon(type),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  static String? _capitalized(String? text) => text == null || text.isEmpty
      ? text
      : text[0].toUpperCase() + text.substring(1);

  Widget _buildSkillTypeFilterIcon(String type) {
    final kindLower = type.toLowerCase();
    final color = _getTypeColor(type);

    switch (kindLower) {
      case 'weapon':
        return GearSpriteIcon(
          column: weaponColumnByKind['great-sword']!,
          rarity: 1,
          size: 18,
          fallback: Icon(
            Icons.gps_fixed,
            size: 18,
            color: color,
          ),
        );
      case 'armor':
        return GearSpriteIcon(
          column: armorColumnByKind['head']!,
          rarity: 1,
          size: 18,
          fallback: Icon(
            Icons.shield,
            size: 18,
            color: color,
          ),
        );
      case 'group':
      case 'set':
        return SkillSpriteIcon(
          iconKind: kindLower,
          size: 18,
          fallback: Icon(
            Icons.category,
            size: 18,
            color: color,
          ),
        );
      default:
        return Icon(
          Icons.category,
          size: 18,
          color: color,
        );
    }
  }

  Widget _buildSkillTypeBadge(BuildContext context, String kind) {
    final typeColor = _getTypeColor(kind);
    final kindLower = kind.toLowerCase();

    Widget? leadingIcon;
    if (kindLower == 'weapon') {
      leadingIcon = GearSpriteIcon(
        column: weaponColumnByKind['great-sword']!,
        rarity: 1,
        size: 14,
        fallback: Icon(
          Icons.gps_fixed,
          size: 14,
          color: typeColor,
        ),
      );
    } else if (kindLower == 'armor') {
      leadingIcon = GearSpriteIcon(
        column: armorColumnByKind['head']!,
        rarity: 1,
        size: 14,
        fallback: Icon(
          Icons.shield,
          size: 14,
          color: typeColor,
        ),
      );
    } else if (kindLower == 'group' || kindLower == 'set') {
      leadingIcon = SkillSpriteIcon(
        iconKind: kindLower,
        size: 14,
        fallback: Icon(
          Icons.category,
          size: 14,
          color: typeColor,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon,
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            _getSkillTypeLabel(context, kind),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: typeColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _getSkillTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'weapon':
        return l10n.typeWeapon;
      case 'armor':
        return l10n.typeArmor;
      case 'group':
        return l10n.typeGroup;
      case 'set':
        return l10n.typeSet;
      default:
        return type;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'weapon':
        return Colors.red[400]!;
      case 'armor':
        return Colors.blue[400]!;
      case 'group':
        return Colors.green[400]!;
      case 'set':
        return Colors.purple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
