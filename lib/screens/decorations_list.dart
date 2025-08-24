import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';

class DecorationsList extends StatefulWidget {
  const DecorationsList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DecorationsListState createState() => _DecorationsListState();
}

class _DecorationsListState extends State<DecorationsList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedType;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final decorationsProvider =
          Provider.of<DecorationsProvider>(context, listen: false);

      if (!decorationsProvider.hasData) {
        decorationsProvider.fetchDecorations();
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
      _searchNameController.clear();
      _selectedType = null;
    });
    Provider.of<DecorationsProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final decorationsProvider = Provider.of<DecorationsProvider>(context);
    final filteredDecorations = decorationsProvider.filteredDecorations;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Filtros mejorados
          if (_filtersVisible) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.filter_list, color: AppColors.goldSoft),
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
                  const SizedBox(height: 16),

                  // Campo de búsqueda por nombre
                  TextField(
                    controller: _searchNameController,
                    onChanged: (query) {
                      setState(() {
                        _searchNameQuery = query;
                      });
                      decorationsProvider.applyFilters(
                          name: _searchNameQuery, type: _selectedType);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      hintText: 'Enter decoration name...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.goldSoft),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.goldSoft, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtro de tipo
                  const Text(
                    'Type',
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
                    children: ['Weapon', 'Armor'].map((type) {
                      return FilterChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: _selectedType == type
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: _getTypeColor(type).withOpacity(0.2),
                        selectedColor: _getTypeColor(type),
                        selected: _selectedType == type,
                        onSelected: (isSelected) {
                          setState(() {
                            _selectedType = isSelected ? type : null;
                          });
                          decorationsProvider.applyFilters(
                              name: _searchNameQuery, type: _selectedType);
                        },
                        elevation: 2,
                        pressElevation: 4,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          // Lista de decoraciones
          Expanded(
            child: decorationsProvider.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.goldSoft),
                        SizedBox(height: 16),
                        Text(
                          'Loading decorations...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredDecorations.isEmpty
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
                              'No decorations found',
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
                        itemCount: filteredDecorations.length,
                        itemBuilder: (context, index) {
                          final decoration = filteredDecorations[index];

                          return BounceInLeft(
                            duration: const Duration(milliseconds: 600),
                            delay: Duration(milliseconds: index * 50),
                            child: Container(
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
                                    // Navegar a la pantalla de detalles de habilidades
                                    final skillIds = decoration.skills
                                        .map((s) => s.skill.id)
                                        .toList();
                                    final skillLevels = decoration.skills
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
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header de la decoración
                                        Row(
                                          children: [
                                            // Imagen de la decoración
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
                                                  'assets/imgs/decorations/gem_level_${_getDecorationLevel(decoration.skills)}.png',
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
                                                    decoration.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _getTypeColor(
                                                              decoration.kind)
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: _getTypeColor(
                                                                decoration.kind)
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      decoration.kind,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: _getTypeColor(
                                                            decoration.kind),
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
                                              color: Colors.grey[400],
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        // Habilidades
                                        if (decoration.skills.isNotEmpty) ...[
                                          _buildSkillsSection(decoration),
                                        ],
                                      ],
                                    ),
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

  Widget _buildSkillsSection(DecorationItem decoration) {
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
        ...decoration.skills.map((skill) => Container(
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

  int _getDecorationLevel(List<DecorationSkill> skills) {
    if (skills.isEmpty) return 1;

    // Obtener el nivel más alto de las habilidades
    int maxLevel = skills.map((s) => s.level).reduce((a, b) => a > b ? a : b);

    // Mapear a los niveles de gemas disponibles (1-4)
    if (maxLevel <= 1) return 1;
    if (maxLevel <= 2) return 2;
    if (maxLevel <= 3) return 3;
    return 4;
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
