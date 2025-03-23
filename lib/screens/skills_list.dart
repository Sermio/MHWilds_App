import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/data/armor_pieces.dart';
import 'package:mhwilds_app/data/skills.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/models/skill.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/decorations.dart';

class SkillsList extends StatefulWidget {
  const SkillsList({super.key});

  @override
  SkillsListState createState() => SkillsListState();
}

class SkillsListState extends State<SkillsList> {
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
    List<String> filteredSkillsKeys = skills.keys.where((skillkey) {
      Map<String, dynamic> skillMap = skills[skillkey]!;
      Skill skill = Skill.fromMap(skillMap);

      bool matchesName =
          skill.name.toLowerCase().contains(_searchNameQuery.toLowerCase());

      bool matchesType = _selectedType == null || skill.type == _selectedType;

      return matchesName && matchesType;
    }).toList();

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
                },
                items: ['Weapon Skill', 'Armor Skill'].map((type) {
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
            const Divider(color: Colors.black)
          ],
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSkillsKeys.length,
              itemBuilder: (context, index) {
                String skillkey = filteredSkillsKeys[index];
                Map<String, dynamic> skillMap = skills[skillkey]!;
                Skill skill = Skill.fromMap(skillMap);

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: UrlImageLoader(
                        itemName: skill.name,
                        loadImageUrlFunction: getValidSkillImageUrl,
                      ),
                    ),
                    // trailing: getJewelSlotIcon(armor_piece.armor_pieceSlot),
                    cardData: skill,
                    cardTitle: skill.name ?? "Unknown",
                    cardSubtitle1Label: "Type: ",
                    cardSubtitle2Label: "Description: ",
                    cardSubtitle1: skill.type ?? "Unknown",
                    cardSubtitle2: skill.description ?? "Unknown",
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: BounceInRight(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: _toggleFiltersVisibility,
          child: Icon(
            _filtersVisible ? Icons.close : Icons.search,
          ),
        ),
      ),
    );
  }

  Widget _decorationLeading(
      String skillName, String decorationSlot, String skillsString) {
    final skills = skillsString.split('\\n\\');
    final skillLevel = skillName[skillName.length - 1];
    final slot = decorationSlot[decorationSlot.length - 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<String?>(
          future: getSkillUrl(skillName, int.parse(slot), int.parse(skillLevel))
              .timeout(const Duration(seconds: 3), onTimeout: () {
            return null;
          }),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              child =
                  Image.asset('assets/imgs/decorations/missing_decoration.png');
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.hasError) {
              child = const CircularProgressIndicator();
            } else {
              child = FadeIn(
                child: Image.network(snapshot.data!),
              );
            }

            return SizedBox(
              width: 28,
              height: 28,
              child: child,
            );
          },
        ),
      ],
    );
  }

  Widget getJewelSlotIcon(String slot) {
    if (slot.contains("1")) {
      return Image.asset('assets/imgs/decorations/gem_level_1.png');
    }
    if (slot.contains("2")) {
      return Image.asset('assets/imgs/decorations/gem_level_2.png');
    }
    if (slot.contains("3")) {
      return Image.asset('assets/imgs/decorations/gem_level_3.png');
    }
    if (slot.contains("4")) {
      return Image.asset('assets/imgs/decorations/gem_level_4.png');
    }
    return Image.asset('assets/imgs/decorations/gem_level_1.png');
  }

  String formatString(String input) {
    int spaceIndex = input.indexOf(' ');

    if (spaceIndex != -1) {
      return input.substring(spaceIndex + 1);
    }

    return input;
  }
}
