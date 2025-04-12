import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/components/monster_details_card.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/models/armor_piece.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/widgets/custom_card.dart';
import 'package:mhwilds_app/screens/item_details.dart';

class ArmorDetails extends StatefulWidget {
  final ArmorPiece armor;

  const ArmorDetails({super.key, required this.armor});

  @override
  _ArmorDetailsState createState() => _ArmorDetailsState();
}

class _ArmorDetailsState extends State<ArmorDetails> {
  late Future<List<Skills>> _skills;

  @override
  void initState() {
    super.initState();
    _skills = fetchSkillsForArmor(widget.armor);
  }

  Future<List<Skills>> fetchSkillsForArmor(ArmorPiece armor) async {
    List<Skills> skills = [];
    for (var skillInfo in armor.skills) {
      int skillId = skillInfo.skill.id;
      skills.add(await SkillsApi.fetchSkillById(skillId));
    }
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.armor.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 30.0),
            //   child: SizedBox(
            //     width: 50,
            //     height: 50,
            //     child: Image.asset(
            //       'assets/imgs/armor/${widget.armor.kind.toString().toLowerCase()}/rarity${widget.armor.rarity}.webp',
            //       scale: 0.5,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     widget.armor.description,
            //     style: const TextStyle(fontSize: 16),
            //   ),
            // ),
            _buildSectionTitle("Stats"),
            _buildStats(context),
            _buildSectionTitle("Skills"),
            _SkillsSection(skills: _skills, widget: widget),
            _buildSectionTitle("Crafting Materials"),
            CustomCard(
              shadowColor: AppColors.goldSoft,
              title: ListTile(
                // leading: Image.asset(
                //   'assets/imgs/materials/zenny.webp',
                //   height: 40,
                //   width: 40,
                // ),
                title: const Text(
                  'Zenny',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Text(
                  'x${widget.armor.crafting.zennyCost}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            ...widget.armor.crafting.materials.map((material) => CustomCard(
                  shadowColor: AppColors.goldSoft,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetails(
                          item: material.item,
                        ),
                      ),
                    );
                  },
                  title: ListTile(
                    // leading: MaterialImage(
                    //   height: 40,
                    //   width: 40,
                    //   materialName: material.item.name,
                    // ),
                    title: Text(material.item.name),
                    trailing: Text(
                      'x${material.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMapRow("Rarity", widget.armor.rarity.toString()),
          const Divider(),
          _buildMapRow("Rank", widget.armor.rank),
          const Divider(),
          _buildMapRow("Slots", widget.armor.slots.join(", ")),
          const Divider(),
          Row(
            children: [
              const Text("Armor:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              ArmorBaseDefense(
                baseDefense: widget.armor.defense['base']!,
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  elementsDialog(context);
                },
                child: const Text("Resistances:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldSoft)),
              ),
              const Spacer(),
              _ArmorResistancesRow(armor: widget.armor),
            ],
          ),
          const Divider(),
          // _buildMapRow("Zenny Cost", "${widget.armor.crafting.zennyCost} z"),
          // const Divider(),
        ],
      ),
    );
  }

  Widget _buildMapRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
        Flexible(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ArmorBaseDefense extends StatelessWidget {
  final int baseDefense;

  const ArmorBaseDefense({super.key, required this.baseDefense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          child: Image.asset(
            'assets/imgs/armor/armor.webp',
          ),
        ),
        const SizedBox(width: 5),
        Text(baseDefense.toString()),
        // const SizedBox(width: 10),
      ],
    );
  }
}

class _ArmorResistancesRow extends StatelessWidget {
  final ArmorPiece armor;

  const _ArmorResistancesRow({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...armor.resistances.entries.map(
          (entry) {
            final resistanceType = entry.key;
            final resistanceValue = entry.value;

            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 20,
                    child: Image.asset(
                      'assets/imgs/elements/${resistanceType.toLowerCase()}.webp',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(resistanceValue.toString()),
                  // const SizedBox(width: 10),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({
    super.key,
    required Future<List<Skills>> skills,
    required this.widget,
  }) : _skills = skills;

  final Future<List<Skills>> _skills;
  final ArmorDetails widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Skills>>(
      future: _skills,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar las habilidades"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No hay habilidades disponibles"));
        } else {
          return Column(
            children: snapshot.data!.map((skillInfo) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 30,
                        height: 30,
                        child: UrlImageLoader(
                          itemName: skillInfo.name,
                          loadImageUrlFunction: getValidSkillImageUrl,
                        ),
                      ),
                      title: Text(
                        skillInfo.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(skillInfo.description),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: skillInfo.ranks.map((rank) {
                        bool isCurrentLevel = widget.armor.skills.any(
                          (armorSkill) =>
                              armorSkill.skill.id == skillInfo.id &&
                              armorSkill.level == rank.level,
                        );

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lv ${rank.level}: ",
                              style: isCurrentLevel
                                  ? const TextStyle(fontWeight: FontWeight.bold)
                                  : null,
                            ),
                            Expanded(child: Text(rank.description)),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
