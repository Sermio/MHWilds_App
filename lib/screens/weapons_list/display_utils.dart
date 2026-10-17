import 'package:flutter/material.dart';
import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/utils/game_colors.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

// Clase estática para métodos auxiliares reutilizables
class WeaponDisplayUtils {
  static Widget buildElementalDamageRow(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    // Buscar specials con daño elemental o de status, y también daño de phial
    if (weapon.specials is List) {
      final specials =
          (weapon.specials as List).whereType<Map<String, dynamic>>();
      final elementalAndStatusSpecials = specials.where((special) {
        return (special['kind'] == 'element' || special['kind'] == 'status') &&
            (((special['damage'] as Map<String, dynamic>?)?['raw'] as num?) ??
                    0) >
                0;
      }).toList();

      // También buscar phial damage si existe
      final phialSpecial = specials.where((special) {
        final damage = (special['phial'] as Map<String, dynamic>?)?['damage']
            as Map<String, dynamic>?;
        return ((damage?['raw'] as num?) ?? 0) > 0;
      }).toList();

      // Priorizar specials elementales/status, luego phial
      if (elementalAndStatusSpecials.isNotEmpty) {
        final special = elementalAndStatusSpecials.first;
        final elementOrStatus = special['kind'] == 'element'
            ? (special['element'] as String? ?? '')
            : (special['status'] as String? ?? '');
        final damage = special['damage'] as Map<String, dynamic>?;
        final damageValue =
            damage?['display'] as num? ?? damage?['raw'] as num? ?? 0;

        if (damageValue > 0) {
          final colorScheme = Theme.of(context).colorScheme;
          return LabelValueRow(label: Text(
                special['kind'] == 'element'
                    ? '${AppLocalizations.of(context)!.element}:'
                    : '${AppLocalizations.of(context)!.statusEffect}:',
                style: TextStyle(
                  fontSize: isDetailView ? 16 : 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ), value: Row(mainAxisSize: MainAxisSize.min, 
                children: [
                  Text(
                    '$damageValue',
                    style: TextStyle(
                      fontSize: isDetailView ? 16 : 12,
                      fontWeight: FontWeight.bold,
                      color: GameColors.of(context).element(elementOrStatus),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: isDetailView ? 18 : 16,
                    height: isDetailView ? 18 : 16,
                    child: AssetThumb(
                      'assets/imgs/elements/${elementOrStatus.toLowerCase()}.webp',
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          WeaponUtils.getElementIcon(elementOrStatus),
                          size: isDetailView ? 18 : 16,
                          color: GameColors.of(context).element(elementOrStatus),
                        );
                      }, semanticLabel: WeaponUtils.elementLabel(elementOrStatus)),
                  ),
                ],
              ));
        }
      } else if (phialSpecial.isNotEmpty) {
        // Mostrar daño de phial si no hay specials elementales/status
        final special = phialSpecial.first;
        final phial = special['phial'] as Map<String, dynamic>;
        final phialKind = phial['kind'] as String? ?? '';
        final phialDamage = phial['damage'] as Map<String, dynamic>?;
        final phialDamageValue =
            phialDamage?['display'] as num? ?? phialDamage?['raw'] as num? ?? 0;

        if (phialDamageValue > 0) {
          final colorScheme = Theme.of(context).colorScheme;
          return LabelValueRow(label: Text(
                '${AppLocalizations.of(context)!.phial}:',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurface.withValues(alpha: 0.8)),
              ), value: Row(mainAxisSize: MainAxisSize.min, 
                children: [
                  Text(
                    '$phialDamageValue',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: GameColors.of(context).element(phialKind)),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: AssetThumb(
                      'assets/imgs/elements/${phialKind.toLowerCase()}.webp',
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          WeaponUtils.getElementIcon(phialKind),
                          size: 18,
                          color: GameColors.of(context).element(phialKind),
                        );
                      }, semanticLabel: WeaponUtils.elementLabel(phialKind)),
                  ),
                ],
              ));
        }
      }
    }

    return const SizedBox.shrink();
  }

  static Widget buildAdditionalDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    // Solo manejar información específica del tipo de arma (no daño elemental)
    switch (weapon.kind) {
      case 'bow':
        return buildBowDamageInfo(context, weapon, isDetailView: isDetailView);
      case 'charge-blade':
        return buildChargeBladeDamageInfo(context, weapon,
            isDetailView: isDetailView);
      case 'gunlance':
        return buildGunlanceDamageInfo(context, weapon,
            isDetailView: isDetailView);
      case 'switch-axe':
        return buildSwitchAxeDamageInfo(context, weapon,
            isDetailView: isDetailView);
      case 'hunting-horn':
        return buildHuntingHornDamageInfo(context, weapon,
            isDetailView: isDetailView);
      case 'heavy-bowgun':
      case 'light-bowgun':
        return buildBowgunDamageInfo(context, weapon,
            isDetailView: isDetailView);
      case 'insect-glaive':
        return buildInsectGlaiveDamageInfo(context, weapon,
            isDetailView: isDetailView);
      default:
        return const SizedBox.shrink();
    }
  }

  static Widget buildBowDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    // Para bows, mostrar información sobre coatings si están disponibles
    try {
      if (weapon.coatings != null && weapon.coatings!.isNotEmpty) {
        final colorScheme = Theme.of(context).colorScheme;
        return LabelValueRow(label: Text(
              '${AppLocalizations.of(context)!.coatings}:',
              style: TextStyle(
                fontSize: isDetailView ? 16 : 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ), value: Wrap(
              runSpacing: AppSpacing.xs,
              children: weapon.coatings!.map((coating) {
                return Container(
                  margin: const EdgeInsets.only(left: AppSpacing.xs),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: GameColors.of(context).coating(coating),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        coating[0].toUpperCase() + coating.substring(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Icono del elemento/status si existe después del texto
                      if (_hasElementIcon(coating)) ...[
                        const SizedBox(width: 4),
                        AssetThumb(
                          'assets/imgs/elements/${_getElementAssetName(coating)}.webp',
                          width: 12,
                          height: 12,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              WeaponUtils.getElementIcon(coating),
                              size: 12,
                              color: Colors.white,
                            );
                          }, semanticLabel: WeaponUtils.elementLabel(_getElementAssetName(coating))),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ));
      }
    } catch (_) {}
    return const SizedBox.shrink();
  }

  static Widget buildChargeBladeDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(label: Text(
          '${AppLocalizations.of(context)!.phial}:',
          style: TextStyle(
            fontSize: isDetailView ? 16 : 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ), value: Row(mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              phialKind[0].toUpperCase() + phialKind.substring(1),
              style: TextStyle(
                fontSize: isDetailView ? 16 : 12,
                fontWeight: FontWeight.bold,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ),
            const SizedBox(width: 4),
            if (_hasElementIcon(phialKind)) ...[
              AssetThumb(
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
                }, semanticLabel: WeaponUtils.elementLabel(_getElementAssetName(phialKind))),
            ] else ...[
              Icon(
                Icons.electric_bolt,
                size: 16,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ],
          ],
        ));
  }

  static Widget buildGunlanceDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    if (weapon.shell == null || weapon.shellLevel == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(label: Text(
          '${AppLocalizations.of(context)!.shell}:',
          style: TextStyle(
            fontSize: isDetailView ? 16 : 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ), value: Row(mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              '${weapon.shell![0].toUpperCase() + weapon.shell!.substring(1)} Lv${weapon.shellLevel}',
              style: TextStyle(
                fontSize: isDetailView ? 16 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.red[600]!,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.local_fire_department,
                size: 16, color: Colors.red[600]!),
          ],
        ));
  }

  static Widget buildSwitchAxeDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    if (weapon.phial == null) return const SizedBox.shrink();

    final phialKind = weapon.phial!.kind;
    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(label: Text(
          '${AppLocalizations.of(context)!.phial}:',
          style: TextStyle(
            fontSize: isDetailView ? 16 : 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ), value: Row(mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              phialKind[0].toUpperCase() + phialKind.substring(1),
              style: TextStyle(
                fontSize: isDetailView ? 16 : 12,
                fontWeight: FontWeight.bold,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ),
            const SizedBox(width: 4),
            if (_hasElementIcon(phialKind)) ...[
              AssetThumb(
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
                }, semanticLabel: WeaponUtils.elementLabel(_getElementAssetName(phialKind))),
            ] else ...[
              Icon(
                Icons.electric_bolt,
                size: 16,
                color: phialKind == 'impact'
                    ? Colors.blue[600]!
                    : Colors.orange[600]!,
              ),
            ],
          ],
        ));
  }

  static Widget buildHuntingHornDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    final List<Widget> sections = [];

    final colorScheme = Theme.of(context).colorScheme;
    if (weapon.melody != null) {
      sections.add(LabelValueRow(label: Text(
            '${AppLocalizations.of(context)!.melody}:',
            style: TextStyle(
              fontSize: isDetailView ? 16 : 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ), value: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${weapon.melody!.songs.length} ${AppLocalizations.of(context)!.songs}',
                style: TextStyle(
                  fontSize: isDetailView ? 16 : 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[600],
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.music_note, size: 16, color: Colors.teal[600]),
            ],
          )));
    }

    if (weapon.echoBubble != null) {
      sections.add(Row(children: [Flexible(child: Text(
            '${AppLocalizations.of(context)!.echoBubble}:',
            style: TextStyle(
              fontSize: isDetailView ? 16 : 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          )), const SizedBox(width: 8), Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    weapon.echoBubble!.name,
                    style: TextStyle(
                      fontSize: isDetailView ? 16 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.bubble_chart, size: 16, color: Colors.indigo[600]),
              ],
            ),
          )]));
    }

    if (weapon.echoWave != null) {
      sections.add(Row(children: [Flexible(child: Text(
            '${AppLocalizations.of(context)!.echoWave}:',
            style: TextStyle(
              fontSize: isDetailView ? 16 : 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          )), const SizedBox(width: 8), Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    weapon.echoWave!.name,
                    style: TextStyle(
                      fontSize: isDetailView ? 16 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.waves, size: 16, color: Colors.orange[600]),
              ],
            ),
          )]));
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(children: sections);
  }

  static Widget buildBowgunDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    if (weapon.ammo == null || weapon.ammo!.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(label: Text(
          '${AppLocalizations.of(context)!.ammo}:',
          style: TextStyle(
            fontSize: isDetailView ? 16 : 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ), value: Wrap(
          runSpacing: AppSpacing.xs,
          children: weapon.ammo!.take(3).map((ammo) {
            return Container(
              margin: const EdgeInsets.only(left: AppSpacing.xs),
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
                  if (_hasElementIcon(ammo.kind)) ...[
                    const SizedBox(width: 4),
                    AssetThumb(
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
                      }, semanticLabel: WeaponUtils.elementLabel(_getElementAssetName(ammo.kind))),
                  ],
                ],
              ),
            );
          }).toList(),
        ));
  }

  static Widget buildInsectGlaiveDamageInfo(BuildContext context, Weapon weapon,
      {bool isDetailView = false}) {
    if (weapon.kinsectLevel == null || weapon.kinsectLevel! <= 0) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return LabelValueRow(label: Text(
          '${AppLocalizations.of(context)!.kinsect}:',
          style: TextStyle(
            fontSize: isDetailView ? 16 : 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ), value: Row(mainAxisSize: MainAxisSize.min, 
          children: [
            Text(
              'Lv${weapon.kinsectLevel}',
              style: TextStyle(
                fontSize: isDetailView ? 16 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.flutter_dash, size: 16, color: Colors.lime[600]),
          ],
        ));
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
}
