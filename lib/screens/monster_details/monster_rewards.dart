import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/drop_chance_row.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/spacing.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final List<Reward> filteredRewards = rewards
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

              final uniqueConditions = <String, RewardCondition>{};
              for (var condition in reward.conditions) {
                uniqueConditions[condition.kind] = condition;
              }

              final filteredConditions = uniqueConditions.values.toList();

              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con imagen y nombre del material
                          Row(
                            children: [
                              // Imagen del material
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: MaterialImage(
                                    item: reward.item,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Nombre del material
                              Expanded(
                                child: Text(
                                  reward.item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Lista de condiciones
                          DropChanceTable(rows: [
                            for (final c in filteredConditions)
                              (chance: c.chance, kind: c.kind),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
