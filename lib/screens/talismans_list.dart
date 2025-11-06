import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/providers/talismans_provider.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/talisman.dart';
import 'package:mhwilds_app/utils/colors.dart';
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
    final talismansProvider = Provider.of<TalismansProvider>(context);
    List<Amulet> filteredAmulets = talismansProvider.filteredAmulets;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Filtros mejorados
          if (_filtersVisible) ...[
            Container(
              margin: const EdgeInsets.all(16),
              height: 250, // Altura fija para los filtros
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
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
                        const Icon(Icons.filter_list,
                            color: AppColors.goldSoft),
                        const SizedBox(width: 8),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Reset'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.goldSoft,
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
                              talismansProvider.applyFilters(
                                name: _searchNameQuery,
                                rarity: _selectedRarity,
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search by Name',
                              hintText: 'Enter talisman name...',
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.goldSoft),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColors.goldSoft, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Filtro de rareza
                          const Text(
                            'Rarity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [1, 2, 3, 4, 5, 6, 7].map((rarity) {
                              return FilterChip(
                                label: Text(
                                  'Rarity $rarity',
                                  style: TextStyle(
                                    color: _selectedRarity == rarity
                                        ? Colors.white
                                        : Colors.black87,
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

          // Lista de talismanes
          Expanded(
            child: talismansProvider.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.goldSoft),
                        SizedBox(height: 16),
                        Text(
                          'Loading talismans...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
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
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No talismans found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
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
                                                    color: AppColors.goldSoft
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
                                                        'Unknown',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black87,
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
                                                                firstRank
                                                                    .rarity)
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: _getRarityColor(
                                                                  firstRank
                                                                      .rarity)
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Rarity ${firstRank.rarity}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              _getRarityColor(
                                                                  firstRank
                                                                      .rarity),
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
                                              color: Colors.grey[400],
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
        backgroundColor: AppColors.goldSoft,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSkillsSection(AmuletRank rank) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Skills:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...rank.skills.map((skill) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldSoft.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.goldSoft.withOpacity(0.3)),
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
                          itemName: skill.skill.name,
                          loadImageUrlFunction: getValidSkillImageUrl,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
                        color: Colors.grey[600],
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
        return AppColors.goldSoft;
      case 8:
        return Colors.pink[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
