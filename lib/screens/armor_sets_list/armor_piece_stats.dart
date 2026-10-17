import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/decoration_sprite_icon.dart';
import 'package:mhwilds_app/components/label_value_row.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/armor_piece.dart' as armor_models;
import 'package:mhwilds_app/models/skills.dart' as skills_model;
import 'package:mhwilds_app/screens/armor_sets_list/armor_piece_skill_card.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/weapon_utils.dart';

/// Defensa, slots, resistencias y skills de una pieza de armadura.
class ArmorPieceStats extends StatelessWidget {
  final armor_models.ArmorPiece piece;
  final skills_model.SkillIcon? Function(int) onSkillIconRequest;

  const ArmorPieceStats({
    super.key,
    required this.piece,
    required this.onSkillIconRequest,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface.withValues(alpha: 0.8));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelValueRow(
          label: Text('${l10n.defense}:', style: labelStyle),
          value: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${piece.defense['base']}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              ),
              const SizedBox(width: 4),
              const SizedBox(
                height: 16,
                child: AssetThumb('assets/imgs/armor/armor.webp'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LabelValueRow(
          label: Text('${l10n.slots}:', style: labelStyle),
          value: _SlotsView(slots: piece.slots),
        ),
        const SizedBox(height: 12),
        Text('${l10n.resistances}:', style: labelStyle),
        const SizedBox(height: 8),
        _ResistancesView(resistances: piece.resistances),
        const SizedBox(height: 12),
        Text('${l10n.skills}:', style: labelStyle),
        const SizedBox(height: 8),
        ...piece.displaySkills.map((skill) {
          final icon = onSkillIconRequest(skill.skill.id);
          return ArmorPieceSkillCard(skill: skill, icon: icon);
        }),
      ],
    );
  }
}

/// Caja con texto en cursiva para "sin slots" / "sin resistencias".
class _EmptyStatBox extends StatelessWidget {
  final String text;

  const _EmptyStatBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: colorScheme.onSurface.withValues(alpha: 0.8),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _SlotsView extends StatelessWidget {
  final List<int> slots;

  const _SlotsView({required this.slots});

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return _EmptyStatBox(text: AppLocalizations.of(context)!.noSlots);
    }

    return Wrap(
      children: slots.map((slot) {
        final Color slotColor = _slotColor(slot);
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: DecorationSpriteIcon(
            slot: slot,
            size: 18,
            fallback: Container(
              decoration: BoxDecoration(
                color: slotColor.withValues(alpha: 0.2),
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
            ),
          ),
        );
      }).toList(),
    );
  }

  static Color _slotColor(int slot) {
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
}

class _ResistancesView extends StatelessWidget {
  final Map<String, int> resistances;

  const _ResistancesView({required this.resistances});

  @override
  Widget build(BuildContext context) {
    if (resistances.isEmpty) {
      return _EmptyStatBox(text: AppLocalizations.of(context)!.noResistances);
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      children: resistances.entries.map((entry) {
        final resistanceType = entry.key;
        return Container(
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry.value.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 16,
                child: AssetThumb(
                    'assets/imgs/elements/${resistanceType.toLowerCase()}.webp',
                    semanticLabel: WeaponUtils.elementLabel(resistanceType)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
