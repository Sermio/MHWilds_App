import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final allMonsters = context.watch<MonstersProvider>().allMonsters;

    final monstersWithItem = allMonsters.where((monster) {
      return monster.rewards.any((reward) => reward.item.id == item.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                width: 60,
                height: 60,
                child: MaterialImage(materialName: item.name),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(item.description),
              ),
              const SizedBox(height: 24),
              if (monstersWithItem.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...monstersWithItem.map((monster) {
                      final relatedRewards = monster.rewards
                          .where((reward) => reward.item.id == item.id)
                          .toList();

                      return CustomCard(
                        shadowColor: AppColors.goldSoft,
                        title: Row(
                          children: [
                            if (monster.name.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Image.asset(
                                    width: 30,
                                    height: 30,
                                    'assets/imgs/monster_icons/${monster.name.toLowerCase().replaceAll(' ', '_')}.png'),
                              ),
                            const SizedBox(
                              width: 50,
                            ),
                            Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        body: Column(
                          children: relatedRewards.map((reward) {
                            final filteredConditions = reward.conditions;
                            return Column(
                              children: filteredConditions.map((condition) {
                                String formattedKind = condition.kind
                                    .replaceAll('-', ' ')
                                    .split(' ')
                                    .map((word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1))
                                    .join(' ');

                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: [
                                      const Divider(color: Colors.black),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: Text(
                                              "${condition.chance}%",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 40),
                                          Text(
                                            formattedKind,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
