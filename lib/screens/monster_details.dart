import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:mhwilds_app/screens/monster_details/monster_breakable_parts_section.dart';
import 'package:mhwilds_app/screens/monster_details/monster_header_image.dart';
import 'package:mhwilds_app/screens/monster_details/monster_info_section.dart';
import 'package:mhwilds_app/screens/monster_details/monster_rank_selector.dart';
import 'package:mhwilds_app/screens/monster_details/monster_rewards.dart';
import 'package:mhwilds_app/screens/monster_details/monster_size_section.dart';
import 'package:mhwilds_app/screens/monster_details/monster_stats_section.dart';
import 'package:mhwilds_app/screens/monster_details/monster_weaknesses_section.dart';
import 'package:provider/provider.dart';

export 'package:mhwilds_app/screens/monster_details/monster_rewards.dart';

class MonsterDetails extends StatefulWidget {
  final int monsterId;

  const MonsterDetails({super.key, required this.monsterId});

  @override
  State<MonsterDetails> createState() => _MonsterDetailsState();
}

class _MonsterDetailsState extends State<MonsterDetails> {
  late Future<Monster> _monsterFuture;
  String selectedRank = 'low';
  bool isLowRankAvailable = false;
  bool isHighRankAvailable = false;

  @override
  void initState() {
    super.initState();
    _monsterFuture =
        context.read<MonstersProvider>().monsterById(widget.monsterId);
  }

  void checkAvailableRanks(Monster monster) {
    bool lowAvailable = false;
    bool highAvailable = false;

    for (var reward in monster.rewards) {
      for (var condition in reward.conditions) {
        if (condition.rank == 'low') lowAvailable = true;
        if (condition.rank == 'high') highAvailable = true;
      }
    }

    if (!lowAvailable && highAvailable) {
      selectedRank = 'high';
    } else if (!highAvailable && lowAvailable) {
      selectedRank = 'low';
    }

    isLowRankAvailable = lowAvailable;
    isHighRankAvailable = highAvailable;
  }

  void _onRankChanged(int index) {
    setState(() {
      selectedRank = index == 0 ? 'low' : 'high';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Monster>(
      future: _monsterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(
                child: Text(l10n.errorWithMessage(snapshot.error.toString()))),
          );
        } else if (!snapshot.hasData) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: Center(child: Text(l10n.monsterNotFound)),
          );
        }

        final monster = snapshot.data!;
        checkAvailableRanks(monster);

        return Scaffold(
          appBar: AppBar(
            title: Text(monster.name),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: monster.name,
                  child: MonsterHeaderImage(
                    monsterId: monster.id,
                    monsterName: monster.name,
                  ),
                ),
                const SizedBox(height: 20),
                MonsterInfoSection(monster: monster),
                const SizedBox(height: 20),
                MonsterStatsSection(monster: monster),
                const SizedBox(height: 20),
                if (monster.size != null)
                  MonsterSizeSection(sizes: monster.size!),
                const SizedBox(height: 20),
                MonsterWeaknessesSection(
                  weaknesses: monster.weaknesses,
                  resistances: monster.resistances,
                ),
                const SizedBox(height: 20),
                if (monster.breakableParts.isNotEmpty) ...[
                  MonsterBreakablePartsSection(parts: monster.breakableParts),
                  const SizedBox(height: 20),
                ],
                MonsterRankSelector(
                  selectedRank: selectedRank,
                  isLowRankAvailable: isLowRankAvailable,
                  isHighRankAvailable: isHighRankAvailable,
                  onRankChanged: _onRankChanged,
                ),
                const SizedBox(height: 20),
                MonsterRewards(
                  rewards: monster.rewards,
                  selectedRank: selectedRank,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
