import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/filter_panel.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';

class SkillList extends StatefulWidget {
  const SkillList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SkillListState2 createState() => _SkillListState2();
}

class _SkillListState2 extends State<SkillList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedType;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      if (skillsProvider.skills.isEmpty) {
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
      _searchNameController.clear();
      _selectedType = null;
    });

    Provider.of<SkillsProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final skillsProvider = Provider.of<SkillsProvider>(context);
    final filteredSkills = skillsProvider.skills;
    final colorScheme = Theme.of(context).colorScheme;

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
                      skillsProvider.applyFilters(name: _searchNameQuery);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      hintText: 'Enter skill name...',
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

                  // Filtro de tipo
                  Text(
                    'Type',
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
                    children: ['Weapon', 'Armor', 'Group', 'Set'].map((type) {
                      return FilterChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color: _selectedType == type
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
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
                          skillsProvider.applyFilters(
                              kind: _selectedType?.toLowerCase());
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

          // Lista de habilidades
          Expanded(
            child: skillsProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Loading skills...',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredSkills.isEmpty
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
                              'No skills found',
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
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
                        itemCount: filteredSkills.length,
                        itemBuilder: (context, index) {
                          final skill = filteredSkills[index];

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SkillDetails(
                                        skillsIds: [skill.id],
                                        skillsLevels: [1],
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
                                      // Header de la habilidad
                                      Row(
                                        children: [
                                          // Icono de la habilidad
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: colorScheme.primary
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: UrlImageLoader(
                                                itemName: skill.name,
                                                loadImageUrlFunction:
                                                    getValidSkillImageUrl,
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
                                                  skill.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color:
                                                        colorScheme.onSurface,
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
                                                            skill.kind)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: _getTypeColor(
                                                              skill.kind)
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    skill.kind,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _getTypeColor(
                                                          skill.kind),
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

                                      // Descripción
                                      if (skill.description.isNotEmpty) ...[
                                        Text(
                                          skill.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                            height: 1.4,
                                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
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
