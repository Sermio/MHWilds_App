import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/models/skills.dart';
import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/api/weapons_api.dart';
import 'package:mhwilds_app/utils/weapon_tree_builder.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/components/tree_connector_painter.dart';
import 'package:mhwilds_app/components/skill_sprite_icon.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/components/material_image.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/gear_sprite_icon.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/components/rarity_chip.dart';
import 'package:mhwilds_app/screens/item_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

class WeaponDetails extends StatefulWidget {
  final Weapon weapon;

  const WeaponDetails({super.key, required this.weapon});

  @override
  _WeaponDetailsState createState() => _WeaponDetailsState();
}

class _WeaponDetailsState extends State<WeaponDetails> {
  late Future<List<Skills>> _skills;
  bool _isTreeView = true;

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

            // Weapon Tree
            if (_hasWeaponTreeData()) _buildWeaponTreeSection(),

            // Crafting
            if (_hasCraftingData()) _buildCraftingSection(),


            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final int? spriteColumn = weaponColumnByKind[widget.weapon.kind];

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
            ),
            child: spriteColumn != null
                ? GearSpriteIcon(
                    column: spriteColumn,
                    rarity: widget.weapon.rarity,
                    size: 80,
                    fallback: Icon(
                      WeaponUtils.getWeaponIcon(widget.weapon.kind),
                      color: WeaponUtils.getKindColor(widget.weapon.kind),
                      size: 40,
                    ),
                  )
                : Icon(
                    WeaponUtils.getWeaponIcon(widget.weapon.kind),
                    color: WeaponUtils.getKindColor(widget.weapon.kind),
                    size: 40,
                  ),
          ),
          const SizedBox(height: 16),
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
          // Título de la sección (sin fondo dorado; alineado con otras pantallas)
          Padding(
            padding: const EdgeInsets.all(20),
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
                _buildStatRow(
                  AppLocalizations.of(context)!.rarity,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: rarityColorFromSprite(widget.weapon.rarity)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: rarityColorFromSprite(widget.weapon.rarity)
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      widget.weapon.rarity.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: rarityColorFromSprite(widget.weapon.rarity),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.physicalDamage}:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${widget.weapon.damage.display}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.gps_fixed,
                          size: 18,
                          color: Colors.red[400],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildStatRow(
                  AppLocalizations.of(context)!.affinity,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.weapon.affinity > 0 ? '+' : ''}${widget.weapon.affinity}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.trending_up,
                          size: 18, color: colorScheme.primary),
                    ],
                  ),
                ),
                if (widget.weapon.defenseBonus > 0) ...[
                  const Divider(height: 24),
                  _buildStatRow(
                    AppLocalizations.of(context)!.defenseBonus,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "+${widget.weapon.defenseBonus}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.shield,
                            size: 18, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ],
                if (widget.weapon.elderseal != null) ...[
                  const Divider(height: 24),
                  _buildStatRow(
                    AppLocalizations.of(context)!.elderseal,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.weapon.elderseal![0].toUpperCase() +
                              widget.weapon.elderseal!.substring(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.auto_awesome,
                            size: 18, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ],
                if (widget.weapon.slots.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildStatRow(AppLocalizations.of(context)!.slots,
                      _buildSlotsDisplay()),
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
          // Título de la sección (sin fondo dorado; alineado con otras pantallas)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.content_cut,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.sharpness,
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
                          AppLocalizations.of(context)!.sharpnessRed,
                          Colors.red[400]!,
                          widget.weapon.sharpness.red),
                    if (widget.weapon.sharpness.orange > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessOrange,
                          Colors.orange[400]!,
                          widget.weapon.sharpness.orange),
                    if (widget.weapon.sharpness.yellow > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessYellow,
                          Colors.yellow[600]!,
                          widget.weapon.sharpness.yellow),
                    if (widget.weapon.sharpness.green > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessGreen,
                          Colors.green[400]!,
                          widget.weapon.sharpness.green),
                    if (widget.weapon.sharpness.blue > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessBlue,
                          Colors.blue[400]!,
                          widget.weapon.sharpness.blue),
                    if (widget.weapon.sharpness.white > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessWhite,
                          Colors.white,
                          widget.weapon.sharpness.white),
                    if (widget.weapon.sharpness.purple > 0)
                      _buildSharpnessLegend(
                          AppLocalizations.of(context)!.sharpnessPurple,
                          Colors.purple[400]!,
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
          // Título de la sección (sin fondo dorado; alineado con otras pantallas)
          Padding(
            padding: const EdgeInsets.all(20),
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
                                    child: SkillSpriteIcon(
                                      iconId: skillInfo.icon?.id,
                                      iconKind: skillInfo.icon?.kind,
                                      size: 40,
                                      fallback: Icon(
                                        Icons.auto_awesome,
                                        size: 22,
                                        color: colorScheme.primary,
                                      ),
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
                                        "${AppLocalizations.of(context)!.lv} ${rank.level}",
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
    final hasCraftingMaterialRows =
        widget.weapon.crafting.craftingMaterials.isNotEmpty ||
            widget.weapon.crafting.upgradeMaterials.isNotEmpty;
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Row(
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                if (widget.weapon.crafting.craftingMaterials.isNotEmpty) ...[
                  _buildCostLabel(AppLocalizations.of(context)!.craft),
                  const SizedBox(height: 8),
                  _buildMaterialsSection(
                    widget.weapon.crafting.craftingMaterials,
                  ),
                ],
                if (widget.weapon.crafting.craftingMaterials.isNotEmpty &&
                    widget.weapon.crafting.upgradeMaterials.isNotEmpty) ...[
                  const SizedBox(height: 16),
                ],
                if (widget.weapon.crafting.upgradeMaterials.isNotEmpty) ...[
                  _buildCostLabel(AppLocalizations.of(context)!.upgrade),
                  const SizedBox(height: 8),
                  _buildMaterialsSection(
                    widget.weapon.crafting.upgradeMaterials,
                  ),
                ],
                if (widget.weapon.crafting.craftingZennyCost > 0 ||
                    widget.weapon.crafting.upgradeZennyCost > 0) ...[
                  const SizedBox(height: 20),
                  // Lista vacía: ancho completo para centrar chips. Con materiales: Wrap
                  // estrecho para que la Column (crossAxis por defecto) lo centre como antes.
                  Builder(
                    builder: (context) {
                      final chips = <Widget>[
                        if (widget.weapon.crafting.craftingZennyCost > 0)
                          _buildCostChip(
                            AppLocalizations.of(context)!.craft,
                            widget.weapon.crafting.craftingZennyCost,
                          ),
                        if (widget.weapon.crafting.upgradeZennyCost > 0)
                          _buildCostChip(
                            AppLocalizations.of(context)!.upgrade,
                            widget.weapon.crafting.upgradeZennyCost,
                          ),
                      ];
                      final wrap = Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: chips,
                      );
                      if (hasCraftingMaterialRows) {
                        return wrap;
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: wrap,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          ],
        ),
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

  Widget _buildCostLabel(String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
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
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: MaterialImage(
                      item: material.item,
                      width: 40,
                      height: 40,
                      materialName:
                          (Provider.of<EnNamesCache>(context, listen: false)
                                  .nameForItemImage(
                                      material.item.id, material.item.name) ??
                              material.item.name),
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
      children: widget.weapon.slots.map((slot) {
        final Color slotColor = _slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 20,
            fallback: Container(
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
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _slotColor(int slot) {
    switch (slot) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<Widget> _buildWeaponTypeSpecificStats() {
    final List<Widget> stats = [];

    // Daño elemental/status si está disponible
    final elementalStats = WeaponDisplayUtils.buildElementalDamageRow(
        context, widget.weapon,
        isDetailView: true);
    if (elementalStats is! SizedBox) {
      stats.add(const Divider(height: 24));
      stats.add(elementalStats);
    }

    // Información específica según el tipo de arma
    final additionalInfo = WeaponDisplayUtils.buildAdditionalDamageInfo(
        context, widget.weapon,
        isDetailView: true);
    if (additionalInfo is! SizedBox) {
      stats.add(const Divider(height: 24));
      stats.add(additionalInfo);
    }

    return stats;
  }

  bool _hasWeaponTreeData() {
    return widget.weapon.crafting.previous != null ||
        widget.weapon.crafting.branches.isNotEmpty;
  }

  Widget _buildWeaponTreeSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = Provider.of<WeaponsProvider>(context, listen: false);
    
    final rootNode = WeaponTreeBuilder.buildTree(widget.weapon, provider);
    if (rootNode == null) return const SizedBox.shrink();

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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Row(
            children: [
              Icon(
                Icons.account_tree,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.weaponTree ?? 'Weapon Tree',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_tree, color: _isTreeView ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        _isTreeView = true;
                      });
                    },
                    tooltip: 'Tree View',
                  ),
                  IconButton(
                    icon: Icon(Icons.table_rows, color: !_isTreeView ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5)),
                    onPressed: () {
                      setState(() {
                        _isTreeView = false;
                      });
                    },
                    tooltip: 'Table View',
                  ),
                ],
              )
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _isTreeView
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildVisualTree(rootNode),
                    )
                  : _buildVisualTable(WeaponTreeBuilder.flattenTree(rootNode)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualTree(TreeNode node, {int depth = 0, List<bool> isLastChildPath = const []}) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isCurrentWeapon = node.weapon.id == widget.weapon.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lines for previous depths
              for (int i = 0; i < depth - 1; i++)
                SizedBox(
                  width: 24,
                  child: isLastChildPath[i]
                      ? null
                      : CustomPaint(
                          painter: StraightLinePainter(
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                ),
              // Line for current depth
              if (depth > 0)
                SizedBox(
                  width: 24,
                  child: CustomPaint(
                    painter: TreeConnectorPainter(
                      isLastChild: isLastChildPath.last,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                ),
              // Node content
              Container(
                margin: const EdgeInsets.only(bottom: 4, top: 4, left: 4),
                decoration: BoxDecoration(
                  color: isCurrentWeapon
                      ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrentWeapon
                      ? Border.all(color: colorScheme.primary, width: 1)
                      : null,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (!isCurrentWeapon) {
                      _navigateToWeaponById(node.weapon.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      children: [
                        GearSpriteIcon(
                          column: weaponColumnByKind[node.weapon.kind] ?? 0,
                          rarity: node.weapon.rarity,
                          size: 24,
                          fallback: Icon(
                            WeaponUtils.getWeaponIcon(node.weapon.kind),
                            color: WeaponUtils.getKindColor(node.weapon.kind),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                node.weapon.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isCurrentWeapon ? FontWeight.bold : FontWeight.w500,
                                  color: isCurrentWeapon ? colorScheme.primary : colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (_hasSharpnessDataForWeapon(node.weapon)) ...[
                              const SizedBox(height: 4),
                              SizedBox(
                                width: 80,
                                child: SharpnessBar(
                                  sharpness: node.weapon.sharpness,
                                  height: 6,
                                  borderRadius: 2,
                                ),
                              ),
                              ],
                              const SizedBox(height: 4),
                              RarityChip(
                                rarity: node.weapon.rarity,
                                fontSize: 10,
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildMiniStats(node.weapon),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (node.children.isNotEmpty)
          ...node.children.asMap().entries.map((entry) {
            final isLast = entry.key == node.children.length - 1;
            return _buildVisualTree(
              entry.value,
              depth: depth + 1,
              isLastChildPath: [...isLastChildPath, isLast],
            );
          }),
      ],
    );
  }

  Widget _buildVisualTable(List<Weapon> allWeapons) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: allWeapons.map((w) {
        final bool isCurrent = w.id == widget.weapon.id;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isCurrent ? colorScheme.primaryContainer.withOpacity(0.2) : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrent ? colorScheme.primary : colorScheme.outlineVariant,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isCurrent ? null : () => _navigateToWeaponById(w.id),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GearSpriteIcon(
                    column: weaponColumnByKind[w.kind] ?? 0,
                    rarity: w.rarity,
                    size: 32,
                    fallback: Icon(WeaponUtils.getWeaponIcon(w.kind), size: 24, color: WeaponUtils.getKindColor(w.kind)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                            if (w.crafting.craftingMaterials.isNotEmpty || w.crafting.upgradeMaterials.isNotEmpty)
                              InkWell(
                                onTap: () => _showCraftingModal(w),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(Icons.remove_red_eye, size: 18, color: colorScheme.primary),
                                ),
                              ),
                          ],
                        ),
                        if (_hasSharpnessDataForWeapon(w)) ...[
                          const SizedBox(height: 4),
                          SharpnessBar(
                            sharpness: w.sharpness,
                            height: 6,
                            borderRadius: 2,
                          ),
                          const SizedBox(height: 4),
                        ],
                        RarityChip(
                          rarity: w.rarity,
                          fontSize: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildMiniStats(w),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMiniStats(Weapon w) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Extraer especial si existe
    WeaponSpecial? special;
    if (w.specials is List && w.specials.isNotEmpty) {
      try {
        special = WeaponSpecial.fromJson(w.specials[0]);
      } catch (_) {}
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.gps_fixed, size: 14, color: Colors.red[400]),
            const SizedBox(width: 2),
            Text('${w.damage.display}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        
        if (w.affinity != 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up, size: 14, color: colorScheme.primary),
              const SizedBox(width: 2),
              Text('${w.affinity}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        
        if (special != null && special.damage.display > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(WeaponUtils.getElementIcon(special.element), size: 14, color: WeaponUtils.getElementColor(special.element)),
              const SizedBox(width: 2),
              Text('${special.damage.display}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
      ],
    );
  }

  bool _hasSharpnessDataForWeapon(Weapon w) {
    final s = w.sharpness;
    return s.red > 0 || s.orange > 0 || s.yellow > 0 || s.green > 0 || s.blue > 0 || s.white > 0 || s.purple > 0;
  }

  void _showCraftingModal(Weapon w) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.craftingMaterials} - ${w.name}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (w.crafting.craftingMaterials.isNotEmpty) ...[
                        _buildCostLabel(AppLocalizations.of(context)!.craft),
                        const SizedBox(height: 8),
                        _buildMaterialsSection(w.crafting.craftingMaterials),
                      ],
                      if (w.crafting.craftingMaterials.isNotEmpty && w.crafting.upgradeMaterials.isNotEmpty)
                        const SizedBox(height: 16),
                      if (w.crafting.upgradeMaterials.isNotEmpty) ...[
                        _buildCostLabel(AppLocalizations.of(context)!.upgrade),
                        const SizedBox(height: 8),
                        _buildMaterialsSection(w.crafting.upgradeMaterials),
                      ],
                      if (w.crafting.craftingZennyCost > 0 || w.crafting.upgradeZennyCost > 0) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            if (w.crafting.craftingZennyCost > 0)
                              _buildCostChip(AppLocalizations.of(context)!.craft, w.crafting.craftingZennyCost),
                            if (w.crafting.upgradeZennyCost > 0)
                              _buildCostChip(AppLocalizations.of(context)!.upgrade, w.crafting.upgradeZennyCost),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToWeaponById(int id) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      final weapon = await WeaponsApi.fetchWeaponById(id);
      if (mounted) {
        Navigator.pop(context); // close dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeaponDetails(weapon: weapon),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading weapon details')),
        );
      }
    }
  }

  bool _hasCraftingData() {
    return widget.weapon.crafting.craftingMaterials.isNotEmpty ||
        widget.weapon.crafting.upgradeMaterials.isNotEmpty ||
        widget.weapon.crafting.craftingZennyCost > 0 ||
        widget.weapon.crafting.upgradeZennyCost > 0;
  }
}
