import 'package:flutter/material.dart';
import 'package:mhwilds_app/data/monsters.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/widgets/c_card.dart';

class MonsterScreen extends StatelessWidget {
  const MonsterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: monsters.length,
        itemBuilder: (context, index) {
          String monsterKey = monsters.keys.elementAt(index);
          Map<String, dynamic> monster = monsters[monsterKey]!;

          Monster monsterData = Monster(
            monsterName: monster["monsterName"] ?? "Unknown",
            monsterType: monster["monsterType"] ?? "Unknown",
            monsterSpecie: monster["monsterSpecie"] ?? "Unknown",
            elements: List<String>.from(monster["elements"] ?? []),
            ailments: List<String>.from(monster["ailments"] ?? []),
            weaknesses: List<String>.from(monster["weaknesses"] ?? []),
            resistances: List<String>.from(monster["resistances"] ?? []),
            locations: List<String>.from(monster["locations"] ?? []),
          );
          return Ccard(
            cardData: monsterData,
            cardTitle: monsterData.monsterName,
            // cardBody: const Text("body"),
            cardSubtitle1Label: "Type: ",
            cardSubtitle2Label: "Specie: ",
            cardSubtitle1: monsterData.monsterType,
            cardSubtitle2: monsterData.monsterSpecie,
            // leading: ,
            // trailing: getJewelSlotIcon(monsterData.slot),
          );
        },
      ),
    );
  }
}
