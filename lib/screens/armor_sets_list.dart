import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/providers/armor_sets_provider.dart';
import 'package:mhwilds_app/screens/armor_piece_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class ArmorSetList extends StatefulWidget {
  const ArmorSetList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ArmorSetListState createState() => _ArmorSetListState();
}

class _ArmorSetListState extends State<ArmorSetList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedKind;
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
                dropdownColor: Colors.white,
                value: _selectedKind,
                hint: const Text('Select Type'),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(kind),
                        Image.asset(
                          getKindImage(kind.toLowerCase()),
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
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
                    padding: const EdgeInsets.symmetric(vertical: 0),
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
                                color: AppColors.mutedOlive,
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
                              index,
                              BounceInLeft(
                                duration: const Duration(milliseconds: 900),
                                delay: Duration(milliseconds: index * 80),
                                from: 200,
                                child: CustomCard(
                                  shadowColor: AppColors.goldSoft,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArmorDetails(
                                          armor: piece,
                                        ),
                                      ),
                                    );
                                  },
                                  title: _CardTitle(armorPiece: piece),
                                  body: _CardBody(
                                    armorPiece: piece,
                                  ),
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

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.armorPiece,
  });

  final ArmorPiece armorPiece;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            'assets/imgs/armor/${armorPiece.kind.toString().toLowerCase()}/rarity${armorPiece.rarity}.webp',
            scale: 0.8,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              armorPiece.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.armorPiece,
  });

  final ArmorPiece armorPiece;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ArmorPieceSlotsWidget(
          armorPiece: armorPiece,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          direction: Axis.vertical,
          children: [
            _CardResistances(
              armorPiece: armorPiece,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: armorPiece.skills.map((skill) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BodySkills(
                  skill: skill,
                ),
                Wrap(
                  children: [
                    Text(skill.skill.description),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BodySkills extends StatelessWidget {
  const _BodySkills({
    required this.skill,
  });

  final SkillInfo skill;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: UrlImageLoader(
            itemName: skill.skill.name,
            loadImageUrlFunction: getValidSkillImageUrl,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          skill.skill.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Text(
          'Lv ${skill.level}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CardResistances extends StatelessWidget {
  const _CardResistances({
    required this.armorPiece,
  });

  final ArmorPiece armorPiece;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            SizedBox(
              height: 20,
              child: Image.asset(
                'assets/imgs/armor/armor.webp',
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(armorPiece.defense['base'].toString()),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        ...armorPiece.resistances.entries.map(
          (entry) {
            final resistanceType = entry.key;
            final resistanceValue = entry.value;

            return Row(
              children: [
                SizedBox(
                  height: 20,
                  child: Image.asset(
                    'assets/imgs/elements/${resistanceType.toLowerCase()}.webp',
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(resistanceValue.toString()),
                const SizedBox(
                  width: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class ArmorPieceSlotsWidget extends StatelessWidget {
  final ArmorPiece armorPiece;

  const ArmorPieceSlotsWidget({super.key, required this.armorPiece});

  @override
  Widget build(BuildContext context) {
    const int totalSlots = 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSlots, (index) {
        final slot =
            index < armorPiece.slots.length ? armorPiece.slots[index] : null;

        if (slot == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              '-',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: SizedBox(
              width: 20,
              height: 20,
              child: getJewelSlotIcon(slot),
            ),
          );
        }
      }),
    );
  }
}
