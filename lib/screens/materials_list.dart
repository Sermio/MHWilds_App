import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/models/material.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/c_card.dart';
import 'package:mhwilds_app/data/materials.dart';

class MaterialsList extends StatefulWidget {
  const MaterialsList({super.key});

  @override
  _MaterialsListState createState() => _MaterialsListState();
}

class _MaterialsListState extends State<MaterialsList> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchSourceController = TextEditingController();
  String _searchNameQuery = '';
  String _searchSourceQuery = '';
  bool _filtersVisible = false;

  void _toggleFiltersVisibility() {
    setState(() {
      _filtersVisible = !_filtersVisible;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchNameQuery = '';
      _searchSourceQuery = '';
      _searchNameController.clear();
      _searchSourceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredMaterialKeys = materials.keys.where((materialKey) {
      MaterialItem material = MaterialItem.fromMap(materials[materialKey]!);

      // Filtrar por nombre y por source (si el source está seleccionado)
      bool matchesName =
          material.name.toLowerCase().contains(_searchNameQuery.toLowerCase());

      bool matchesSource = material.source
          .toLowerCase()
          .contains(_searchSourceQuery.toLowerCase());

      return matchesName && matchesSource;
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
              child: TextField(
                controller: _searchSourceController,
                onChanged: (query) {
                  setState(() {
                    _searchSourceQuery = query;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search by Source',
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
            child: ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              itemCount: filteredMaterialKeys.length,
              itemBuilder: (context, index) {
                String materialKey = filteredMaterialKeys[index];
                MaterialItem material =
                    MaterialItem.fromMap(materials[materialKey]!);
                // String formattedMaterialName = material.name
                //     .replaceAll(RegExp(r'\s\+'), '+')
                //     .replaceAll(RegExp(r'[()]'), '');
                String cleanedSource = material.source
                    .replaceAll(
                        RegExp(
                            r'; Please consult the individual page to learn about them\.'),
                        '')
                    .replaceAll(
                        RegExp(
                            r'; Consult the individual page to learn about them\.'),
                        '');
                cleanedSource = cleanedSource.replaceAll(';', '\n');

                return BounceInLeft(
                  duration: const Duration(milliseconds: 900),
                  delay: Duration(milliseconds: index * 5),
                  child: Ccard(
                      bodyOnTop: false,
                      leading: MaterialImage(materialName: material.name),
                      cardData: material,
                      cardTitle: material.name ?? "Unknown",
                      cardSubtitle1Label: "Rarity: ",
                      cardSubtitle1: material.rarity ?? "Unknown",
                      cardBody: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Source: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Flexible(
                            child: Text(
                              cleanedSource ?? "Unknown",
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      )),
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
