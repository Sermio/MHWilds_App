import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/providers/amulets_provider.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/models/amulet.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/c_card.dart';

class AmuletList extends StatefulWidget {
  const AmuletList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AmuletListState createState() => _AmuletListState();
}

class _AmuletListState extends State<AmuletList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final amuletProvider =
          Provider.of<AmuletProvider>(context, listen: false);

      if (!amuletProvider.hasData) {
        amuletProvider.fetchAmulets();
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
    });
    Provider.of<AmuletProvider>(context, listen: false).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final amuletProvider = Provider.of<AmuletProvider>(context);

    List<Amulet> filteredAmulets = amuletProvider.filteredAmulets;

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
                  amuletProvider.applyFilters(name: _searchNameQuery);
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
              child: ElevatedButton(
                onPressed: _resetFilters,
                child: const Text('Reset Filters'),
              ),
            ),
            const Divider(color: Colors.black)
          ],
          Expanded(
            child: amuletProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: filteredAmulets.length,
                    itemBuilder: (context, index) {
                      var amulet = filteredAmulets[index];
                      var ranks = amulet.ranks;

                      var firstRank = ranks.isNotEmpty ? ranks[0] : null;

                      String amuletName = '';
                      if (firstRank != null) {
                        amuletName = firstRank.name;

                        int lastSpaceIndex = amuletName.lastIndexOf(' ');
                        if (lastSpaceIndex != -1) {
                          amuletName = amuletName.substring(0, lastSpaceIndex);
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInRight(
                            duration: const Duration(milliseconds: 900),
                            delay: Duration(milliseconds: index),
                            child: Container(
                              width: double.infinity,
                              color: AppColors.goldSoft,
                              child: Text(
                                amuletName.isNotEmpty ? amuletName : "Unknown",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          if (ranks.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ranks.length,
                              itemBuilder: (context, rankIndex) {
                                var rank = ranks[rankIndex];
                                return BounceInLeft(
                                  duration: const Duration(milliseconds: 900),
                                  delay: Duration(milliseconds: rankIndex * 50),
                                  child: Ccard(
                                    cardData: rank,
                                    cardTitle: rank.name,
                                    cardSubtitle1Label: "Rarity: ",
                                    cardSubtitle2Label: "Level: ",
                                    cardSubtitle1: rank.rarity.toString(),
                                    cardSubtitle2: rank.level.toString(),
                                  ),
                                );
                              },
                            ),
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
