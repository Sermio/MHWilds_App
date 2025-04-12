import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';

class MonsterDetails extends StatefulWidget {
  final Monster monster;

  const MonsterDetails({super.key, required this.monster});

  @override
  // ignore: library_private_types_in_public_api
  _MonsterDetailsState createState() => _MonsterDetailsState();
}

class _MonsterDetailsState extends State<MonsterDetails> {
  String selectedRank = 'low';
  bool isLowRankAvailable = false;
  bool isHighRankAvailable = false;

  void checkAvailableRanks() {
    bool lowAvailable = false;
    bool highAvailable = false;

    for (var reward in widget.monster.rewards) {
      for (var condition in reward.conditions) {
        if (condition.rank == 'low') {
          lowAvailable = true;
        }
        if (condition.rank == 'high') {
          highAvailable = true;
        }
      }
    }

    if (!lowAvailable && highAvailable) {
      setState(() {
        selectedRank = 'high';
      });
    } else if (!highAvailable && lowAvailable) {
      setState(() {
        selectedRank = 'low';
      });
    }

    setState(() {
      isLowRankAvailable = lowAvailable;
      isHighRankAvailable = highAvailable;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAvailableRanks();
  }

  void _onRankChanged(int index) {
    setState(() {
      selectedRank = index == 0 ? 'low' : 'high';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.monster.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.monster.name,
              child: Image.asset(
                'assets/imgs/monsters/${widget.monster.name.toLowerCase().replaceAll(' ', '_')}.png',
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: MonsterDetailsCard(monster: widget.monster),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ToggleButtons(
                fillColor: AppColors.goldSoft,
                borderRadius: BorderRadius.circular(10),
                disabledColor: Colors.grey,
                isSelected: [
                  selectedRank == 'low' && isLowRankAvailable,
                  selectedRank == 'high' && isHighRankAvailable,
                ],
                onPressed: (index) {
                  if ((index == 0 && isLowRankAvailable) ||
                      (index == 1 && isHighRankAvailable)) {
                    _onRankChanged(index);
                  }
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Low',
                      style: TextStyle(
                        color: isLowRankAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'High',
                      style: TextStyle(
                        color: isHighRankAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: MonsterRewards(
                rewards: widget.monster.rewards,
                selectedRank: selectedRank,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class MonsterRewards extends StatelessWidget {
  final List<Reward> rewards;
  final String selectedRank;

  const MonsterRewards({
    super.key,
    required this.rewards,
    required this.selectedRank,
  });

  @override
  Widget build(BuildContext context) {
    List<Reward> filteredRewards = rewards
        .where((reward) => reward.conditions
            .any((condition) => condition.rank == selectedRank))
        .toList();

    return filteredRewards.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRewards.length,
            itemBuilder: (context, index) {
              final reward = filteredRewards[index];

              var uniqueConditions = <String, RewardCondition>{};
              for (var condition in reward.conditions) {
                uniqueConditions[condition.kind] = condition;
              }

              var filteredConditions = uniqueConditions.values.toList();

              return CustomCard(
                shadowColor: AppColors.goldSoft,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetails(
                        item: reward.item,
                      ),
                    ),
                  );
                },
                title: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        // child: MaterialImage(
                        //   materialName: reward.item.name,
                        // ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      reward.item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    ...filteredConditions
                        .map<Widget>((RewardCondition condition) {
                      String formattedKind = condition.kind
                          .replaceAll('-', ' ')
                          .split(' ')
                          .map((word) =>
                              word[0].toUpperCase() + word.substring(1))
                          .join(' ');

                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    "${condition.chance.toString()}%",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Text(
                                  formattedKind,
                                  softWrap: true,
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
                    }),
                  ],
                ),
              );
            },
          )
        : const SizedBox();
  }
}
