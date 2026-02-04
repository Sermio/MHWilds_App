import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/filter_panel.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/utils/utils.dart';

class AmuletList extends StatefulWidget {
  const AmuletList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AmuletListState createState() => _AmuletListState();
}

class _AmuletListState extends State<AmuletList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  int? _selectedRarity;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final talismansProvider =
          Provider.of<TalismansProvider>(context, listen: false);

      if (!talismansProvider.hasData) {
        talismansProvider.fetchAmulets();
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
      _selectedRarity = null;
      _searchNameController.clear();
    });
    Provider.of<TalismansProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final talismansProvider = Provider.of<TalismansProvider>(context);
    List<Amulet> filteredAmulets = talismansProvider.filteredAmulets;
    final colorScheme = Theme.of(context).colorScheme;

    if (!talismansProvider.hasData && !talismansProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<TalismansProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchAmulets();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          if (_filtersVisible) ...[
            FilterPanel(
              height: 250,
              onReset: _resetFilters,
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
                      talismansProvider.applyFilters(
                        name: _searchNameQuery,
                        rarity: _selectedRarity,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: l10n.searchByName,
                      hintText: l10n.enterTalismanName,
                      prefixIcon:
                          Icon(Icons.search, color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtro de rareza
                  Text(
                    l10n.rarity,
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
                          l10n.rarityLevel(rarity),
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
                            _selectedRarity = isSelected ? rarity : null;
                          });
                          talismansProvider.applyFilters(
                            name: _searchNameQuery,
                            rarity: _selectedRarity,
                          );
                        },
                        elevation: 2,
                        pressElevation: 4,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20), // Espacio al final para scroll
                ],
              ),
            ),
          ],

          // Lista de talismanes
          Expanded(
            child: talismansProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingTalismans,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredAmulets.isEmpty
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
                              l10n.noTalismansFound,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.tryAdjustingFilters,
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
                        itemCount: filteredAmulets.length,
                        itemBuilder: (context, index) {
                          var amulet = filteredAmulets[index];
                          var ranks = amulet.ranks;
                          var firstRank = ranks.isNotEmpty ? ranks[0] : null;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  if (firstRank != null) {
                                    final skillIds = firstRank.skills
                                        .map((s) => s.skill.id)
                                        .toList();
                                    final skillLevels = firstRank.skills
                                        .map((s) => s.level)
                                        .toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SkillDetails(
                                          skillsIds: skillIds,
                                          skillsLevels: skillLevels,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header del talisman
                                      Row(
                                        children: [
                                          // Imagen del talisman
                                          Container(
                                            width: 35,
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: colorScheme.primary
                                                      .withOpacity(0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                'assets/imgs/amulets/rarity${firstRank?.rarity ?? 1}.webp',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  firstRank?.name ??
                                                      AppLocalizations.of(
                                                              context)!
                                                          .unknown,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (firstRank != null) ...[
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _getRarityColor(
                                                              firstRank.rarity)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: _getRarityColor(
                                                                firstRank
                                                                    .rarity)
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      l10n.rarityLevel(
                                                          firstRank.rarity),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _getRarityColor(
                                                            firstRank.rarity),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Habilidades del primer rango
                                      if (firstRank != null &&
                                          firstRank.skills.isNotEmpty) ...[
                                        _buildSkillsSection(firstRank),
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
      // Botón flotante para mostrar/ocultar filtros
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

  Widget _buildSkillsSection(AmuletRank rank) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ...rank.skills.map((skill) => Container(
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
                              (Provider.of<EnNamesCache>(context, listen: false)
                                      .nameForSkillImage(
                                          skill.skill.id, skill.skill.name) ??
                                  skill.skill.name),
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

  Color _getRarityColor(int rarity) {
    final colorScheme = Theme.of(context).colorScheme;
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
        return colorScheme.primary;
      case 8:
        return Colors.pink[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
