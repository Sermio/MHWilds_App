part of '../weapons_list.dart';

extension WeaponsListDamageInfo on _WeaponsListState {
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
    } catch (_) {}
    return const SizedBox.shrink();
  }

  Widget _buildMelodyWidget(HuntingHornMelody melody) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.music_note, size: 16, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.melody}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.bubble_chart, size: 16, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.echoBubble}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.waves, size: 16, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.echoWave}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
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
    final colorScheme = Theme.of(context).colorScheme;
    try {
      if (weapon.ammo != null && weapon.ammo!.isNotEmpty) {
        return Row(
          children: [
            Icon(Icons.gps_fixed, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.ammo}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
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
    } catch (_) {}
    return const SizedBox.shrink();
  }

  Widget _buildInsectGlaiveDamageInfo(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    try {
      if (weapon.kinsectLevel != null && weapon.kinsectLevel! > 0) {
        return Row(
          children: [
            Icon(Icons.flutter_dash, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.kinsect}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
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
    } catch (_) {}
    return const SizedBox.shrink();
  }

  Widget _buildBowDamageInfo(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    // Para bows, mostrar información sobre coatings si están disponibles
    try {
      if (weapon.coatings != null && weapon.coatings!.isNotEmpty) {
        return Row(
          children: [
            Icon(
              Icons.arrow_upward,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              '${AppLocalizations.of(context)!.coatings}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withOpacity(0.8),
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

  Widget _buildChargeBladeDamageInfo(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    return Row(
      children: [
        Icon(
          Icons.flash_on,
          size: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.phial}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Text(
          phialKind[0].toUpperCase() + phialKind.substring(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.orange[600],
          ),
        ),
      ],
    );
  }

  Widget _buildGunlanceDamageInfo(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    if (weapon.shell == null || weapon.shellLevel == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(Icons.local_fire_department, size: 16, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.shell}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Text(
          '${weapon.shell![0].toUpperCase() + weapon.shell!.substring(1)} Lv${weapon.shellLevel}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.red[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchAxeDamageInfo(Weapon weapon) {
    final colorScheme = Theme.of(context).colorScheme;
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    return Row(
      children: [
        Icon(Icons.transform, size: 16, color: colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          '${AppLocalizations.of(context)!.phial}:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Text(
          phialKind[0].toUpperCase() + phialKind.substring(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.orange[600],
          ),
        ),
      ],
    );
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
