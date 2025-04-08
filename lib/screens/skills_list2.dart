import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/skills_provider.dart';

class SkillList2 extends StatefulWidget {
  const SkillList2({super.key});

  @override
  _SkillListState2 createState() => _SkillListState2();
}

class _SkillListState2 extends State<SkillList2> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedType;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    // Usar addPostFrameCallback para ejecutar la llamada después de que el marco termine de construir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final skillsProvider =
          Provider.of<SkillsProvider>(context, listen: false);

      // Verificar si los datos ya están cargados en el provider, si no, cargarlos
      if (skillsProvider.skills.isEmpty) {
        skillsProvider
            .fetchSkills(); // Llamar al método que obtiene los datos de la API
      }
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

    // Restablecer los filtros en el provider
    Provider.of<SkillsProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final skillsProvider = Provider.of<SkillsProvider>(context);
    final filteredSkills = skillsProvider.skills;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill2 List'),
      ),
      body: Column(
        children: [
          if (_filtersVisible) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchNameController,
                onChanged: (query) {
                  setState(() {
                    _searchNameQuery = query;
                  });

                  // Aplicar el filtro de nombre
                  skillsProvider.applyFilters(name: _searchNameQuery);
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedType,
                hint: const Text('Select Type'),
                onChanged: (newType) {
                  setState(() {
                    _selectedType = newType;
                  });

                  // Aplicar el filtro de tipo
                  skillsProvider.applyFilters(
                      kind: _selectedType?.toLowerCase());
                },
                items: ['Weapon', 'Armor', 'Group', 'Set'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
            const Divider(color: Colors.black),
          ],
          Expanded(
            child: skillsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = filteredSkills[index];

                      return BounceInLeft(
                        duration: const Duration(milliseconds: 900),
                        delay: Duration(milliseconds: index * 5),
                        child: Ccard(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: UrlImageLoader(
                              itemName:
                                  skill.name, // Acceder a name directamente
                              loadImageUrlFunction: getValidSkillImageUrl,
                            ),
                          ),
                          cardData: skill,
                          cardBody: _SkillBody(
                            skill: skill,
                            skillDescription: skill
                                .description, // Usar description directamente
                          ),
                          cardTitle: skill.name, // Acceder a name directamente
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.search,
        ),
      ),
    );
  }
}

class _SkillBody extends StatelessWidget {
  const _SkillBody({
    super.key,
    required this.skill,
    this.skillDescription = '-',
  });

  final Skill2 skill;
  final String skillDescription;

  @override
  Widget build(BuildContext context) {
    final ranks = skill.ranks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          skillDescription,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        ...ranks.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final rank = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level $index: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    rank.description, // Acceder a description directamente
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
