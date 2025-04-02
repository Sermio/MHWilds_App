import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/decorations.dart';

class DecorationsList extends StatefulWidget {
  const DecorationsList({super.key});

  @override
  _DecorationsListState createState() => _DecorationsListState();
}

class _DecorationsListState extends State<DecorationsList> {
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
    List<String> filteredDecorationKeys =
        decorations.keys.where((decorationKey) {
      Map<String, dynamic> decorationMap = decorations[decorationKey]!;
      DecorationItem decoration = DecorationItem.fromMap(decorationMap);

      bool matchesName = decoration.decorationName
          .toLowerCase()
          .contains(_searchNameQuery.toLowerCase());

      bool matchesType =
          _selectedType == null || decoration.decorationType == _selectedType;

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
                items: ['Armor Decoration', 'Weapon Decoration'].map((type) {
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              itemCount: filteredDecorationKeys.length,
              itemBuilder: (context, index) {
                String decorationKey = filteredDecorationKeys[index];
                Map<String, dynamic> decorationMap =
                    decorations[decorationKey]!;
                DecorationItem decoration =
                    DecorationItem.fromMap(decorationMap);

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                    leading: _decorationLeading(decoration.decorationName,
                        decoration.decorationSlot, decoration.decorationSkill),
                    trailing: getJewelSlotIcon(decoration.decorationSlot),
                    cardData: decoration,
                    cardTitle: decoration.decorationName ?? "Unknown",
                    cardSubtitle1Label: "Type: ",
                    cardSubtitle2Label: "Rarity: ",
                    cardSubtitle1: decoration.decorationType ?? "Unknown",
                    cardSubtitle2: decoration.decorationRarity ?? "Unknown",
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
