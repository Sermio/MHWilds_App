import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/utils/utils.dart';

class MonsterDetails extends StatelessWidget {
  const MonsterDetails({super.key, required this.monster});

  final Monster monster;

  @override
  Widget build(BuildContext context) {
    // final List<Weakness> elementWeakness =
    //     getElementWeakness(monster.weaknesses);
    // final List<Weakness> ailmentsWeakness =
    //     getAilmentsWeakness(monster.weaknesses);

    return Scaffold(
      appBar: AppBar(
        title: Text('${monster.monsterName} details'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: FadeIn(
                      child: Image.asset(
                          'assets/imgs/monsters/${monster.monsterName.toLowerCase().replaceAll(' ', '_')}.png'),
                    ),
                  ),
                  MonsterDetailsCard(monster: monster),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconsList(elementWeakness, ailmentsWeakness),
                      Icon(Icons.abc)
                    ],
                  ),
                  const SizedBox(height: 120),
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
