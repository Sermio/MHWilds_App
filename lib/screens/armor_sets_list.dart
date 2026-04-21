import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/set_piece_tag.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/armor_set.dart' as set_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';
import 'package:mhwilds_app/screens/armor_piece_details.dart';
import 'package:provider/provider.dart';

class ArmorSetList extends StatefulWidget {
  const ArmorSetList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ArmorSetListState createState() => _ArmorSetListState();
}

class _ArmorSetListState extends State<ArmorSetList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedKind;
  int? _selectedRarity;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final armorSetProvider =
          Provider.of<ArmorSetProvider>(context, listen: false);
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      if (!armorSetProvider.hasData) {
        armorSetProvider.fetchArmorSets();
      }
      if (!skillsProvider.hasData && !skillsProvider.isLoading) {
        skillsProvider.fetchSkills();
      }
      _resetFilters();
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _selectedKind = null;
      _selectedRarity = null;
      _searchNameController.clear();
    });

    final provider = Provider.of<ArmorSetProvider>(context, listen: false);
    provider.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final armorSetProvider = Provider.of<ArmorSetProvider>(context);
    final filteredArmorSets = armorSetProvider.armorSets;

    if (!armorSetProvider.hasData && !armorSetProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<ArmorSetProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchArmorSets();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          // Filtros mejorados
          if (_filtersVisible) _buildFiltersSection(context, armorSetProvider),

          // Lista de sets de armadura
          Expanded(
            child: armorSetProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.loadingArmorSets,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredArmorSets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noArmorSetsFound,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.tryAdjustingFilters,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: filteredArmorSets.length,
                        itemBuilder: (context, index) {
                          final armorSet = filteredArmorSets[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título del set
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  armorSet.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              // Skills de grupo / set
                              if (armorSet.groupBonusSkill.ranks.isNotEmpty ||
                                  armorSet.pieces.any((p) => p.skills
                                      .any((s) => s.isSetOrGroupBonus))) ...[
                                ArmorSetBonusSection(
                                  armorSet: armorSet,
                                  onSkillIconRequest: (id) =>
                                      _skillIconForId(id, context),
                                ),
                              ],
                              // Piezas del set
                              ...armorSet.pieces.map(
                                (piece) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            colorScheme.shadow.withOpacity(0.1),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ArmorDetails(
                                              armor: piece,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Header de la pieza
                                            Row(
                                              children: [
                                                // Imagen de la armadura
                                                SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: Center(
                                                    child: armorColumnByKind
                                                            .containsKey(
                                                                piece.kind)
                                                        ? GearSpriteIcon(
                                                            column:
                                                                armorColumnByKind[
                                                                    piece
                                                                        .kind]!,
                                                            rarity:
                                                                piece.rarity,
                                                            size: 42,
                                                            fallback:
                                                                Image.asset(
                                                              'assets/imgs/armor/${piece.kind}/rarity${piece.rarity}.webp',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/imgs/armor/${piece.kind}/rarity${piece.rarity}.webp',
                                                            fit: BoxFit.contain,
                                                          ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        piece.name,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: colorScheme
                                                              .onSurface,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Indicador de rarity
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _getRarityColor(
                                                                  piece.rarity)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: _getRarityColor(
                                                                    piece
                                                                        .rarity)
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .rarityLevel(
                                                                  piece.rarity),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                _getRarityColor(
                                                                    piece
                                                                        .rarity),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.6),
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),

                                            // Habilidades
                                            if (piece
                                                .displaySkills.isNotEmpty) ...[
                                              _buildSkillsSection(piece),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
      BuildContext context, ArmorSetProvider armorSetProvider) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: _resetFilters,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: _searchNameController,
          onTextChanged: (query) {
            setState(() {
              _searchNameQuery = query;
            });
            _applyFilters(armorSetProvider);
          },
          hintText: l10n.enterArmorSetName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'type',
          label: l10n.type,
          value: _selectedKind,
          onSelectChanged: (selectedKind) {
            setState(() {
              _selectedKind = selectedKind as String?;
            });
            _applyFilters(armorSetProvider);
          },
          options: _armorTypeOptions(context),
        ),
        ListFilterFieldConfig.select(
          id: 'rarity',
          label: l10n.rarity,
          value: _selectedRarity,
          onSelectChanged: (selectedRarity) {
            setState(() {
              _selectedRarity = selectedRarity as int?;
            });
            _applyFilters(armorSetProvider);
          },
          options: _rarityOptions(),
        ),
      ],
    );
  }

  void _applyFilters(ArmorSetProvider armorSetProvider) {
    armorSetProvider.applyFilters(
      name: _searchNameQuery,
      kind: _selectedKind,
      rarity: _selectedRarity,
    );
  }

  List<ListFilterOption> _armorTypeOptions(BuildContext context) {
    return ['head', 'chest', 'arms', 'waist', 'legs'].map((kind) {
      final int? spriteColumn = armorColumnByKind[kind];
      return ListFilterOption(
        value: kind,
        label: _getArmorSlotLabel(context, kind),
        leading: spriteColumn != null
            ? GearSpriteIcon(
                column: spriteColumn,
                rarity: 1,
                size: 20,
                fallback: Icon(
                  Icons.shield,
                  color: _getKindColor(kind),
                  size: 20,
                ),
              )
            : Icon(
                Icons.shield,
                color: _getKindColor(kind),
                size: 20,
              ),
      );
    }).toList();
  }

  List<ListFilterOption> _rarityOptions() {
    return [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
      return ListFilterOption(
        value: rarity,
        label: rarity.toString(),
        leading: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _getRarityColor(rarity),
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSkillsSection(armor_models.ArmorPiece armorPiece) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de defensa
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.defense}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '${armorPiece.defense['base']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  height: 16,
                  child: Image.asset(
                    'assets/imgs/armor/armor.webp',
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Sección de slots
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.slots}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const Spacer(),
            _buildSlotsWidget(armorPiece),
          ],
        ),
        const SizedBox(height: 12),
        // Sección de resistencias
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.resistances}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildResistancesWidget(armorPiece),
        const SizedBox(height: 12),
        // Sección de skills
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.skills}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...armorPiece.displaySkills.map((skill) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Imagen de la habilidad
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        child: SkillSpriteIcon(
                          iconId: _skillIconForId(skill.skill.id, context)?.id,
                          iconKind:
                              _skillIconForId(skill.skill.id, context)?.kind,
                          size: 24,
                          fallback: Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${skill.name ?? skill.skill.name} +${skill.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (skill.setPiecesRequired != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SetPieceTag(
                            count: skill.setPiecesRequired!,
                          ),
                        ),
                    ],
                  ),
                  if (skill.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      skill.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSlotsWidget(armor_models.ArmorPiece armorPiece) {
    final colorScheme = Theme.of(context).colorScheme;
    if (armorPiece.slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Text(
          AppLocalizations.of(context)!.noSlots,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: armorPiece.slots.map((slot) {
        final Color slotColor = _slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 18,
            fallback: Container(
              decoration: BoxDecoration(
                color: slotColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: slotColor, width: 1),
              ),
              child: Center(
                child: Text(
                  slot.toString(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: slotColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _slotColor(int slot) {
    switch (slot) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildResistancesWidget(armor_models.ArmorPiece armorPiece) {
    final colorScheme = Theme.of(context).colorScheme;
    if (armorPiece.resistances.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Text(
          AppLocalizations.of(context)!.noResistances,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: armorPiece.resistances.entries.map((entry) {
        final resistanceType = entry.key;
        final resistanceValue = entry.value;

        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Text(
                resistanceValue.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 16,
                child: Image.asset(
                  'assets/imgs/elements/${resistanceType.toLowerCase()}.webp',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getArmorSlotLabel(BuildContext context, String slot) {
    final l10n = AppLocalizations.of(context)!;
    switch (slot) {
      case 'head':
        return l10n.armorSlotHead;
      case 'chest':
        return l10n.armorSlotChest;
      case 'arms':
        return l10n.armorSlotArms;
      case 'waist':
        return l10n.armorSlotWaist;
      case 'legs':
        return l10n.armorSlotLegs;
      default:
        return slot;
    }
  }

  Color _getKindColor(String kind) {
    switch (kind) {
      case 'head':
        return Colors.red[400]!;
      case 'chest':
        return Colors.blue[400]!;
      case 'arms':
        return Colors.green[400]!;
      case 'waist':
        return Colors.orange[400]!;
      case 'legs':
        return Colors.purple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  Color _getRarityColor(int rarity) {
    return rarityColorFromSprite(rarity);
  }

  skills_model.SkillIcon? _skillIconForId(int skillId, BuildContext context) {
    final skillsProvider = Provider.of<SkillsProvider>(context, listen: false);
    for (final skill in skillsProvider.allSkills) {
      if (skill.id == skillId) {
        return skill.icon;
      }
    }
    return null;
  }
}

class ArmorSetBonusSection extends StatefulWidget {
  final set_models.ArmorSet armorSet;
  final skills_model.SkillIcon? Function(int) onSkillIconRequest;

  const ArmorSetBonusSection({
    super.key,
    required this.armorSet,
    required this.onSkillIconRequest,
  });

  @override
  State<ArmorSetBonusSection> createState() => _ArmorSetBonusSectionState();
}

class _ArmorSetBonusSectionState extends State<ArmorSetBonusSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Título del bono para comparar
    final String bonusTitleName = widget.armorSet.setBonusSkill.name.isNotEmpty
        ? widget.armorSet.setBonusSkill.name
        : (widget.armorSet.groupBonusSkill.name.isNotEmpty
            ? widget.armorSet.groupBonusSkill.name
            : widget.armorSet.groupBonusSkill.skill.name);

    // Agrupar habilidades
    final Map<int, Map<String, dynamic>> bonusSkills = {};
    for (var piece in widget.armorSet.pieces) {
      for (var skillInfo in piece.skills) {
        if (skillInfo.isSetOrGroupBonus) {
          // Priorizar descripción de la habilidad si no es la genérica
          String bestDescription = skillInfo.skill.description;
          if (bestDescription == 'No description available' ||
              bestDescription.isEmpty) {
            bestDescription = skillInfo.description;
          }

          bonusSkills[skillInfo.skill.id] = {
            'skill': skillInfo.skill,
            'description': bestDescription,
          };
        }
      }
    }

    final allSkills = bonusSkills.values.toList();
    if (allSkills.isEmpty) return const SizedBox.shrink();

    // Identificar el bono primario:
    // 1. Intentar coincidir por nombre Y que sea tipo 'set'
    int primaryIndex = allSkills.indexWhere((s) {
      final skill = s['skill'] as skills_model.Skills;
      return skill.name.toLowerCase() == bonusTitleName.toLowerCase() &&
          skill.kind.toLowerCase() == 'set';
    });

    // 2. Si no, intentar coincidir solo por nombre
    if (primaryIndex == -1) {
      primaryIndex = allSkills.indexWhere((s) {
        final skill = s['skill'] as skills_model.Skills;
        return skill.name.toLowerCase() == bonusTitleName.toLowerCase();
      });
    }

    // 3. Si no, buscar la primera que sea de tipo 'set'
    if (primaryIndex == -1) {
      primaryIndex = allSkills.indexWhere((s) {
        final skill = s['skill'] as skills_model.Skills;
        return skill.kind.toLowerCase() == 'set';
      });
    }

    // 4. Si aún no hay nada, usar la primera disponible
    if (primaryIndex == -1) primaryIndex = 0;

    final primarySkill = allSkills[primaryIndex];
    final List<Map<String, dynamic>> extraSkills = [];
    for (int i = 0; i < allSkills.length; i++) {
      if (i != primaryIndex) {
        extraSkills.add(allSkills[i]);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.group_work,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.setBonus} ${(primarySkill['skill'] as skills_model.Skills).name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Bono primario (siempre visible)
          _buildSkillCard(
              context, primarySkill['skill'], primarySkill['description']),

          // Otros bonos (colapsables)
          if (extraSkills.isNotEmpty) ...[
            if (_isExpanded)
              ...extraSkills.map(
                  (s) => _buildSkillCard(context, s['skill'], s['description']))
            else
              const SizedBox.shrink(),

            // Botón de expansión centrando
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                label: Text(
                  _isExpanded
                      ? AppLocalizations.of(context)!.showLess
                      : '${AppLocalizations.of(context)!.showMore} (${extraSkills.length})',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillCard(
      BuildContext context, skills_model.Skills skill, String description) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = widget.onSkillIconRequest(skill.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 8),
                child: SkillSpriteIcon(
                  iconId: iconData?.id,
                  iconKind: iconData?.kind,
                  size: 24,
                  fallback: Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A35C)
                      .withOpacity(0.8), // Dorado/Beige solicitado
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black, // Texto negro solicitado
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty &&
              description != 'No description available') ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.8),
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
