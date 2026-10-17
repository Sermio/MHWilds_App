import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/drop_chance_row.dart';
import 'package:mhwilds_app/components/app_bar_background.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/components/monster_icon.dart';
import 'package:mhwilds_app/providers/items_provider.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/spacing.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allMonsters = context.watch<MonstersProvider>().allMonsters;
    final itemsProvider = context.watch<ItemsProvider>();

    if (!itemsProvider.hasData && !itemsProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ItemsProvider>().fetchItems();
      });
    }
    final Map<int, Item> itemsById = {
      for (final itemData in itemsProvider.allItems) itemData.id: itemData,
    };

    final monstersWithItem = allMonsters.where((monster) {
      return monster.rewards.any((reward) => reward.item.id == item.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const AppBarBackground(),
        title: Text(item.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del item
            Center(
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.lg),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    // Imagen del item
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: MaterialImage(item: item),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nombre del item
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Descripción del item
                    if (item.description.isNotEmpty) ...[
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.8), height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Sección de recetas de crafting
            if (item.recipes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  AppLocalizations.of(context)!.craftingRecipe,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Icon(
                          Icons.construction,
                          size: 20,
                          color: colorScheme.primary,
                        ), const SizedBox(width: 8), Flexible(child: Text(
                          AppLocalizations.of(context)!.requiredMaterials,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.8)),
                        ))]),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ...item.recipes.first.inputs
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final recipeItem = entry.value;
                          final isLast =
                              index == item.recipes.first.inputs.length - 1;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Sin fondo opaco: los PNG llevan transparencia
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: MaterialImage(
                                    item: itemsById[recipeItem.id],
                                    width: 48,
                                    height: 48,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Nombre del material
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 170),
                                child: Text(
                                  recipeItem.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500),
                                ),
                              ),
                              // Símbolo "+" si no es el último
                              if (!isLast) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        colorScheme.onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Sección de monstruos que dan este item
            if (monstersWithItem.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  AppLocalizations.of(context)!.monstersThatDropThisItem,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...monstersWithItem.map((monster) {
                final relatedRewards = monster.rewards
                    .where((reward) => reward.item.id == item.id)
                    .toList();

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header del monstruo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (monster.name.isNotEmpty)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  child: MonsterIcon(monster.id,
                                      placeholderIconSize: 20),
                                ),
                              ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                monster.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Condiciones de obtención
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.dropConditions,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.8)),
                            ),
                            const SizedBox(height: 16),
                            DropChanceTable(rows: [
                              for (final c in relatedRewards
                                  .expand((reward) => reward.conditions))
                                (chance: c.chance, kind: c.kind),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
