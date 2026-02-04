import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/en_names_cache.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';
import 'package:mhwilds_app/components/sharpness_bar.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:provider/provider.dart';

part 'weapons_list/display_utils.dart';
part 'weapons_list/weapon_card.dart';
part 'weapons_list/damage_info.dart';
part 'weapons_list/slots_and_sharpness.dart';

class WeaponsList extends StatefulWidget {
  const WeaponsList({super.key});

  @override
  _WeaponsListState createState() => _WeaponsListState();
}

class _WeaponsListState extends State<WeaponsList> {
  final TextEditingController _searchNameController = TextEditingController();
  String _searchNameQuery = '';
  String? _selectedKind;
  int? _selectedRarity;
  bool _filtersVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weaponsProvider =
          Provider.of<WeaponsProvider>(context, listen: false);
      if (!weaponsProvider.hasData) {
        weaponsProvider.fetchWeapons();
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
      _selectedKind = null;
      _selectedRarity = null;
      _searchNameController.clear();
    });
    print('WeaponsList: _selectedKind reset to: "$_selectedKind"');
    final provider = Provider.of<WeaponsProvider>(context, listen: false);
    provider.clearFilters();

    // Debug: Verificar que el provider se haya limpiado
    print(
        'WeaponsList: Provider filters cleared, weapons count: ${provider.weapons.length}');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weaponsProvider = Provider.of<WeaponsProvider>(context);
    final filteredWeapons = weaponsProvider.weapons;

    if (!weaponsProvider.hasData && !weaponsProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = Provider.of<WeaponsProvider>(context, listen: false);
        if (!p.hasData && !p.isLoading) p.fetchWeapons();
      });
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Column(
        children: [
          if (_filtersVisible) _buildFiltersSection(context, weaponsProvider),
          Expanded(
              child:
                  _buildWeaponsList(context, weaponsProvider, filteredWeapons)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: colorScheme.primary,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(
      BuildContext context, WeaponsProvider weaponsProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      height: 350, // Altura fija para los filtros
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
          // Header de filtros (fijo)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.filters,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(AppLocalizations.of(context)!.reset),
                  style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary),
                ),
              ],
            ),
          ),
          // Contenido de filtros con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(context, weaponsProvider),
                  const SizedBox(height: 16),
                  _buildTypeFilter(context, weaponsProvider),
                  const SizedBox(height: 16),
                  _buildRarityFilter(context, weaponsProvider),
                  const SizedBox(height: 20), // Espacio al final para scroll
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
      BuildContext context, WeaponsProvider weaponsProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: _searchNameController,
      onChanged: (query) {
        setState(() {
          _searchNameQuery = query;
        });
        weaponsProvider.applyFilters(
          name: _searchNameQuery,
          kind: _selectedKind,
          rarity: _selectedRarity,
        );
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.searchByName,
        hintText: AppLocalizations.of(context)!.enterWeaponName,
        prefixIcon: Icon(Icons.search, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildTypeFilter(
      BuildContext context, WeaponsProvider weaponsProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    final weaponTypes = [
      'great-sword',
      'long-sword',
      'sword-shield',
      'dual-blades',
      'hammer',
      'hunting-horn',
      'lance',
      'gunlance',
      'switch-axe',
      'charge-blade',
      'insect-glaive',
      'bow',
      'light-bowgun',
      'heavy-bowgun'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.type,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: weaponTypes.map((kind) {
            return FilterChip(
              label: Text(
                _getWeaponKindLabel(context, kind),
                style: TextStyle(
                  color: _selectedKind == kind
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: _getKindColor(kind).withOpacity(0.2),
              selectedColor: _getKindColor(kind),
              selected: _selectedKind == kind,
              onSelected: (isSelected) {
                setState(() {
                  _selectedKind = isSelected ? kind : null;
                });
                weaponsProvider.applyFilters(
                  name: _searchNameQuery,
                  kind: _selectedKind,
                  rarity: _selectedRarity,
                );
              },
              elevation: 2,
              pressElevation: 4,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRarityFilter(
      BuildContext context, WeaponsProvider weaponsProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.rarity,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [1, 2, 3, 4, 5, 6, 7].map((rarity) {
            return FilterChip(
              label: Text(
                AppLocalizations.of(context)!.rarityLevel(rarity),
                style: TextStyle(
                  color: _selectedRarity == rarity
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: _getRarityColor(rarity).withOpacity(0.2),
              selectedColor: _getRarityColor(rarity),
              selected: _selectedRarity == rarity,
              onSelected: (isSelected) {
                setState(() {
                  _selectedRarity = isSelected ? rarity : null;
                });
                weaponsProvider.applyFilters(
                  name: _searchNameQuery,
                  kind: _selectedKind,
                  rarity: _selectedRarity,
                );
              },
              elevation: 2,
              pressElevation: 4,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWeaponsList(BuildContext context,
      WeaponsProvider weaponsProvider, List<Weapon> filteredWeapons) {
    final colorScheme = Theme.of(context).colorScheme;
    if (weaponsProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loadingWeapons,
              style: TextStyle(
                  fontSize: 16, color: colorScheme.onSurface.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    if (filteredWeapons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noWeaponsFound,
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.tryAdjustingFilters,
              style: TextStyle(
                  fontSize: 14, color: colorScheme.onSurface.withOpacity(0.6)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredWeapons.length,
      itemBuilder: (context, index) {
        return _buildWeaponCard(filteredWeapons[index], index);
      },
    );
  }

  Widget _buildWeaponCard(Weapon weapon, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeaponDetails(weapon: weapon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeaponHeader(weapon),
                const SizedBox(height: 16),
                _buildWeaponStats(weapon),
                if (_hasSharpnessData(weapon)) ...[
                  const SizedBox(height: 16),
                  _buildSharpnessSection(weapon),
                ],
                if (weapon.slots.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildWeaponSlots(weapon),
                ],
                if (weapon.skills.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildWeaponSkills(weapon),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponHeader(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _getKindColor(weapon.kind).withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getWeaponIcon(weapon.kind),
            color: _getKindColor(weapon.kind),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weapon.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              _buildWeaponTypeChip(weapon.kind),
              const SizedBox(height: 8),
              _buildRarityChip(weapon.rarity),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios,
            color: colorScheme.onSurface.withOpacity(0.6), size: 20),
      ],
    );
  }

  Widget _buildWeaponTypeChip(String kind) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getKindColor(kind).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getKindColor(kind).withOpacity(0.3)),
      ),
      child: Text(
        _getWeaponKindLabel(context, kind),
        style: TextStyle(
          fontSize: 12,
          color: _getKindColor(kind),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRarityChip(int rarity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRarityColor(rarity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getRarityColor(rarity).withOpacity(0.3)),
      ),
      child: Text(
        AppLocalizations.of(context)!.rarityLevel(rarity),
        style: TextStyle(
          fontSize: 12,
          color: _getRarityColor(rarity),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildWeaponStats(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de daño físico
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.physicalDamage}:',
              style: TextStyle(
                fontSize: 12,
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
                  '${weapon.damage.display}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Sección de affinity
        if (weapon.affinity != 0) ...[
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '${AppLocalizations.of(context)!.affinity}:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    '${weapon.affinity > 0 ? '+' : ''}${weapon.affinity}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        // Sección de daño elemental si está disponible
        if (weapon.specials != null) ...[
          WeaponDisplayUtils.buildElementalDamageRow(context, weapon),
        ],
        // Solo añadir espacio si hay daño elemental
        if (weapon.specials != null && _hasElementalDamage(weapon)) ...[
          const SizedBox(height: 12),
        ],
        // Sección de defense bonus
        if (weapon.defenseBonus > 0) ...[
          Row(
            children: [
              Icon(
                Icons.shield,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '${AppLocalizations.of(context)!.defense}:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.add_circle,
                    size: 16,
                    color: Colors.green[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${weapon.defenseBonus}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        // Sección de información adicional específica del tipo de arma
        if (_hasAdditionalDamageInfo(weapon)) ...[
          const SizedBox(height: 12),
          _buildAdditionalDamageInfo(weapon),
        ],
      ],
    );
  }

  // Método auxiliar para verificar si hay daño elemental
  bool _hasElementalDamage(Weapon weapon) {
    if (weapon.specials is List) {
      final specials = weapon.specials as List;
      return specials.any((special) {
        if (special is Map<String, dynamic>) {
          return (special['kind'] == 'element' ||
                  special['kind'] == 'status') &&
              special['damage'] != null &&
              special['damage']['raw'] > 0;
        }
        return false;
      });
    }
    return false;
  }

  // Método auxiliar para verificar si hay información adicional de daño
  bool _hasAdditionalDamageInfo(Weapon weapon) {
    switch (weapon.kind) {
      case 'bow':
        return weapon.coatings != null && weapon.coatings!.isNotEmpty;
      case 'charge-blade':
        return weapon.phial != null;
      case 'gunlance':
        return weapon.shell != null && weapon.shellLevel != null;
      case 'switch-axe':
        return weapon.phial != null;
      case 'hunting-horn':
        return weapon.melody != null ||
            weapon.echoBubble != null ||
            weapon.echoWave != null;
      case 'heavy-bowgun':
      case 'light-bowgun':
        return weapon.ammo != null && weapon.ammo!.isNotEmpty;
      case 'insect-glaive':
        return weapon.kinsectLevel != null && weapon.kinsectLevel! > 0;
      default:
        return false;
    }
  }

  Widget _buildWeaponSkills(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.skills}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...weapon.skills.map((skill) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Imagen de la habilidad
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        child: UrlImageLoader(
                          itemName:
                              (Provider.of<EnNamesCache>(context, listen: false)
                                      .nameForSkillImage(
                                          skill.skill.id, skill.skill.name) ??
                                  skill.skill.name),
                          loadImageUrlFunction: getValidSkillImageUrl,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (skill.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      skill.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            )),
      ],
    );
  }

  String _getWeaponKindLabel(BuildContext context, String kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case 'great-sword':
        return l10n.weaponKindGreatSword;
      case 'long-sword':
        return l10n.weaponKindLongSword;
      case 'sword-shield':
        return l10n.weaponKindSwordShield;
      case 'dual-blades':
        return l10n.weaponKindDualBlades;
      case 'hammer':
        return l10n.weaponKindHammer;
      case 'hunting-horn':
        return l10n.weaponKindHuntingHorn;
      case 'lance':
        return l10n.weaponKindLance;
      case 'gunlance':
        return l10n.weaponKindGunlance;
      case 'switch-axe':
        return l10n.weaponKindSwitchAxe;
      case 'charge-blade':
        return l10n.weaponKindChargeBlade;
      case 'insect-glaive':
        return l10n.weaponKindInsectGlaive;
      case 'bow':
        return l10n.weaponKindBow;
      case 'light-bowgun':
        return l10n.weaponKindLightBowgun;
      case 'heavy-bowgun':
        return l10n.weaponKindHeavyBowgun;
      default:
        return kind;
    }
  }

  IconData _getWeaponIcon(String kind) {
    switch (kind) {
      case 'great-sword':
      case 'long-sword':
      case 'dual-blades':
      case 'lance':
      case 'gunlance':
      case 'switch-axe':
      case 'charge-blade':
      case 'insect-glaive':
      case 'light-bowgun':
      case 'heavy-bowgun':
        return Icons.gps_fixed;
      case 'sword-shield':
        return Icons.shield;
      case 'hammer':
        return Icons.build;
      case 'hunting-horn':
        return Icons.music_note;
      case 'bow':
        return Icons.arrow_upward;
      default:
        return Icons.gps_fixed;
    }
  }

  Color _getKindColor(String kind) {
    switch (kind) {
      case 'great-sword':
        return Colors.red[400]!;
      case 'long-sword':
        return Colors.orange[400]!;
      case 'sword-shield':
        return Colors.blue[400]!;
      case 'dual-blades':
        return Colors.purple[400]!;
      case 'hammer':
        return Colors.brown[400]!;
      case 'hunting-horn':
        return Colors.green[400]!;
      case 'lance':
        return Colors.indigo[400]!;
      case 'gunlance':
        return Colors.teal[400]!;
      case 'switch-axe':
        return Colors.deepOrange[400]!;
      case 'charge-blade':
        return Colors.cyan[400]!;
      case 'insect-glaive':
        return Colors.lime[400]!;
      case 'bow':
        return Colors.amber[400]!;
      case 'light-bowgun':
        return Colors.pink[400]!;
      case 'heavy-bowgun':
        return Colors.deepPurple[400]!;
      default:
        return Colors.grey[400]!;
    }
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 1:
        return Colors.grey[400]!;
      case 2:
        return Colors.green[400]!;
      case 3:
        return Colors.blue[400]!;
      case 4:
        return Colors.purple[400]!;
      case 5:
        return Colors.orange[400]!;
      case 6:
        return Colors.red[400]!;
      case 7:
        return Colors.amber[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
