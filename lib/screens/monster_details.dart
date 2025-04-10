import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/components/monster_parts_tables.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/data/materials_high_rank.dart';
import 'package:mhwilds_app/data/materials_low_rank.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonsterDetails extends StatelessWidget {
  const MonsterDetails({super.key, required this.monster});

  final Monster monster;

  @override
  Widget build(BuildContext context) {
    const List<String> materialColumns = [
      'Image',
      'Material',
      'Target Rewards',
      'Break Part Rewards',
      'Carves',
      'Destroyed Wounds',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(monster.name),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Hero(
                    tag: monster.name,
                    child: Image.asset(
                        'assets/imgs/monsters/${monster.name.toLowerCase().replaceAll(' ', '_')}.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: MonsterDetailsCard(monster: monster),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: MonsterTable(
                      rank: 'Low Rank Materials',
                      columnsTitles: materialColumns,
                      materials: materialsLowRank[monster.name] ?? [],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: MonsterTable(
                      rank: 'High Rank Materials',
                      columnsTitles: materialColumns,
                      materials: materialsHighRank[monster.name] ?? [],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
          // const CbackButton(),
        ],
      ),
    );
  }
}
