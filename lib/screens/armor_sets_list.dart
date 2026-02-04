import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/screens/armor_piece_details.dart';
import 'package:mhwilds_app/utils/utils.dart';
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

      if (!armorSetProvider.hasData) {
        armorSetProvider.fetchArmorSets();
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
          if (_filtersVisible) ...[
            Container(
              margin: const EdgeInsets.all(16),
              height: 350, // Altura fija para los filtros
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header de filtros (fijo)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.filters,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(AppLocalizations.of(context)!.reset),
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido de filtros con scroll
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de búsqueda por nombre
                          TextField(
                            controller: _searchNameController,
                            onChanged: (query) {
                              setState(() {
                                _searchNameQuery = query;
                              });
                              armorSetProvider.applyFilters(
                                  name: _searchNameQuery, kind: _selectedKind);
                            },
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.searchByName,
                              hintText: AppLocalizations.of(context)!
                                  .enterArmorSetName,
                              prefixIcon: Icon(Icons.search,
                                  color: colorScheme.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: colorScheme.outlineVariant),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: colorScheme.primary, width: 2),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Filtro de tipo
                          Text(
                            AppLocalizations.of(context)!.type,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: ['head', 'chest', 'arms', 'waist', 'legs']
                                .map((kind) {
                              return FilterChip(
                                label: Text(
                                  _getArmorSlotLabel(context, kind),
                                  style: TextStyle(
                                    color: _selectedKind == kind
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor:
                                    _getKindColor(kind).withOpacity(0.2),
                                selectedColor: _getKindColor(kind),
                                selected: _selectedKind == kind,
                                onSelected: (isSelected) {
                                  setState(() {
                                    _selectedKind = isSelected ? kind : null;
                                  });
                                  armorSetProvider.applyFilters(
                                      name: _searchNameQuery,
                                      kind: _selectedKind);
                                },
                                elevation: 2,
                                pressElevation: 4,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Filtro de rareza
                          Text(
                            AppLocalizations.of(context)!.rarity,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [1, 2, 3, 4, 5, 6, 7].map((rarity) {
                              return FilterChip(
                                label: Text(
                                  AppLocalizations.of(context)!
                                      .rarityLevel(rarity),
                                  style: TextStyle(
                                    color: _selectedRarity == rarity
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor:
                                    _getRarityColor(rarity).withOpacity(0.2),
                                selectedColor: _getRarityColor(rarity),
                                selected: _selectedRarity == rarity,
                                onSelected: (isSelected) {
                                  setState(() {
                                    _selectedRarity =
                                        isSelected ? rarity : null;
                                  });
                                  armorSetProvider.applyFilters(
                                    name: _searchNameQuery,
                                    kind: _selectedKind,
                                    rarity: _selectedRarity,
                                  );
                                },
                                elevation: 2,
                                pressElevation: 4,
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                              height: 20), // Espacio al final para scroll
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

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
                              // Skills de grupo
                              if (armorSet.groupBonus.ranks.isNotEmpty) ...[
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          colorScheme.primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.group_work,
                                            size: 20,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${AppLocalizations.of(context)!.setBonus} ${armorSet.groupBonus.skill.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...armorSet.groupBonus.ranks
                                          .map((rank) => Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: colorScheme.surface,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: colorScheme.primary
                                                        .withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            colorScheme.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Text(
                                                        '${rank.pieces} ${AppLocalizations.of(context)!.pieces}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: colorScheme
                                                              .onPrimary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${AppLocalizations.of(context)!.level} ${rank.skill.level}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: colorScheme
                                                                  .onSurface,
                                                            ),
                                                          ),
                                                          if (rank
                                                              .skill
                                                              .description
                                                              .isNotEmpty) ...[
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                              rank.skill
                                                                  .description,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: colorScheme
                                                                    .onSurface
                                                                    .withOpacity(
                                                                        0.8),
                                                                height: 1.3,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
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
                                                Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: colorScheme
                                                            .primary
                                                            .withOpacity(0.3),
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                      'assets/imgs/armor/${piece.kind}/rarity${piece.rarity}.webp',
                                                      fit: BoxFit.cover,
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
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _getKindColor(
                                                                  piece.kind)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: _getKindColor(
                                                                    piece.kind)
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          _getArmorSlotLabel(
                                                              context,
                                                              piece.kind),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                _getKindColor(
                                                                    piece.kind),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
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
                                            if (piece.skills.isNotEmpty) ...[
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

  Widget _buildSkillsSection(armor_models.ArmorPiece armorPiece) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de defensa
        Row(
          children: [
            Icon(
              Icons.shield,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
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
                SizedBox(
                  height: 16,
                  child: Image.asset(
                    'assets/imgs/armor/armor.webp',
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${armorPiece.defense['base']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
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
            Icon(
              Icons.settings,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.slots}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSlotsWidget(armorPiece),
        const SizedBox(height: 12),
        // Sección de resistencias
        Row(
          children: [
            Icon(
              Icons.security,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
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
            Icon(
              Icons.flash_on,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
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
        ...armorPiece.skills.map((skill) => Container(
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
                        child: UrlImageLoader(
                          itemName:
                              Provider.of<EnNamesCache>(context, listen: false)
                                      .nameForSkillImage(
                                          skill.skill.id, skill.skill.name) ??
                                  skill.skill.name,
                          loadImageUrlFunction: getValidSkillImageUrl,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
        Color slotColor;
        switch (slot) {
          case 1:
            slotColor = Colors.green;
            break;
          case 2:
            slotColor = Colors.blue;
            break;
          case 3:
            slotColor = Colors.purple;
            break;
          case 4:
            slotColor = Colors.orange;
            break;
          default:
            slotColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(right: 6),
          width: 18,
          height: 18,
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
        );
      }).toList(),
    );
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
              SizedBox(
                height: 16,
                child: Image.asset(
                  'assets/imgs/elements/${resistanceType.toLowerCase()}.webp',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                resistanceValue.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
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
    switch (rarity) {
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.green[400]!;
      case 3:
        return Colors.blue[400]!;
      case 4:
        return Colors.purple[400]!;
      case 5:
        return Colors.orange[400]!;
      case 6:
        return Colors.red[400]!;
      case 7:
        return Colors.amber[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
