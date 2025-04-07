import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/armor_piece_image.dart';
import 'package:mhwilds_app/models/armor_piece2.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/armor_pieces2.dart';

class ArmorPiecesList2 extends StatefulWidget {
  const ArmorPiecesList2({super.key});

  @override
  _ArmorPiecesList2State createState() => _ArmorPiecesList2State();
}

class _ArmorPiecesList2State extends State<ArmorPiecesList2> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedType;
  String? _selectedRarity;
  bool _filtersVisible = false;

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _searchNameController.clear();
      _selectedType = null;
      _selectedRarity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object?>> filteredArmorPieces =
        armors2.where((armorPiece) {
      bool matchesName = (armorPiece['names'] as Map<String, String>)
          .values
          .any((name) =>
              name.toLowerCase().contains(_searchNameQuery.toLowerCase()));

      bool matchesType = _selectedType == null ||
          (armorPiece['pieces'] != null &&
              (armorPiece['pieces'] as List<dynamic>).any((piece) =>
                  piece['kind']?.toLowerCase() ==
                  _selectedType?.toLowerCase()));

      bool matchesRarity = _selectedRarity == null ||
          armorPiece['rarity'].toString() == _selectedRarity;

      return matchesName && matchesType && matchesRarity;
    }).toList();

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
                dropdownColor: Colors.white,
                value: _selectedType,
                hint: const Text('Select Type'),
                onChanged: (newType) {
                  setState(() {
                    _selectedType = newType;
                  });
                },
                items: ['Head', 'Chest', 'Arms', 'Waist', 'Legs'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type.toLowerCase(),
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _selectedRarity,
                hint: const Text('Select Rarity'),
                onChanged: (newRarity) {
                  setState(() {
                    _selectedRarity = newRarity;
                  });
                },
                items: List.generate(8, (index) => (index + 1).toString())
                    .map((rarity) {
                  return DropdownMenuItem<String>(
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
            const Divider(color: Colors.black)
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              itemCount: filteredArmorPieces.length,
              itemBuilder: (context, index) {
                var armorPiece = filteredArmorPieces[index];

                var pieces = (armorPiece['pieces'] is List)
                    ? (armorPiece['pieces'] as List).where((piece) {
                        return _selectedType == null ||
                            piece['kind'].toString().toLowerCase() ==
                                _selectedType?.toLowerCase();
                      }).toList()
                    : [];

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
                          (armorPiece['names']
                                  as Map<String, dynamic>?)?['en'] ??
                              "Unknown",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pieces.length ?? 0,
                      itemBuilder: (context, pieceIndex) {
                        var piece = pieces[pieceIndex];

                        return BounceInLeft(
                          duration: const Duration(milliseconds: 900),
                          delay: Duration(milliseconds: pieceIndex * 50),
                          child: Ccard(
                            trailing: Image.asset(
                              'assets/imgs/armor/${piece['kind'].toString().toLowerCase()}/rarity${armorPiece['rarity']}.webp',
                              scale: 0.8,
                            ),
                            // leading: ArmorPieceImage(
                            //   armorPieceName: (piece['names']
                            //           as Map<String, dynamic>?)?['en'] ??
                            //       "Unknown",
                            //   armorPieceType: piece['kind'].toString(),
                            // ),
                            cardData: piece,
                            cardTitle: (piece['names']
                                    as Map<String, dynamic>?)?['en'] ??
                                "Unknown",
                            cardSubtitle1Label: "Rarity: ",
                            cardSubtitle2Label: "Type: ",
                            cardSubtitle1: armorPiece['rarity'].toString(),
                            cardSubtitle2: piece['kind'].toString(),
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
      floatingActionButton: BounceInRight(
        delay: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: _toggleFiltersVisibility,
          child: Icon(
            _filtersVisible ? Icons.close : Icons.search,
          ),
        ),
      ),
    );
  }
}
