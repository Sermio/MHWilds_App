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
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredDecorationKeys =
        decorations.keys.where((decorationKey) {
      Map<String, dynamic> decorationMap = decorations[decorationKey]!;
      DecorationItem decoration = DecorationItem.fromMap(decorationMap);

      return decoration.decorationName
          .toLowerCase()
          .contains(_searchNameQuery.toLowerCase());
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
              itemCount: filteredDecorationKeys.length,
              itemBuilder: (context, index) {
                String decorationKey = filteredDecorationKeys[index];
                Map<String, dynamic> decorationMap =
                    decorations[decorationKey]!;
                DecorationItem decoration =
                    DecorationItem.fromMap(decorationMap);

                return Ccard(
                  leading: _decorationLeading(decoration.decorationName,
                      decoration.decorationSlot, decoration.decorationSkill),
                  trailing: getJewelSlotIcon(decoration.decorationSlot),
                  cardData: decoration,
                  cardTitle: decoration.decorationName ?? "Unknown",
                  cardSubtitle1Label: "Type: ",
                  cardSubtitle2Label: "Rarity: ",
                  cardSubtitle1: decoration.decorationType ?? "Unknown",
                  cardSubtitle2: decoration.decorationRarity ?? "Unknown",
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

  // Widget _decorationLeading(String name, int slot, List<String> skills) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: skills.map((skill) {
  //       return FutureBuilder<String?>(
  //         future: getSkillUrl(name, slot, skills[0].skillLevel),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return SizedBox(
  //               width: 28,
  //               height: 28,
  //               child: FadeIn(
  //                 child:
  //                     Image.asset('assets/imgs/decorations/default_jewel.png'),
  //               ),
  //             );
  //           } else if (snapshot.hasError ||
  //               !snapshot.hasData ||
  //               snapshot.data == null) {
  //             return SizedBox(
  //               width: 28,
  //               height: 28,
  //               child: FadeIn(
  //                 child:
  //                     Image.asset('assets/imgs/decorations/default_jewel.png'),
  //               ),
  //             );
  //           } else {
  //             return SizedBox(
  //               width: 28,
  //               height: 28,
  //               child: FadeIn(child: Image.network(snapshot.data!)),
  //             );
  //           }
  //         },
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _decorationLeading(
      String skillName, String decorationSlot, String skillsString) {
    // Dividir el string de habilidades por '\\n\\'
    final skills = skillsString.split('\\n\\');
    final skillLevel = skillName[skillName.length - 1];
    final slot = decorationSlot[decorationSlot.length - 1];

    // Obtener solo la primera habilidad
    final firstSkill = skills.isNotEmpty ? skills[0] : '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<String?>(
          future:
              getSkillUrl(skillName, int.parse(slot), int.parse(skillLevel)),
          builder: (context, snapshot) {
            Widget child;

            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              child = FadeIn(
                child: Image.asset('assets/imgs/decorations/default_jewel.png'),
              );
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
