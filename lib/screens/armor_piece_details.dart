import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:provider/provider.dart';

class ArmorDetails extends StatefulWidget {
  final armor_models.ArmorPiece armor;

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

  Future<List<Skills>> fetchSkillsForArmor(
      armor_models.ArmorPiece armor) async {
    List<Skills> skills = [];
    for (var skillInfo in armor.skills) {
      int skillId = skillInfo.skill.id;
      skills.add(await SkillsApi.fetchSkillById(skillId));
    }
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.armor.name),
        centerTitle: true,
      ),
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header de la pieza de armadura
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Imagen de la pieza de armadura
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/imgs/armor/${widget.armor.kind.toString().toLowerCase()}/rarity${widget.armor.rarity}.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Nombre de la pieza
                  Text(
                    widget.armor.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Descripción de la pieza
                  if (widget.armor.description.isNotEmpty) ...[
                    Text(
                      widget.armor.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Sección de estadísticas
            _buildStatsSection(),

            // Sección de habilidades
            _buildSkillsSection(),

            // Sección de materiales de crafting
            _buildCraftingSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.statistics,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de estadísticas
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatRow(AppLocalizations.of(context)!.rarity,
                    widget.armor.rarity.toString()),
                const Divider(height: 24),
                _buildStatRow(
                    AppLocalizations.of(context)!.rank, widget.armor.rank),
                const Divider(height: 24),
                _buildStatRow(AppLocalizations.of(context)!.slots, "",
                    trailing: ArmorPieceSlotsWidget(armorPiece: widget.armor)),
                const Divider(height: 24),
                _buildStatRow(AppLocalizations.of(context)!.baseDefense,
                    "${widget.armor.defense['base']}",
                    trailing: ArmorBaseDefense(
                        baseDefense: widget.armor.defense['base']!)),
                const Divider(height: 24),

                // Sección de resistencias
                ArmorResistancesWidget(armor: widget.armor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, String value,
      {Widget? trailing, VoidCallback? onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget content = Row(
      children: [
        Text(
          "$title:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: onTap != null
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        if (trailing != null)
          trailing
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildSkillsSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.skills,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de habilidades
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<List<Skills>>(
              future: _skills,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child:
                          CircularProgressIndicator(color: colorScheme.primary),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context)!.errorLoadingSkills,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context)!.noSkillsAvailable,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: snapshot.data!.map((skillInfo) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: colorScheme.surface,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: UrlImageLoader(
                                      itemName: (Provider.of<EnNamesCache>(
                                                  context,
                                                  listen: false)
                                              .nameForSkillImage(skillInfo.id,
                                                  skillInfo.name) ??
                                          skillInfo.name),
                                      loadImageUrlFunction:
                                          getValidSkillImageUrl,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        skillInfo.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      if (skillInfo.description.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          skillInfo.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...skillInfo.ranks.map((rank) {
                              bool isCurrentLevel = widget.armor.skills.any(
                                (armorSkill) =>
                                    armorSkill.skill.id == skillInfo.id &&
                                    armorSkill.level == rank.level,
                              );

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCurrentLevel
                                      ? colorScheme.primary.withOpacity(0.1)
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isCurrentLevel
                                        ? colorScheme.primary.withOpacity(0.3)
                                        : colorScheme.outlineVariant,
                                    width: isCurrentLevel ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCurrentLevel
                                            ? colorScheme.primary
                                            : colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${AppLocalizations.of(context)!.lv} ${rank.level}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentLevel
                                              ? colorScheme.onPrimary
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        rank.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: colorScheme.onSurface,
                                          fontWeight: isCurrentLevel
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCraftingSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.build,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.craftingMaterials,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de crafting
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Materiales (excluyendo Zenny si está en la lista)
                if (widget.armor.crafting.materials.isNotEmpty) ...[
                  _buildMaterialsSection(
                    widget.armor.crafting.materials
                        .where((material) =>
                            material.item.name.toLowerCase() != 'zenny' &&
                            material.item.name.toLowerCase() != 'zenny cost')
                        .toList(),
                  ),
                ],

                // Costo de Zenny como etiqueta amarilla separada
                if (widget.armor.crafting.zennyCost > 0) ...[
                  const SizedBox(height: 20),
                  _buildCostChip(AppLocalizations.of(context)!.craft,
                      widget.armor.crafting.zennyCost),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection(List<dynamic> materials) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...materials.map((material) => _buildMaterialItem(material)).toList(),
      ],
    );
  }

  Widget _buildMaterialItem(dynamic material) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MaterialImage(
                      materialName:
                          Provider.of<EnNamesCache>(context, listen: false)
                                  .nameForItemImage(
                                      material.item.id, material.item.name) ??
                              material.item.name,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    material.item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  'x${material.quantity}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostChip(String label, int cost) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Text(
        '$label: $cost Z',
        style: TextStyle(
          color: Colors.amber[800],
          fontWeight: FontWeight.w600,
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

class ArmorResistancesWidget extends StatelessWidget {
  final armor_models.ArmorPiece armor;

  const ArmorResistancesWidget({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.resistances}:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
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
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ArmorPieceSlotsWidget extends StatelessWidget {
  final armor_models.ArmorPiece armorPiece;

  const ArmorPieceSlotsWidget({super.key, required this.armorPiece});

  @override
  Widget build(BuildContext context) {
    if (armorPiece.slots.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.noSlots,
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: armorPiece.slots.map((slot) {
        Color slotColor;
        switch (slot) {
          case 1:
            slotColor = Colors.green;
            break;
          case 2:
            slotColor = Colors.blue;
            break;
          case 3:
            slotColor = Colors.purple;
            break;
          case 4:
            slotColor = Colors.orange;
            break;
          default:
            slotColor = Colors.grey;
        }

        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: slotColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: slotColor, width: 1),
          ),
          child: Center(
            child: Text(
              slot.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: slotColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
