import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
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

    return Scaffold(
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
                dropdownColor: Colors.white,
                value: _selectedType,
                hint: const Text('Select Type'),
                onChanged: (newType) {
                  setState(() {
                    _selectedType = newType;
                  });

                  skillsProvider.applyFilters(
                      kind: _selectedType?.toLowerCase());
                },
                items: ['Weapon', 'Armor', 'Group', 'Set'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(type),
                        Image.asset(
                          _getSkillImage(type.toLowerCase()),
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
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
                        from: 200,
                        child: CustomCard(
                          body: _SkillBody(
                            skill: skill,
                            skillDescription: skill.description,
                          ),
                          title: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: UrlImageLoader(
                                  itemName: skill.name,
                                  loadImageUrlFunction: getValidSkillImageUrl,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    skill.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Image.asset(
                                _getSkillImage(skill.kind),
                                width: 30,
                                height: 30,
                              ),
                            ],
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
        child: Icon(
          _filtersVisible ? Icons.close : Icons.search,
        ),
      ),
    );
  }
}

String _getSkillImage(String skillKind) {
  switch (skillKind) {
    case 'weapon':
      return 'assets/imgs/weapons/artian.webp';
    case 'armor':
      return 'assets/imgs/drawer/armor.webp';
    case 'group':
      return 'assets/imgs/armor/chest/group_armor.webp';
    case 'set':
      return 'assets/imgs/armor/chest/set_armor.webp';
    default:
      return 'assets/imgs/weapons/artian.webp';
  }
}

class _SkillBody extends StatelessWidget {
  const _SkillBody({
    required this.skill,
    this.skillDescription = '-',
  });

  final Skills skill;
  final String skillDescription;

  @override
  Widget build(BuildContext context) {
    final ranks = skill.ranks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          skillDescription,
          // overflow: TextOverflow.ellipsis,
          softWrap: true,
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
                    rank.description,
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
