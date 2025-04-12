import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/item.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
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
      body: Column(
        children: [
          if (_filtersVisible) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchNameController,
                onChanged: (query) {
                  setState(() {
                    _searchNameQuery = query;
                  });

                  itemsProvider.applyFilters(name: _searchNameQuery);
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                value: _selectedRarity,
                hint: const Text('Select Rarity'),
                onChanged: (newRarity) {
                  setState(() {
                    _selectedRarity = newRarity;
                  });

                  itemsProvider.applyFilters(rarity: _selectedRarity);
                },
                items: [1, 2, 3, 4, 5, 6, 7, 8].map((rarity) {
                  return DropdownMenuItem<int>(
                    value: rarity,
                    child: Text('Rarity $rarity'),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
            const Divider(color: Colors.black),
          ],
          Expanded(
            child: itemsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];

                      return BounceInLeft(
                        duration: const Duration(milliseconds: 900),
                        delay: Duration(milliseconds: index * 5),
                        from: 200,
                        child: CustomCard(
                          shadowColor: AppColors.goldSoft,
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
                          body: _ItemBody(
                            item: item,
                            itemDescription: item.description,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // MaterialImage(
                              //   height: 40,
                              //   width: 40,
                              //   materialName: item.name,
                              // ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
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
        child: Icon(
          _filtersVisible ? Icons.close : Icons.search,
        ),
      ),
    );
  }
}

class _ItemBody extends StatelessWidget {
  const _ItemBody({
    required this.item,
    this.itemDescription = '-',
  });

  final Item item;
  final String itemDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemDescription,
          softWrap: true,
        ),
        // const SizedBox(height: 8),
        // Text(
        //   'Value: ${item.value}',
        //   style: const TextStyle(fontSize: 15),
        // ),
        const SizedBox(height: 8),
        if (item.recipes.isNotEmpty)
          if (item.recipes.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Recipe:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...item.recipes.first.inputs.map((recipeItem) {
                  final isLast = recipeItem == item.recipes.first.inputs.last;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipeItem.name,
                            style: const TextStyle(fontSize: 15),
                          ),
                          // const SizedBox(width: 8),
                          // MaterialImage(
                          //   height: 30,
                          //   width: 30,
                          //   materialName: recipeItem.name,
                          // ),
                          // const Text(
                          //   ')',
                          //   style: TextStyle(fontSize: 15),
                          // ),
                        ],
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 4),
                        const Text('+', style: TextStyle(fontSize: 15)),
                        const SizedBox(height: 4),
                      ]
                    ],
                  );
                }),
              ],
            ),
      ],
    );
  }
}
