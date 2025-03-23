// MonsterDetailsCard.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/data/ailments.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonsterDetailsCard extends StatelessWidget {
  final Monster monster;

  const MonsterDetailsCard({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Type: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  monster.monsterType,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Species: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  monster.monsterSpecies,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              color: Colors.black,
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MonsterAttributes(
                      attributeType: 'Elements',
                      attributeList: monster.elements,
                    ),
                    MonsterAttributes(
                      attributeType: 'Ailments',
                      attributeList: monster.ailments,
                    ),
                  ],
                ),
                Positioned(
                    right: 10,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.info_outline,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Center(
                              child: Text(
                                'Elements/Ailments',
                              ),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: _ElementsAndAilments(),
                            ),
                          ),
                        );
                      },
                    )),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MonsterAttributes(
                  attributeType: 'Weaknesses',
                  attributeList: monster.weaknesses,
                ),
                MonsterAttributes(
                  attributeType: 'Resistances',
                  attributeList: monster.resistances,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              color: Colors.black,
            ),
            const Text(
              'Locations',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 2.0,
              children: monster.locations?.asMap().entries.map((entry) {
                    int index = entry.key;
                    String loc = entry.value;
                    return Bounce(
                      from: 10,
                      delay: Duration(milliseconds: index * 100),
                      child: Cchip(
                        itemName: loc ?? "",
                        getItemColor: zoneBackgroundColor,
                        optionalWidget: Image.asset(
                          'assets/imgs/maps/map.png',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.black,
            ),
            const Text(
              'Tips',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Wrap(
                children: [
                  Text(monster.tips),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ElementsAndAilments extends StatelessWidget {
  const _ElementsAndAilments({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ailments.length,
      itemBuilder: (context, index) {
        String ailmentName = ailments[index].keys.first;
        String description = ailments[index][ailmentName] ?? "";

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            title: Row(
              children: [
                SizedBox(
                  height: 25,
                  child: Image.asset(
                    'assets/imgs/elements/${ailmentName.toLowerCase()}.webp',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ailmentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            subtitle: Text(description),

            // Text(
            //     ailmentName,
            //     style: const TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18,
            //     ),
            //   ),
            //   const SizedBox(height: 5),
            //   Text(description),
          ),
        );
      },
    );
  }
}

class MonsterAttributes extends StatelessWidget {
  const MonsterAttributes(
      {super.key, required this.attributeType, this.attributeList});

  final String attributeType;
  final List<String>? attributeList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          attributeType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        attributeList != null && attributeList!.isNotEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: attributeList!
                    .map((attr) => SizedBox(
                          height: 25,
                          child: Image.asset(
                            'assets/imgs/elements/${attr.toLowerCase()}.webp',
                          ),
                        ))
                    .toList(),
              )
            : const SizedBox(
                height: 25,
                child: Center(child: Text("None")),
              ),
      ],
    );
  }
}
