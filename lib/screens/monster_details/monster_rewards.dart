import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
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
                          ...filteredConditions.map<Widget>((condition) {
                            final String formattedKind = condition.kind
                                .replaceAll('-', ' ')
                                .split(' ')
                                .map((word) =>
                                    word[0].toUpperCase() + word.substring(1))
                                .join(' ');

                            // Determinar si es tempered o arch-tempered
                            final bool isTempered = condition.kind
                                .toLowerCase()
                                .contains('tempered');
                            final bool isArchTempered = condition.kind
                                .toLowerCase()
                                .contains('arch-tempered');

                            // Colores según el tipo de condición
                            Color conditionColor;
                            Color borderColor;
                            Color backgroundColor;

                            if (isArchTempered) {
                              conditionColor = Colors.orange[700]!;
                              borderColor =
                                  Colors.orange.withValues(alpha: 0.6);
                              backgroundColor =
                                  Colors.orange.withValues(alpha: 0.1);
                            } else if (isTempered) {
                              conditionColor = Colors.purple[700]!;
                              borderColor =
                                  Colors.purple.withValues(alpha: 0.6);
                              backgroundColor =
                                  Colors.purple.withValues(alpha: 0.1);
                            } else {
                              conditionColor = colorScheme.onSurface;
                              borderColor = colorScheme.outlineVariant;
                              backgroundColor =
                                  colorScheme.surfaceContainerHighest;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: borderColor,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Porcentaje destacado
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldSoft,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.goldSoft
                                              .withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      "${condition.chance}%",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onPrimary),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Tipo de condición
                                  Expanded(
                                    child: Text(
                                      formattedKind,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: conditionColor,
                                              fontWeight: FontWeight.w500),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
