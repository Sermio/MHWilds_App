import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/monster_details/section_card.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tamaños de corona (base, mini, plata y oro).
class MonsterSizeSection extends StatelessWidget {
  final MonsterSize sizes;

  const MonsterSizeSection({super.key, required this.sizes});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MonsterSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonsterSectionTitle(l10n.crownSizes),
          const SizedBox(height: 16),
          _SizeRow(
            label: l10n.baseSize,
            size: '${(sizes.base / 100).toStringAsFixed(2)} m',
            icon: Icons.height,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          _SizeRow(
            label: l10n.miniCrown,
            size: '< ${(sizes.mini / 100).toStringAsFixed(2)} m',
            icon: Icons.keyboard_arrow_down,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _SizeRow(
            label: l10n.silverCrown,
            size: '≥ ${(sizes.silver / 100).toStringAsFixed(2)} m',
            icon: Icons.keyboard_arrow_up,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          _SizeRow(
            label: l10n.goldCrown,
            size: '≥ ${(sizes.gold / 100).toStringAsFixed(2)} m',
            icon: Icons.keyboard_arrow_up,
            color: AppColors.goldSoft,
          ),
        ],
      ),
    );
  }
}

class _SizeRow extends StatelessWidget {
  final String label;
  final String size;
  final IconData icon;
  final Color color;

  const _SizeRow({
    required this.label,
    required this.size,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            size,
            style: textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}
