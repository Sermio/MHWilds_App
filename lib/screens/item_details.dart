import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/monsters_provider.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        child: Column(
          children: [
            // Header del item
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  children: [
                    // Imagen del item
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: MaterialImage(
                            materialName: Provider.of<EnNamesCache>(context,
                                        listen: false)
                                    .nameForItemImage(item.id, item.name) ??
                                item.name),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nombre del item
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Descripción del item
                    if (item.description.isNotEmpty) ...[
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withOpacity(0.8),
                          height: 1.4,
                        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.construction,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.requiredMaterials,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
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
                            children: [
                              // Imagen del material
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorScheme.surfaceContainerHighest,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: MaterialImage(
                                    materialName: Provider.of<EnNamesCache>(
                                                context,
                                                listen: false)
                                            .nameForItemImage(recipeItem.id,
                                                recipeItem.name) ??
                                        recipeItem.name,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Nombre del material
                              Text(
                                recipeItem.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Símbolo "+" si no es el último
                              if (!isLast) ...[
                                const SizedBox(width: 12),
                                Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ],
                          );
                        }).toList(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
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
                          color: colorScheme.primary.withOpacity(0.1),
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
                                  borderRadius: BorderRadius.circular(10),
                                  color: colorScheme.surface,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _buildMonsterIcon(
                                      context, monster.id, monster.name),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...relatedRewards
                                .expand((reward) => reward.conditions)
                                .map((condition) {
                              String formattedKind = condition.kind
                                  .replaceAll('-', ' ')
                                  .split(' ')
                                  .map((word) =>
                                      word[0].toUpperCase() + word.substring(1))
                                  .join(' ');

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${condition.chance}%',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        formattedKind,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMonsterIcon(
      BuildContext context, int monsterId, String monsterName) {
    final enNamesCache = Provider.of<EnNamesCache>(context, listen: false);
    final imageName = enNamesCache.nameForMonsterImage(monsterId, monsterName);

    if (imageName == null) {
      // Cache no cargado, mostrar placeholder
      return Container(
        color: Colors.grey[300],
        child:
            Icon(Icons.image_not_supported, color: Colors.grey[600], size: 20),
      );
    }

    final imagePath =
        'assets/imgs/monster_icons/${imageName.toLowerCase().replaceAll(' ', '_')}.png';
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Si la imagen no existe, mostrar placeholder
        return Container(
          color: Colors.grey[300],
          child: Icon(Icons.image_not_supported,
              color: Colors.grey[600], size: 20),
        );
      },
    );
  }
}
