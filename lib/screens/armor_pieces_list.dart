import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/armor_piece_image.dart';
import 'package:mhwilds_app/data/armor_pieces.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/decoration.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/decorations.dart';

class ArmorPiecesList extends StatefulWidget {
  const ArmorPiecesList({super.key});

  @override
  _ArmorPiecesListState createState() => _ArmorPiecesListState();
}

class _ArmorPiecesListState extends State<ArmorPiecesList> {
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
    List<String> filteredArmorPiecesKeys =
        armor_pieces.keys.where((armorPiecekey) {
      Map<String, dynamic> armorPieceMap = armor_pieces[armorPiecekey]!;
      ArmorPiece armorPiece = ArmorPiece.fromJson(armorPieceMap);

      bool matchesName = armorPiece.name
          .toLowerCase()
          .contains(_searchNameQuery.toLowerCase());
      bool matchesType =
          _selectedType == null || armorPiece.type == _selectedType;
      bool matchesRarity = _selectedRarity == null ||
          armorPiece.rarity.toString() == _selectedRarity;

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
                items: ['Helmet', 'Chest', 'Arms', 'Waist', 'Legs'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
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
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArmorPiecesKeys.length,
              itemBuilder: (context, index) {
                String armorPiecekey = filteredArmorPiecesKeys[index];
                Map<String, dynamic> armorPieceMap =
                    armor_pieces[armorPiecekey]!;
                ArmorPiece armorPiece = ArmorPiece.fromJson(armorPieceMap);

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                    trailing: Image.asset(
                      'assets/imgs/armor/rarity${armorPiece.rarity}.webp',
                      scale: 0.8,
                    ),
                    leading:
                        ArmorPieceImageDependingOnType(armorPiece: armorPiece),
                    cardData: armorPiece,
                    cardTitle: armorPiece.name ?? "Unknown",
                    cardSubtitle1Label: "Type: ",
                    cardSubtitle2Label: "Armor: ",
                    cardSubtitle1: armorPiece.type ?? "Unknown",
                    cardSubtitle2: armorPiece.armor ?? "Unknown",
                  ),
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

class ArmorPieceImageDependingOnType extends StatelessWidget {
  const ArmorPieceImageDependingOnType({
    super.key,
    required this.armorPiece,
  });

  final ArmorPiece armorPiece;

  @override
  Widget build(BuildContext context) {
    String armorPieceType;

    switch (armorPiece.type) {
      case 'Helmet':
        armorPieceType = 'helm';
        break;
      case 'Chest':
        armorPieceType = 'body';
        break;
      case 'Arms':
        armorPieceType = 'arm';
        break;
      case 'Waist':
        armorPieceType = 'waist';
        break;
      case 'Legs':
        armorPieceType = 'leg';
        break;
      default:
        armorPieceType = 'helm';
    }

    return ArmorPieceImage(
      armorPieceName: armorPiece.name,
      armorPieceType: armorPieceType,
    );
  }
}
