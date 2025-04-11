import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/screens/skill_details.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
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
                  decorationsProvider.applyFilters(
                      name: _searchNameQuery, type: _selectedType);
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
                  decorationsProvider.applyFilters(
                      name: _searchNameQuery, type: _selectedType);
                },
                items: ['Weapon', 'Armor'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(type),
                        Image.asset(
                          "assets/imgs/${type == 'Weapon' ? 'weapons/artian' : 'drawer/armor'}.webp",
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
            const Divider(color: Colors.black)
          ],
          Expanded(
            child: decorationsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredDecorations.length,
                    itemBuilder: (context, index) {
                      var decoration = filteredDecorations[index];

                      return BounceInLeft(
                        duration: const Duration(milliseconds: 900),
                        delay: Duration(milliseconds: index * 5),
                        child: CustomCard(
                          onTap: () {
                            final skillIds = decoration.skills
                                .map((s) => s.skill.id)
                                .toList();
                            final skillLevels =
                                decoration.skills.map((s) => s.level).toList();

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
                          title: _CardTitle(decoration: decoration),
                          body: _CardBody(
                            decoration: decoration,
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

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.decoration,
  });

  final DecorationItem decoration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: getJewelSlotIcon(decoration.slot),
        ),
        Expanded(
          child: Center(
            child: Text(
              decoration.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Image.asset(
          getTypeImage(decoration.kind),
          width: 30,
          height: 30,
        ),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.decoration,
  });

  final DecorationItem decoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: decoration.skills.map((skill) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: UrlImageLoader(
                    itemName: skill.skill.name,
                    loadImageUrlFunction: getValidSkillImageUrl,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(skill.skill.name),
                const SizedBox(width: 10),
                Text('Lv: ${skill.level}'),
              ],
            ),
            Wrap(
              children: [
                Text(skill.description),
              ],
            )
          ],
        );
      }).toList(),
    );
  }
}
