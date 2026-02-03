import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';

class WeaponDetails extends StatefulWidget {
  final Weapon weapon;

  const WeaponDetails({super.key, required this.weapon});

  @override
  _WeaponDetailsState createState() => _WeaponDetailsState();
}

class _WeaponDetailsState extends State<WeaponDetails> {
  late Future<List<Skills>> _skills;

  @override
  void initState() {
    super.initState();
    _skills = fetchSkillsForWeapon(widget.weapon);
  }

  Future<List<Skills>> fetchSkillsForWeapon(Weapon weapon) async {
    List<Skills> skills = [];
    for (var skillInfo in widget.weapon.skills) {
      int skillId = skillInfo.skill.id;
      skills.add(await SkillsApi.fetchSkillById(skillId));
    }
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(widget.weapon.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del weapon
            _buildWeaponHeader(),

            // Stats principales
            _buildMainStats(),

            // Sharpness
            if (_hasSharpnessData()) _buildSharpnessSection(),

            // Skills
            if (widget.weapon.skills.isNotEmpty) _buildSkillsSection(),

            // Crafting
            _buildCraftingSection(),

            // Descripción
            if (widget.weapon.description.isNotEmpty)
              _buildDescriptionSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
          // Imagen del tipo de weapon
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
            child: Icon(
              WeaponUtils.getWeaponIcon(widget.weapon.kind),
              color: WeaponUtils.getKindColor(widget.weapon.kind),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          // Nombre del weapon
          Text(
            widget.weapon.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Descripción del weapon
          if (widget.weapon.description.isNotEmpty) ...[
            Text(
              widget.weapon.description,
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
    );
  }

  Widget _buildMainStats() {
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
                  'Statistics',
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
                _buildStatRow("Rarity", widget.weapon.rarity.toString()),
                const Divider(height: 24),
                _buildStatRow(
                    "Type", WeaponUtils.formatWeaponKind(widget.weapon.kind)),
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(
                      Icons.flash_on,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Physical Damage:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          size: 16,
                          color: Colors.red[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.weapon.damage.display}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.weapon.affinity != 0) ...[
                  const SizedBox(height: 12),
                  _buildStatRow("Affinity",
                      "${widget.weapon.affinity > 0 ? '+' : ''}${widget.weapon.affinity}%"),
                ],
                if (widget.weapon.defenseBonus > 0) ...[
                  const Divider(height: 24),
                  _buildStatRow(
                      "Defense Bonus", "+${widget.weapon.defenseBonus}"),
                ],
                if (widget.weapon.elderseal != null) ...[
                  const Divider(height: 24),
                  _buildStatRow("Elderseal", widget.weapon.elderseal!),
                ],
                if (widget.weapon.slots.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildStatRow("Slots", _buildSlotsDisplay()),
                ],

                // Información específica del tipo de arma
                ..._buildWeaponTypeSpecificStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String title, dynamic value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          "$title:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        if (value is String)
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          )
        else if (value is Widget)
          value,
      ],
    );
  }

  Widget _buildSharpnessSection() {
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
                  Icons.content_cut,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sharpness',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de sharpness
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SharpnessBar(
                  sharpness: widget.weapon.sharpness,
                  height: 40,
                  borderRadius: 20,
                ),
                const SizedBox(height: 12),
                // Leyenda de colores
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (widget.weapon.sharpness.red > 0)
                      _buildSharpnessLegend(
                          'Red', Colors.red[400]!, widget.weapon.sharpness.red),
                    if (widget.weapon.sharpness.orange > 0)
                      _buildSharpnessLegend('Orange', Colors.orange[400]!,
                          widget.weapon.sharpness.orange),
                    if (widget.weapon.sharpness.yellow > 0)
                      _buildSharpnessLegend('Yellow', Colors.yellow[600]!,
                          widget.weapon.sharpness.yellow),
                    if (widget.weapon.sharpness.green > 0)
                      _buildSharpnessLegend('Green', Colors.green[400]!,
                          widget.weapon.sharpness.green),
                    if (widget.weapon.sharpness.blue > 0)
                      _buildSharpnessLegend('Blue', Colors.blue[400]!,
                          widget.weapon.sharpness.blue),
                    if (widget.weapon.sharpness.white > 0)
                      _buildSharpnessLegend(
                          'White', Colors.white, widget.weapon.sharpness.white),
                    if (widget.weapon.sharpness.purple > 0)
                      _buildSharpnessLegend('Purple', Colors.purple[400]!,
                          widget.weapon.sharpness.purple),
                  ],
                ),
                // if (widget.weapon.handicraft.isNotEmpty) ...[
                //   const SizedBox(height: 16),
                //   _buildStatRow(
                //       "Handicraft", "+${widget.weapon.handicraft.first}"),
                // ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharpnessLegend(String label, Color color, int value) {
    final colorScheme = Theme.of(context).colorScheme;
    // Si el color es blanco, añadir un outline para que sea visible
    final bool needsOutline = color == Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: needsOutline
                ? Border.all(color: colorScheme.outlineVariant, width: 2)
                : null,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
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
                  'Skills',
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
                        "Error loading skills",
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
                        "No skills available",
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
                                      itemName: skillInfo.name,
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
                              bool isCurrentLevel = widget.weapon.skills.any(
                                (armorSkill) =>
                                    armorSkill.skill.id == skillInfo.id &&
                                    armorSkill.level == rank.level,
                              );

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCurrentLevel
                                      ? AppColors.goldSoft.withOpacity(0.1)
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isCurrentLevel
                                        ? AppColors.goldSoft.withOpacity(0.3)
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
                                            ? AppColors.goldSoft
                                            : colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Lv ${rank.level}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentLevel
                                              ? (colorScheme.brightness ==
                                                      Brightness.dark
                                                  ? colorScheme.onSurface
                                                  : Colors.black87)
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
                  'Crafting Materials',
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
                // if (widget.weapon.crafting.craftingMaterials.isNotEmpty) ...[
                //   _buildMaterialsSection(
                //       widget.weapon.crafting.craftingMaterials),
                // ],
                if (widget.weapon.crafting.upgradeMaterials.isNotEmpty) ...[
                  _buildMaterialsSection(
                      widget.weapon.crafting.upgradeMaterials),
                ],
                if (widget.weapon.crafting.craftingZennyCost > 0 ||
                    widget.weapon.crafting.upgradeZennyCost > 0) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Mostrar solo upgradeZennyCost si hay ambos, o el que esté disponible
                      if (_shouldShowUpgradeZennyCost()) ...[
                        if (widget.weapon.crafting.upgradeZennyCost > 0)
                          _buildCostChip('Upgrade',
                              widget.weapon.crafting.upgradeZennyCost),
                      ] else ...[
                        if (widget.weapon.crafting.craftingZennyCost > 0)
                          _buildCostChip('Craft',
                              widget.weapon.crafting.craftingZennyCost),
                      ],
                    ],
                  ),
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
                      materialName: material.item.name,
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

  Widget _buildDescriptionSection() {
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
                  Icons.description,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // Contenido de descripción
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.weapon.description,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para el status de crafting
  IconData _getCraftingStatusIcon() {
    if (widget.weapon.crafting.craftable &&
        widget.weapon.crafting.craftingMaterials.isNotEmpty) {
      return Icons.check_circle;
    } else if (widget.weapon.crafting.upgradeMaterials.isNotEmpty) {
      return Icons.upgrade;
    } else {
      return Icons.cancel;
    }
  }

  Color _getCraftingStatusColor() {
    if (widget.weapon.crafting.craftable &&
        widget.weapon.crafting.craftingMaterials.isNotEmpty) {
      return Colors.green;
    } else if (widget.weapon.crafting.upgradeMaterials.isNotEmpty) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  String _getCraftingStatusText() {
    if (widget.weapon.crafting.craftable &&
        widget.weapon.crafting.craftingMaterials.isNotEmpty) {
      return 'Craftable';
    } else if (widget.weapon.crafting.upgradeMaterials.isNotEmpty) {
      return 'Upgradeable';
    } else {
      return 'Not Available';
    }
  }

  // Método auxiliar para verificar si el weapon tiene datos de sharpness
  bool _hasSharpnessData() {
    return widget.weapon.sharpness.red > 0 ||
        widget.weapon.sharpness.orange > 0 ||
        widget.weapon.sharpness.yellow > 0 ||
        widget.weapon.sharpness.green > 0 ||
        widget.weapon.sharpness.blue > 0 ||
        widget.weapon.sharpness.white > 0 ||
        widget.weapon.sharpness.purple > 0;
  }

  Widget _buildSlotsDisplay() {
    if (widget.weapon.slots.isEmpty) {
      return const Text(
        'No slots',
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widget.weapon.slots.map((slot) {
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

  List<Widget> _buildWeaponTypeSpecificStats() {
    final List<Widget> stats = [];
    bool hasContent = false;

    // Daño elemental/status si está disponible (mismo estilo que WeaponsList)
    if (widget.weapon.specials != null) {
      final elementalStats =
          WeaponDisplayUtils.buildElementalDamageRow(widget.weapon);
      if (elementalStats != null) {
        if (hasContent) {
          stats.add(const Divider(height: 24));
        }
        stats.add(elementalStats);
        hasContent = true;
      }
    }

    // Información específica según el tipo de arma (mismo estilo que WeaponsList)
    final additionalInfo =
        WeaponDisplayUtils.buildAdditionalDamageInfo(widget.weapon);
    if (additionalInfo != null) {
      if (hasContent) {
        stats.add(const Divider(height: 24));
      }
      stats.add(additionalInfo);
      hasContent = true;
    }

    return stats;
  }

  // Método auxiliar para determinar si mostrar upgradeZennyCost
  bool _shouldShowUpgradeZennyCost() {
    final hasCraftingCost = widget.weapon.crafting.craftingZennyCost > 0;
    final hasUpgradeCost = widget.weapon.crafting.upgradeZennyCost > 0;

    // Si tiene ambos, mostrar solo upgrade
    if (hasCraftingCost && hasUpgradeCost) {
      return true;
    }
    // Si solo tiene upgrade, mostrarlo
    if (hasUpgradeCost) {
      return true;
    }
    // Si solo tiene crafting, no mostrar upgrade
    return false;
  }
}
