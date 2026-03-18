import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/items_provider.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  int? _selectedRarity;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);

      if (itemsProvider.items.isEmpty) {
        itemsProvider.fetchItems();
      }
      _resetFilters();
    });
  }

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _searchNameController.clear();
      _selectedRarity = null;
    });

    Provider.of<ItemsProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemsProvider = Provider.of<ItemsProvider>(context);
    final filteredItems = itemsProvider.items;
    final Map<int, Item> itemsById = {
      for (final itemData in itemsProvider.allItems) itemData.id: itemData,
    };
    final colorScheme = Theme.of(context).colorScheme;

    if (!itemsProvider.hasData && !itemsProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<ItemsProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchItems();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          if (_filtersVisible) _buildFiltersSection(context, itemsProvider),

          // Lista de items
          Expanded(
            child: itemsProvider.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingItems,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noItemsFound,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.tryAdjustingFilters,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemDetails(
                                        item: item,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header del item
                                      Row(
                                        children: [
                                          // Imagen del material
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: MaterialImage(
                                                item: item,
                                                materialName:
                                                    (Provider.of<EnNamesCache>(
                                                                context,
                                                                listen: false)
                                                            .nameForItemImage(
                                                                item.id,
                                                                item.name) ??
                                                        item.name),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getRarityColor(
                                                            item.rarity)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: _getRarityColor(
                                                              item.rarity)
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    l10n.rarityLevel(
                                                        item.rarity),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _getRarityColor(
                                                          item.rarity),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.5),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Descripción
                                      if (item.description.isNotEmpty) ...[
                                        Text(
                                          item.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 16),
                                      ],

                                      // Recetas
                                      if (item.recipes.isNotEmpty) ...[
                                        _buildRecipesSection(
                                            context, item, itemsById),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    ItemsProvider itemsProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ListFiltersPanel(
      height: 250,
      title: l10n.filters,
      resetLabel: l10n.reset,
      onReset: _resetFilters,
      fields: [
        ListFilterFieldConfig.text(
          id: 'name',
          label: l10n.searchByName,
          controller: _searchNameController,
          onTextChanged: (query) {
            setState(() {
              _searchNameQuery = query;
            });
            _applyFilters(itemsProvider);
          },
          hintText: l10n.enterItemName,
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        ),
        ListFilterFieldConfig.select(
          id: 'rarity',
          label: l10n.rarity,
          value: _selectedRarity,
          onSelectChanged: (selectedRarity) {
            setState(() {
              _selectedRarity = selectedRarity as int?;
            });
            _applyFilters(itemsProvider);
          },
          options: [1, 2, 3, 4, 5, 6, 7, 8]
              .map(
                (rarity) => ListFilterOption(
                  value: rarity,
                  label: rarity.toString(),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getRarityColor(rarity),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _applyFilters(ItemsProvider itemsProvider) {
    itemsProvider.applyFilters(
      name: _searchNameQuery,
      rarity: _selectedRarity,
    );
  }

  Widget _buildRecipesSection(
      BuildContext context, Item item, Map<int, Item> itemsById) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.construction,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.craftingRecipe,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ...item.recipes.first.inputs.asMap().entries.map((entry) {
              final index = entry.key;
              final recipeItem = entry.value;
              final isLast = index == item.recipes.first.inputs.length - 1;

              return Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: MaterialImage(
                        item: itemsById[recipeItem.id],
                        materialName:
                            (Provider.of<EnNamesCache>(context, listen: false)
                                    .nameForItemImage(
                                        recipeItem.id, recipeItem.name) ??
                                recipeItem.name),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    recipeItem.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isLast) ...[
                    const SizedBox(width: 8),
                    Text(
                      '+',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Color _getRarityColor(int rarity) {
    return rarityColorFromSprite(rarity);
  }
}
