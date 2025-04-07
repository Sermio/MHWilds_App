import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/armor_piece_image.dart';
import 'package:mhwilds_app/models/armor_piece2.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/armor_pieces2.dart'; // Asegúrate de que armors2 sea una lista de objetos ArmorPiece2
import 'package:mhwilds_app/utils/utils.dart';

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
      // Verificar si el nombre contiene la consulta de búsqueda
      bool matchesName = (armorPiece['names'] as Map<String, String>)
          .values
          .any((name) =>
              name.toLowerCase().contains(_searchNameQuery.toLowerCase()));

      // Verificar si el tipo coincide con el filtro seleccionado
      bool matchesType = _selectedType == null ||
          (armorPiece['groupBonus'] != null &&
              (armorPiece['groupBonus'] as Map<String, dynamic>)['skillId']
                      ?.toString() ==
                  _selectedType);

      // Verificar si la rareza coincide con el filtro seleccionado
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
                items: ['Skill 1', 'Skill 2', 'Skill 3'].map((type) {
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              itemCount: filteredArmorPieces.length,
              itemBuilder: (context, index) {
                var armorPiece = filteredArmorPieces[index];

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                    trailing: Image.asset(
                      'assets/imgs/armor/rarity${armorPiece['rarity']}.webp',
                      scale: 0.8,
                    ),
                    // leading: ArmorPieceImageDependingOnType(armorPiece: armorPiece),
                    cardData: armorPiece,
                    cardTitle:
                        (armorPiece['names'] as Map<String, dynamic>?)?['en'] ??
                            "Unknown",

                    cardSubtitle1Label: "Rarity: ",
                    cardSubtitle2Label: "Skill: ",
                    cardSubtitle1: armorPiece['rarity'].toString(),
                    cardSubtitle2:
                        (armorPiece as Map<String, dynamic>)['groupBonus']
                                    ?['skillId']
                                ?.toString() ??
                            "Unknown",
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

  final ArmorPiece2 armorPiece;

  @override
  Widget build(BuildContext context) {
    String armorPieceType;

    // Aquí puedes determinar el tipo de la pieza basado en las propiedades del objeto
    switch (armorPiece.pieces[0].kind) {
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
      armorPieceName: armorPiece.names['en'] ?? 'Unknown',
      armorPieceType: armorPieceType,
    );
  }
}
