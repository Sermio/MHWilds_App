part of '../weapons_list.dart';

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
              SizedBox(
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
                  SizedBox(
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
              SizedBox(
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
                  SizedBox(
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
            Icon(Icons.arrow_upward, size: 16, color: Colors.amber[400]),
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
    } catch (_) {}
    return const SizedBox.shrink();
  }

  static Widget buildChargeBladeDamageInfo(Weapon weapon) {
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    return Row(
      children: [
        Icon(Icons.flash_on, size: 16, color: Colors.blue[400]),
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
        Icon(Icons.local_fire_department, size: 16, color: Colors.red[400]),
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
            Icon(Icons.local_fire_department,
                size: 16, color: Colors.red[600]!),
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
        Icon(Icons.transform, size: 16, color: Colors.orange[400]),
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

    return Column(children: sections);
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
        Icon(Icons.flutter_dash, size: 16, color: Colors.lime[400]),
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
