import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:provider/provider.dart';
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
    final itemsProvider = Provider.of<ItemsProvider>(context);
    final filteredItems = itemsProvider.items;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Filtros mejorados
          if (_filtersVisible) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
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
                      const Icon(Icons.filter_list, color: AppColors.goldSoft),
                      const SizedBox(width: 8),
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reset'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.goldSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Campo de búsqueda por nombre
                  TextField(
                    controller: _searchNameController,
                    onChanged: (query) {
                      setState(() {
                        _searchNameQuery = query;
                      });
                      itemsProvider.applyFilters(name: _searchNameQuery);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search by Name',
                      hintText: 'Enter item name...',
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.goldSoft),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.goldSoft, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filtro de rareza
                  const Text(
                    'Rarity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
                      return FilterChip(
                        label: Text(
                          'Rarity $rarity',
                          style: TextStyle(
                            color: _selectedRarity == rarity
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor:
                            _getRarityColor(rarity).withOpacity(0.2),
                        selectedColor: _getRarityColor(rarity),
                        selected: _selectedRarity == rarity,
                        onSelected: (isSelected) {
                          setState(() {
                            _selectedRarity = isSelected ? rarity : null;
                          });
                          itemsProvider.applyFilters(rarity: _selectedRarity);
                        },
                        elevation: 2,
                        pressElevation: 4,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          // Lista de items
          Expanded(
            child: itemsProvider.isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.goldSoft),
                        SizedBox(height: 16),
                        Text(
                          'Loading items...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
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
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
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

                          return BounceInLeft(
                            duration: const Duration(milliseconds: 600),
                            delay: Duration(milliseconds: index * 50),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
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
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.goldSoft
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: MaterialImage(
                                                  materialName: item.name,
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
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black87,
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
                                                      'Rarity ${item.rarity}',
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
                                              color: Colors.grey[400],
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
                                              color: Colors.grey[600],
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 16),
                                        ],

                                        // Recetas
                                        if (item.recipes.isNotEmpty) ...[
                                          _buildRecipesSection(item),
                                        ],
                                      ],
                                    ),
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
        backgroundColor: AppColors.goldSoft,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRecipesSection(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.construction,
              size: 16,
              color: Colors.blue[400],
            ),
            const SizedBox(width: 6),
            Text(
              'Crafting Recipe:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: item.recipes.first.inputs.map((recipeItem) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                recipeItem.name,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.green[400]!;
      case 3:
        return Colors.blue[400]!;
      case 4:
        return Colors.purple[400]!;
      case 5:
        return Colors.orange[400]!;
      case 6:
        return Colors.red[400]!;
      case 7:
        return AppColors.goldSoft;
      case 8:
        return Colors.pink[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
