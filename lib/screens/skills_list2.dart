import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/data/skills2.dart'; // asegúrate que tienes una lista aquí
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final filteredSkills = skills2.where((skill) {
      final nameMatches = (skill['names'] as Map<String, String>).values.any(
          (name) =>
              name.toLowerCase().contains(_searchNameQuery.toLowerCase()));

      final typeMatches = _selectedType == null ||
          (skill['kind']?.toString().toLowerCase() ==
              _selectedType!.toLowerCase());

      return nameMatches && typeMatches;
    }).toList();

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
            child: ListView.builder(
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
                            (skill['names'] as Map<String, dynamic>?)?['en'] ??
                                "Unknown",
                        loadImageUrlFunction: getValidSkillImageUrl,
                      ),
                    ),
                    cardData: skill,
                    cardBody: _SkillBody(
                      skill: skill,
                      skillDescription: (skill['descriptions']
                              as Map<String, dynamic>?)?['en'] ??
                          "-",
                    ),
                    cardTitle:
                        (skill['names'] as Map<String, dynamic>?)?['en'] ??
                            "Unknown",

                    // cardSubtitle1Label: "Type: ",
                    // cardSubtitle2Label: "descriptions: ",
                    // cardSubtitle1: skill['kind']?.toString() ?? "Unknown",
                    // cardSubtitle2: (skill['descriptions']
                    //         as Map<String, dynamic>?)?['en'] ??
                    //     "Unknown",
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

  final Map<String, Object> skill;
  final String skillDescription;

  @override
  Widget build(BuildContext context) {
    final ranks = (skill['ranks'] as List<dynamic>?) ?? [];

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
          final description = (rank as Map<String, dynamic>)['descriptions']
                  ?['en'] ??
              'No description';

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
                    description,
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
