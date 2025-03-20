// MonsterDetailsCard.dart

import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/c_chip.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonsterDetailsCard extends StatelessWidget {
  final Monster monster;

  const MonsterDetailsCard({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                monster.monsterName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(monster.monsterSpecie),
                  const SizedBox(height: 15),
                  const Divider(
                    color: Colors.black,
                  ),
                  Row(
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
                    children: [
                      const Text(
                        "Species: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        monster.monsterSpecie,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(monster.locations[0]),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 2.0,
                    children: monster.locations.map((loc) {
                      return Cchip(
                        // item: monster,
                        // chipItem: loc,
                        itemName: loc ?? "a",
                        getItemColor: zoneBackgroundColor,
                        optionalWidget: Image.asset(
                          'assets/imgs/maps/map.png',
                          width: 16,
                          height: 16,
                          color: const Color.fromARGB(255, 120, 115, 115),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
