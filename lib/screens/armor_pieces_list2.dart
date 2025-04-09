import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/armor_set.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:provider/provider.dart';

class ArmorSetList extends StatefulWidget {
  const ArmorSetList({super.key});

  @override
  _ArmorSetListState createState() => _ArmorSetListState();
}

class _ArmorSetListState extends State<ArmorSetList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedKind; // Cambiamos de _selectedRank a _selectedKind
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final armorSetProvider =
          Provider.of<ArmorSetProvider>(context, listen: false);

      if (!armorSetProvider.hasData) {
        armorSetProvider.fetchArmorSets();
      }
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
      _selectedKind = null;
    });

    final provider = Provider.of<ArmorSetProvider>(context, listen: false);
    provider.clearFilters();

    provider.applyFilters(name: '', kind: null);
  }

  @override
  Widget build(BuildContext context) {
    final armorSetProvider = Provider.of<ArmorSetProvider>(context);
    final filteredArmorSets = armorSetProvider.armorSets;

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

                  armorSetProvider.applyFilters(
                      name: _searchNameQuery, kind: _selectedKind);
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
              child: DropdownButton<String>(
                value: _selectedKind,
                hint: const Text('Select Kind'),
                onChanged: (newKind) {
                  setState(() {
                    _selectedKind = newKind?.toLowerCase();
                  });

                  armorSetProvider.applyFilters(
                      name: _searchNameQuery, kind: _selectedKind);
                },
                items: ['Head', 'Chest', 'Arms', 'Waist', 'Legs'].map((kind) {
                  return DropdownMenuItem<String>(
                    value: kind.toLowerCase(),
                    child: Text(kind),
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
            child: armorSetProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredArmorSets.length,
                    itemBuilder: (context, index) {
                      final armorSet = filteredArmorSets[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: FadeInRight(
                              duration: const Duration(milliseconds: 900),
                              delay: Duration(milliseconds: index),
                              from: 200,
                              child: Container(
                                width: double.infinity,
                                color: AppColors.goldSoft,
                                child: Text(
                                  armorSet.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...armorSet.pieces.asMap().map((index, piece) {
                            return MapEntry(
                              index, // índice
                              BounceInLeft(
                                duration: const Duration(milliseconds: 900),
                                delay: Duration(milliseconds: index * 80),
                                from: 200,
                                child: Ccard(
                                  cardData: piece,
                                  leading: Image.asset(
                                    'assets/imgs/armor/${piece.kind.toString().toLowerCase()}/rarity${piece.rarity}.webp',
                                    scale: 0.8,
                                  ),
                                  cardBody: _ArmorSetBody(
                                    armorSet: armorSet,
                                    piece: piece,
                                  ),
                                  cardTitle: piece.name,
                                ),
                              ),
                            );
                          }).values,
                          const SizedBox(height: 20),
                        ],
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

class _ArmorSetBody extends StatelessWidget {
  const _ArmorSetBody({
    super.key,
    required this.armorSet,
    required this.piece,
  });

  final ArmorSet armorSet;
  final ArmorPiece piece;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Rank: ${piece.rank}',
        //   style: const TextStyle(fontSize: 15),
        // ),
        // const SizedBox(height: 6),
        Text(
          'Armor: ${piece.defense['base']}',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 6),
        // Aquí puedes agregar más detalles si lo deseas
      ],
    );
  }
}
