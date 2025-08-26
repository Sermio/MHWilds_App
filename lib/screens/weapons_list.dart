import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';
import 'package:mhwilds_app/screens/weapon_details.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';
import 'package:mhwilds_app/utils/utils.dart';
import 'package:mhwilds_app/components/url_image_loader.dart';
import 'package:provider/provider.dart';

class WeaponsList extends StatefulWidget {
  const WeaponsList({super.key});

  @override
  _WeaponsListState createState() => _WeaponsListState();
}

// Clase estática para métodos auxiliares reutilizables
class WeaponDisplayUtils {
  static Widget buildElementalDamageRow(Weapon weapon) {
    // Buscar specials con daño elemental o de status, y también daño de phial
    if (weapon.specials is List) {
      final specials = weapon.specials as List;
      final elementalAndStatusSpecials = specials.where((special) {
        if (special is Map<String, dynamic>) {
          return (special['kind'] == 'element' ||
                  special['kind'] == 'status') &&
              special['damage'] != null &&
              special['damage']['raw'] > 0;
        }
        return false;
      }).toList();

      // También buscar phial damage si existe
      final phialSpecial = specials.where((special) {
        if (special is Map<String, dynamic>) {
          return special['phial'] != null &&
              special['phial']['damage'] != null &&
              special['phial']['damage']['raw'] > 0;
        }
        return false;
      }).toList();

      // Priorizar specials elementales/status, luego phial
      if (elementalAndStatusSpecials.isNotEmpty) {
        final special = elementalAndStatusSpecials.first;
        final elementOrStatus = special['kind'] == 'element'
            ? (special['element'] ?? '')
            : (special['status'] ?? '');
        final damage = special['damage'];
        final damageValue = damage?['display'] ?? damage?['raw'] ?? 0;

        if (damageValue > 0) {
          return Row(
            children: [
              // Icono representativo antes del texto
              Container(
                width: 16,
                height: 16,
                child: Image.asset(
                  'assets/imgs/elements/${elementOrStatus.toLowerCase()}.webp',
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback a icono si no existe la imagen
                    return Icon(
                      WeaponUtils.getElementIcon(elementOrStatus),
                      size: 16,
                      color: WeaponUtils.getElementColor(elementOrStatus),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              Text(
                special['kind'] == 'element' ? 'Element:' : 'Status Effect:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  // Quitar el icono de flash y mostrar solo el valor
                  Text(
                    '$damageValue',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: WeaponUtils.getElementColor(elementOrStatus),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Poner el icono del elemento después del valor
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(
                      'assets/imgs/elements/${elementOrStatus.toLowerCase()}.webp',
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback a icono si no existe la imagen
                        return Icon(
                          WeaponUtils.getElementIcon(elementOrStatus),
                          size: 16,
                          color: WeaponUtils.getElementColor(elementOrStatus),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      } else if (phialSpecial.isNotEmpty) {
        // Mostrar daño de phial si no hay specials elementales/status
        final special = phialSpecial.first;
        final phial = special['phial'];
        final phialKind = phial['kind'] ?? '';
        final phialDamage = phial['damage'];
        final phialDamageValue =
            phialDamage?['display'] ?? phialDamage?['raw'] ?? 0;

        if (phialDamageValue > 0) {
          return Row(
            children: [
              // Icono representativo para phial
              Container(
                width: 16,
                height: 16,
                child: Image.asset(
                  'assets/imgs/elements/${phialKind.toLowerCase()}.webp',
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback a icono si no existe la imagen
                    return Icon(
                      WeaponUtils.getElementIcon(phialKind),
                      size: 16,
                      color: WeaponUtils.getElementColor(phialKind),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Phial:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 4),
              Row(
                children: [
                  Text(
                    '$phialDamageValue',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: WeaponUtils.getElementColor(phialKind),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(
                      'assets/imgs/elements/${phialKind.toLowerCase()}.webp',
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          WeaponUtils.getElementIcon(phialKind),
                          size: 16,
                          color: WeaponUtils.getElementColor(phialKind),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      }
    }

    return const SizedBox.shrink();
  }

  static Widget buildAdditionalDamageInfo(Weapon weapon) {
    // Solo manejar información específica del tipo de arma (no daño elemental)
    switch (weapon.kind) {
      case 'bow':
        return buildBowDamageInfo(weapon);
      case 'charge-blade':
        return buildChargeBladeDamageInfo(weapon);
      case 'gunlance':
        return buildGunlanceDamageInfo(weapon);
      case 'switch-axe':
        return buildSwitchAxeDamageInfo(weapon);
      case 'hunting-horn':
        return buildHuntingHornDamageInfo(weapon);
      case 'heavy-bowgun':
      case 'light-bowgun':
        return buildBowgunDamageInfo(weapon);
      case 'insect-glaive':
        return buildInsectGlaiveDamageInfo(weapon);
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget buildBowDamageInfo(Weapon weapon) {
    // Para bows, mostrar información sobre coatings si están disponibles
    try {
      if (weapon.coatings != null && weapon.coatings!.isNotEmpty) {
        return Row(
          children: [
            Icon(
              Icons.arrow_upward,
              size: 16,
              color: Colors.amber[400],
            ),
            const SizedBox(width: 6),
            Text(
              'Coatings:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: weapon.coatings!.map((coating) {
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCoatingColor(coating),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono del elemento/status si existe
                      if (_hasElementIcon(coating)) ...[
                        Image.asset(
                          'assets/imgs/elements/${_getElementAssetName(coating)}.webp',
                          width: 12,
                          height: 12,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              WeaponUtils.getElementIcon(coating),
                              size: 12,
                              color: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        coating[0].toUpperCase() + coating.substring(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  static Widget buildChargeBladeDamageInfo(Weapon weapon) {
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    return Row(
      children: [
        Icon(
          Icons.flash_on,
          size: 16,
          color: Colors.blue[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Phial:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            // Icono del elemento si es un phial elemental
            if (_hasElementIcon(phialKind)) ...[
              Image.asset(
                'assets/imgs/elements/${_getElementAssetName(phialKind)}.webp',
                width: 16,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    WeaponUtils.getElementIcon(phialKind),
                    size: 16,
                    color: phialKind == 'impact'
                        ? Colors.blue[600]!
                        : Colors.orange[600]!,
                  );
                },
              ),
              const SizedBox(width: 4),
            ] else ...[
              Icon(
                Icons.electric_bolt,
                size: 16,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              phialKind[0].toUpperCase() + phialKind.substring(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildGunlanceDamageInfo(Weapon weapon) {
    if (weapon.shell == null || weapon.shellLevel == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          size: 16,
          color: Colors.red[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Shell:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(
              Icons.local_fire_department,
              size: 16,
              color: Colors.red[600]!,
            ),
            const SizedBox(width: 4),
            Text(
              '${weapon.shell![0].toUpperCase() + weapon.shell!.substring(1)} Lv${weapon.shellLevel}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.red[600]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildSwitchAxeDamageInfo(Weapon weapon) {
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    return Row(
      children: [
        Icon(
          Icons.transform,
          size: 16,
          color: Colors.orange[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Phial:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            // Icono del elemento si es un phial elemental
            if (_hasElementIcon(phialKind)) ...[
              Image.asset(
                'assets/imgs/elements/${_getElementAssetName(phialKind)}.webp',
                width: 16,
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    WeaponUtils.getElementIcon(phialKind),
                    size: 16,
                    color: phialKind == 'impact'
                        ? Colors.blue[600]!
                        : Colors.orange[600]!,
                  );
                },
              ),
              const SizedBox(width: 4),
            ] else ...[
              Icon(
                Icons.electric_bolt,
                size: 16,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              phialKind[0].toUpperCase() + phialKind.substring(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildHuntingHornDamageInfo(Weapon weapon) {
    final List<Widget> sections = [];

    if (weapon.melody != null) {
      sections.add(Row(
        children: [
          Icon(Icons.music_note, size: 16, color: Colors.teal[400]),
          const SizedBox(width: 6),
          Text(
            'Melody:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.music_note, size: 16, color: Colors.teal[600]),
              const SizedBox(width: 4),
              Text(
                '${weapon.melody!.songs.length} songs',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[600],
                ),
              ),
            ],
          ),
        ],
      ));
    }

    if (weapon.echoBubble != null) {
      sections.add(Row(
        children: [
          Icon(Icons.bubble_chart, size: 16, color: Colors.indigo[400]),
          const SizedBox(width: 6),
          Text(
            'Echo Bubble:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.bubble_chart, size: 16, color: Colors.indigo[600]),
              const SizedBox(width: 4),
              Text(
                weapon.echoBubble!.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
        ],
      ));
    }

    if (weapon.echoWave != null) {
      sections.add(Row(
        children: [
          Icon(Icons.waves, size: 16, color: Colors.orange[400]),
          const SizedBox(width: 6),
          Text(
            'Echo Wave:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.waves, size: 16, color: Colors.orange[600]),
              const SizedBox(width: 4),
              Text(
                weapon.echoWave!.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
        ],
      ));
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: sections,
    );
  }

  static Widget buildBowgunDamageInfo(Weapon weapon) {
    if (weapon.ammo == null || weapon.ammo!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          weapon.kind == 'heavy-bowgun' ? Icons.gps_fixed : Icons.speed,
          size: 16,
          color: weapon.kind == 'heavy-bowgun'
              ? Colors.purple[400]
              : Colors.green[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Ammo:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: weapon.ammo!.take(3).map((ammo) {
            return Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: weapon.kind == 'heavy-bowgun'
                    ? Colors.purple[100]
                    : Colors.green[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: weapon.kind == 'heavy-bowgun'
                      ? Colors.purple[300]!
                      : Colors.green[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono del elemento/status si existe
                  if (_hasElementIcon(ammo.kind)) ...[
                    Image.asset(
                      'assets/imgs/elements/${_getElementAssetName(ammo.kind)}.webp',
                      width: 12,
                      height: 12,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          WeaponUtils.getElementIcon(ammo.kind),
                          size: 12,
                          color: weapon.kind == 'heavy-bowgun'
                              ? Colors.purple[800]
                              : Colors.green[800],
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    '${ammo.kind[0].toUpperCase() + ammo.kind.substring(1)} Lv${ammo.level}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: weapon.kind == 'heavy-bowgun'
                          ? Colors.purple[800]
                          : Colors.green[800],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildInsectGlaiveDamageInfo(Weapon weapon) {
    if (weapon.kinsectLevel == null || weapon.kinsectLevel! <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Icons.flutter_dash,
          size: 16,
          color: Colors.lime[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Kinsect:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(Icons.flutter_dash, size: 16, color: Colors.lime[600]),
            const SizedBox(width: 4),
            Text(
              'Lv${weapon.kinsectLevel}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Métodos auxiliares estáticos
  static bool _hasElementIcon(String element) {
    final elementTypes = [
      'fire',
      'water',
      'ice',
      'thunder',
      'dragon',
      'poison',
      'paralysis',
      'sleep',
      'blast'
    ];
    return elementTypes.any((type) => element.toLowerCase().contains(type));
  }

  static String _getElementAssetName(String element) {
    final elementLower = element.toLowerCase();
    if (elementLower.contains('fire')) return 'fire';
    if (elementLower.contains('water')) return 'water';
    if (elementLower.contains('ice')) return 'ice';
    if (elementLower.contains('thunder')) return 'thunder';
    if (elementLower.contains('dragon')) return 'dragon';
    if (elementLower.contains('poison')) return 'poison';
    if (elementLower.contains('paralysis')) return 'paralysis';
    if (elementLower.contains('sleep')) return 'sleep';
    if (elementLower.contains('blast')) return 'blast';
    return 'fire'; // default
  }

  static Color _getCoatingColor(String coating) {
    switch (coating.toLowerCase()) {
      case 'power':
        return Colors.red[600]!;
      case 'paralysis':
        return Colors.amber[600]!;
      case 'poison':
        return Colors.green[600]!;
      case 'sleep':
        return Colors.indigo[600]!;
      case 'blast':
        return Colors.orange[600]!;
      case 'exhaust':
        return Colors.grey[600]!;
      case 'close-range':
        return Colors.blue[600]!;
      case 'pierce':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
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
    print('WeaponsList: Resetting filters');
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
    final weaponsProvider = Provider.of<WeaponsProvider>(context);
    final filteredWeapons = weaponsProvider.weapons;

    print(
        'WeaponsList: Building with _selectedKind: "$_selectedKind", filteredWeapons: ${filteredWeapons.length}');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          if (_filtersVisible) _buildFiltersSection(weaponsProvider),
          Expanded(child: _buildWeaponsList(weaponsProvider, filteredWeapons)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFiltersVisibility,
        backgroundColor: AppColors.goldSoft,
        child: Icon(
          _filtersVisible ? Icons.close : Icons.tune,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFiltersSection(WeaponsProvider weaponsProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 350, // Altura fija para los filtros
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                const Icon(Icons.filter_list, color: AppColors.goldSoft),
                const SizedBox(width: 8),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset'),
                  style:
                      TextButton.styleFrom(foregroundColor: AppColors.goldSoft),
                ),
              ],
            ),
          ),
          // Contenido de filtros con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(weaponsProvider),
                  const SizedBox(height: 16),
                  _buildTypeFilter(weaponsProvider),
                  const SizedBox(height: 16),
                  _buildRarityFilter(weaponsProvider),
                  const SizedBox(height: 20), // Espacio al final para scroll
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(WeaponsProvider weaponsProvider) {
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
        labelText: 'Search by Name',
        hintText: 'Enter weapon name...',
        prefixIcon: const Icon(Icons.search, color: AppColors.goldSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.goldSoft, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildTypeFilter(WeaponsProvider weaponsProvider) {
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
        const Text(
          'Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: weaponTypes.map((kind) {
            return FilterChip(
              label: Text(
                _formatWeaponKind(kind),
                style: TextStyle(
                  color: _selectedKind == kind ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: _getKindColor(kind).withOpacity(0.2),
              selectedColor: _getKindColor(kind),
              selected: _selectedKind == kind,
              onSelected: (isSelected) {
                print(
                    'WeaponsList: Filter selected - kind: "$kind", isSelected: $isSelected');
                setState(() {
                  _selectedKind = isSelected ? kind : null;
                });
                print('WeaponsList: _selectedKind set to: "$_selectedKind"');
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

  Widget _buildRarityFilter(WeaponsProvider weaponsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rarity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [1, 2, 3, 4, 5, 6, 7].map((rarity) {
            return FilterChip(
              label: Text(
                'Rarity $rarity',
                style: TextStyle(
                  color:
                      _selectedRarity == rarity ? Colors.white : Colors.black87,
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

  Widget _buildWeaponsList(
      WeaponsProvider weaponsProvider, List<Weapon> filteredWeapons) {
    if (weaponsProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.goldSoft),
            SizedBox(height: 16),
            Text(
              'Loading weapons...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No weapons found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
    return BounceInLeft(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: index * 50),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
      ),
    );
  }

  Widget _buildWeaponHeader(Weapon weapon) {
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
                color: AppColors.goldSoft.withOpacity(0.3),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              _buildWeaponTypeChip(weapon.kind),
              const SizedBox(height: 8),
              _buildRarityChip(weapon.rarity),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
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
        _formatWeaponKind(kind),
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
        'Rarity $rarity',
        style: TextStyle(
          fontSize: 12,
          color: _getRarityColor(rarity),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildWeaponStats(Weapon weapon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de daño físico
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Physical Damage:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
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
                    color: Colors.black87,
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
                color: AppColors.goldSoft,
              ),
              const SizedBox(width: 6),
              Text(
                'Affinity:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
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
                      color: Colors.black87,
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
          WeaponDisplayUtils.buildElementalDamageRow(weapon),
          const SizedBox(height: 12),
        ],
        // Sección de defense bonus
        if (weapon.defenseBonus > 0) ...[
          Row(
            children: [
              Icon(
                Icons.shield,
                size: 16,
                color: AppColors.goldSoft,
              ),
              const SizedBox(width: 6),
              Text(
                'Defense:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
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
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        // Sección de información adicional específica del tipo de arma
        _buildAdditionalDamageInfo(weapon),
      ],
    );
  }

  Widget _buildAdditionalDamageInfo(Weapon weapon) {
    // Solo manejar información específica del tipo de arma (no daño elemental)
    switch (weapon.kind) {
      case 'bow':
        return _buildBowDamageInfo(weapon);
      case 'charge-blade':
        return _buildChargeBladeDamageInfo(weapon);
      case 'gunlance':
        return _buildGunlanceDamageInfo(weapon);
      case 'switch-axe':
        return _buildSwitchAxeDamageInfo(weapon);
      case 'hunting-horn':
        return _buildHuntingHornDamageInfo(weapon);
      case 'heavy-bowgun':
      case 'light-bowgun':
        return _buildBowgunDamageInfo(weapon);
      case 'insect-glaive':
        return _buildInsectGlaiveDamageInfo(weapon);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHuntingHornDamageInfo(Weapon weapon) {
    try {
      final List<Widget> infoWidgets = [];

      // Melody info
      if (weapon.melody != null) {
        infoWidgets.add(_buildMelodyWidget(weapon.melody!));
      }

      // Echo Bubble info
      if (weapon.echoBubble != null) {
        infoWidgets.add(_buildEchoBubbleWidget(weapon.echoBubble!));
      }

      // Echo Wave info
      if (weapon.echoWave != null) {
        infoWidgets.add(_buildEchoWaveWidget(weapon.echoWave!));
      }

      if (infoWidgets.isNotEmpty) {
        return Column(
          children: infoWidgets
              .map((widget) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: widget,
                  ))
              .toList(),
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildMelodyWidget(HuntingHornMelody melody) {
    return Row(
      children: [
        Icon(Icons.music_note, size: 16, color: AppColors.goldSoft),
        const SizedBox(width: 6),
        Text(
          'Melody:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          '${melody.songs.length} songs',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.amber[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEchoBubbleWidget(HuntingHornBubble echoBubble) {
    return Row(
      children: [
        Icon(Icons.bubble_chart, size: 16, color: AppColors.goldSoft),
        const SizedBox(width: 6),
        Text(
          'Echo Bubble:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          echoBubble.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEchoWaveWidget(HuntingHornWave echoWave) {
    return Row(
      children: [
        Icon(Icons.waves, size: 16, color: AppColors.goldSoft),
        const SizedBox(width: 6),
        Text(
          'Echo Wave:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Text(
          echoWave.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.green[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBowgunDamageInfo(Weapon weapon) {
    try {
      if (weapon.ammo != null && weapon.ammo!.isNotEmpty) {
        return Row(
          children: [
            Icon(Icons.gps_fixed, size: 16, color: AppColors.goldSoft),
            const SizedBox(width: 6),
            Text(
              'Ammo:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: weapon.ammo!.take(3).map((ammo) {
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono del elemento si el ammo tiene tipo elemental
                      if (_hasElementIcon(ammo.kind)) ...[
                        Image.asset(
                          'assets/imgs/elements/${_getElementAssetName(ammo.kind)}.webp',
                          width: 12,
                          height: 12,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              WeaponUtils.getElementIcon(ammo.kind),
                              size: 12,
                              color: Colors.orange[700],
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '${ammo.kind[0].toUpperCase() + ammo.kind.substring(1)} Lv${ammo.level}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildInsectGlaiveDamageInfo(Weapon weapon) {
    try {
      if (weapon.kinsectLevel != null && weapon.kinsectLevel! > 0) {
        return Row(
          children: [
            Icon(Icons.flutter_dash, size: 16, color: AppColors.goldSoft),
            const SizedBox(width: 6),
            Text(
              'Kinsect:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Text(
              'Lv${weapon.kinsectLevel}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildElementalDamageInfo(List elementalSpecials) {
    if (elementalSpecials.isEmpty) return const SizedBox.shrink();

    // Mostrar el primer special elemental encontrado
    final special = elementalSpecials.first;
    final element = special['element'] ?? '';
    final damage = special['damage'];
    final damageValue = damage?['display'] ?? damage?['raw'] ?? 0;

    if (damageValue <= 0) return const SizedBox.shrink();

    return Row(
      children: [
        // Usar imagen de asset en lugar de icono de Flutter
        Container(
          width: 16,
          height: 16,
          child: Image.asset(
            'assets/imgs/elements/${element.toLowerCase()}.webp',
            errorBuilder: (context, error, stackTrace) {
              // Fallback a icono si no existe la imagen
              return Icon(
                WeaponUtils.getElementIcon(element),
                size: 16,
                color: WeaponUtils.getElementColor(element),
              );
            },
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${element[0].toUpperCase() + element.substring(1)}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: WeaponUtils.getElementColor(element),
            ),
            const SizedBox(width: 4),
            Text(
              '$damageValue',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: WeaponUtils.getElementColor(element),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBowDamageInfo(Weapon weapon) {
    // Para bows, mostrar información sobre coatings si están disponibles
    try {
      if (weapon.coatings != null && weapon.coatings!.isNotEmpty) {
        return Row(
          children: [
            Icon(
              Icons.arrow_upward,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Coatings:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: weapon.coatings!.map((coating) {
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCoatingColor(coating),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono del elemento/status si existe
                      if (_hasElementIcon(coating)) ...[
                        Image.asset(
                          'assets/imgs/elements/${_getElementAssetName(coating)}.webp',
                          width: 12,
                          height: 12,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              WeaponUtils.getElementIcon(coating),
                              size: 12,
                              color: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        coating[0].toUpperCase() + coating.substring(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildChargeBladeDamageInfo(Weapon weapon) {
    // Para charge blade, mostrar información sobre phial damage
    try {
      if (weapon.phial != null) {
        final phialKind = weapon.phial!.kind;
        return Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Phial:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                // Icono del elemento si es un phial elemental
                if (_hasElementIcon(phialKind)) ...[
                  Image.asset(
                    'assets/imgs/elements/${_getElementAssetName(phialKind)}.webp',
                    width: 16,
                    height: 16,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        WeaponUtils.getElementIcon(phialKind),
                        size: 16,
                        color: phialKind == 'impact'
                            ? Colors.blue[600]!
                            : Colors.orange[600]!,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                ] else ...[
                  Icon(
                    Icons.electric_bolt,
                    size: 16,
                    color: phialKind == 'impact'
                        ? Colors.blue[600]!
                        : Colors.orange[600]!,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  phialKind[0].toUpperCase() + phialKind.substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: phialKind == 'impact'
                        ? Colors.blue[600]!
                        : Colors.orange[600]!,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildGunlanceDamageInfo(Weapon weapon) {
    // Para gunlance, mostrar información sobre shell damage
    try {
      if (weapon.shell != null &&
          weapon.shell!.isNotEmpty &&
          weapon.shellLevel != null) {
        return Row(
          children: [
            Icon(
              Icons.local_fire_department,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Shell:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Colors.red[600]!,
                ),
                const SizedBox(width: 4),
                Text(
                  '${weapon.shell![0].toUpperCase() + weapon.shell!.substring(1)} Lv${weapon.shellLevel}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600]!,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildSwitchAxeDamageInfo(Weapon weapon) {
    // Para switch axe, mostrar información sobre phial damage
    try {
      if (weapon.phial != null) {
        final phialKind = weapon.phial!.kind;
        return Row(
          children: [
            Icon(
              Icons.transform,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Phial:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                // Icono del elemento si es un phial elemental
                if (_hasElementIcon(phialKind)) ...[
                  Image.asset(
                    'assets/imgs/elements/${_getElementAssetName(phialKind)}.webp',
                    width: 16,
                    height: 16,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        WeaponUtils.getElementIcon(phialKind),
                        size: 16,
                        color: Colors.orange[600]!,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                ] else ...[
                  Icon(
                    Icons.flash_on,
                    size: 16,
                    color: Colors.orange[600]!,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  phialKind[0].toUpperCase() + phialKind.substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[600]!,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    } catch (e) {
      // Si hay error al parsear, no mostrar nada
    }
    return const SizedBox.shrink();
  }

  Widget _buildWeaponSkills(Weapon weapon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flash_on,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Skills:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...weapon.skills.map((skill) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldSoft.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.goldSoft.withOpacity(0.3)),
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
                          itemName: skill.skill.name,
                          loadImageUrlFunction: getValidSkillImageUrl,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.goldSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${skill.skill.name} +${skill.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
                        color: Colors.grey[600],
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

  Widget _buildWeaponSlots(Weapon weapon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings,
              size: 16,
              color: AppColors.goldSoft,
            ),
            const SizedBox(width: 6),
            Text(
              'Slots:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSlotsWidget(weapon.slots),
      ],
    );
  }

  Widget _buildSlotsWidget(List<int> slots) {
    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          'No slots',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: slots.map((slot) {
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
          margin: const EdgeInsets.only(right: 6),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: slotColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: slotColor, width: 1),
          ),
          child: Center(
            child: Text(
              slot.toString(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: slotColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatWeaponKind(String kind) {
    return kind
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
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

  // Métodos auxiliares para coatings, phials y ammo
  Color _getCoatingColor(String coating) {
    switch (coating.toLowerCase()) {
      case 'power':
        return Colors.red[600]!;
      case 'paralysis':
        return Colors.amber[600]!;
      case 'poison':
        return Colors.green[600]!;
      case 'sleep':
        return Colors.indigo[600]!;
      case 'blast':
        return Colors.orange[600]!;
      case 'exhaust':
        return Colors.grey[600]!;
      case 'close-range':
        return Colors.blue[600]!;
      case 'pierce':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  bool _hasElementIcon(String coating) {
    final elementTypes = [
      'fire',
      'water',
      'ice',
      'thunder',
      'dragon',
      'poison',
      'paralysis',
      'sleep',
      'blast'
    ];
    return elementTypes
        .any((element) => coating.toLowerCase().contains(element));
  }

  String _getElementAssetName(String coating) {
    final coatingLower = coating.toLowerCase();
    if (coatingLower.contains('fire')) return 'fire';
    if (coatingLower.contains('water')) return 'water';
    if (coatingLower.contains('ice')) return 'ice';
    if (coatingLower.contains('thunder')) return 'thunder';
    if (coatingLower.contains('dragon')) return 'dragon';
    if (coatingLower.contains('poison')) return 'poison';
    if (coatingLower.contains('paralysis')) return 'paralysis';
    if (coatingLower.contains('sleep')) return 'sleep';
    if (coatingLower.contains('blast')) return 'blast';
    return 'fire'; // default
  }
}
