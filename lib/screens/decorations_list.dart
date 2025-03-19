import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/providers/decorations_provider.dart';

class DecorationsList extends StatefulWidget {
  const DecorationsList({super.key});

  @override
  _DecorationsListState createState() => _DecorationsListState();
}

class _DecorationsListState extends State<DecorationsList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<DecoProvider>(
      builder: (context, decoProvider, child) {
        List<Deco> filteredDecorations =
            decoProvider.filterDecos(name: _searchQuery);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDecorations.length,
                itemBuilder: (context, index) {
                  final decoration = filteredDecorations[index];

                  return Ccard(
                    cardData: decoration,
                    cardTitle: decoration.name,
                    cardBody: _decorationBody(decoration.skills),
                    cardSubtitle1: formatString(decoration.rarity),
                    cardSubtitle2:
                        "${formatString(decoration.slot)}level: ${decoration.skills[0].skillLevel}",
                    cardSubtitle1Label: "Rarity: ",
                    cardSubtitle2Label: "Slot: ",
                    leading: _decorationLeading(
                        decoration.name,
                        int.parse(formatString(decoration.slot)),
                        decoration.skills),
                    trailing: getJewelSlotIcon(decoration.slot),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _decorationBody(List<Skill> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skills.map((skill) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${skill.skillName} +${skill.skillLevel}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _decorationLeading(String name, int slot, List<Skill> skills) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: skills.map((skill) {
        return FutureBuilder<String?>(
          future: getSkillUrl(name, slot, skills[0].skillLevel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: 28,
                height: 28,
                child: FadeIn(
                  child:
                      Image.asset('assets/imgs/decorations/default_jewel.png'),
                ),
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return SizedBox(
                width: 28,
                height: 28,
                child: FadeIn(
                  child:
                      Image.asset('assets/imgs/decorations/default_jewel.png'),
                ),
              );
            } else {
              return SizedBox(
                width: 28,
                height: 28,
                child: FadeIn(child: Image.network(snapshot.data!)),
              );
            }
          },
        );
      }).toList(),
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
