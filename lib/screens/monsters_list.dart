import 'package:flutter/material.dart';
import 'package:mhwilds_app/data/monsters.dart'; // Asegúrate de que tienes tus monstruos aquí
import 'package:mhwilds_app/widgets/c_card.dart';

class MonsterScreen extends StatefulWidget {
  const MonsterScreen({super.key});

  @override
  _MonsterScreenState createState() => _MonsterScreenState();
}

class _MonsterScreenState extends State<MonsterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Para guardar el texto de búsqueda

  @override
  Widget build(BuildContext context) {
    // Filtrar los monstruos según el texto de búsqueda
    List<String> filteredMonsterKeys = monsters.keys
        .where((monsterKey) =>
            monsters[monsterKey]?["monsterName"]
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ??
            false)
        .toList();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Monsters'),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMonsterKeys.length,
              itemBuilder: (context, index) {
                String monsterKey = filteredMonsterKeys[index];
                Map<String, dynamic> monster = monsters[monsterKey]!;

                return Ccard(
                  cardData: monster,
                  cardTitle: monster["monsterName"] ?? "Unknown",
                  cardSubtitle1Label: "Type: ",
                  cardSubtitle2Label: "Specie: ",
                  cardSubtitle1: monster["monsterType"] ?? "Unknown",
                  cardSubtitle2: monster["monsterSpecie"] ?? "Unknown",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
