import 'package:flutter/material.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/models/monster.dart';
import 'package:mhwilds_app/screens/monster_details/section_card.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Estadísticas: vida base, rango de tamaño y elementos.
class MonsterStatsSection extends StatelessWidget {
  final Monster monster;

  const MonsterStatsSection({super.key, required this.monster});

  static String formatSizeRange(Monster monster) {
    if (monster.size != null) {
      final minSize = monster.size!.mini / 100; // centímetros a metros
      final maxSize = monster.size!.gold / 100; // corona de oro como máximo
      return '${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} m';
    } else {
      // Fallback: usar baseHealth como aproximación
      final baseSize = monster.baseHealth / 100;
      final minSize = baseSize * 0.9;
      final maxSize = baseSize * 1.1;
      return '${minSize.toStringAsFixed(2)} - ${maxSize.toStringAsFixed(2)} m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MonsterSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonsterSectionTitle(l10n.statistics),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                    label: l10n.baseHealth,
                    value: '${monster.baseHealth}',
                    icon: Icons.favorite),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                    label: l10n.sizeRange,
                    value: formatSizeRange(monster),
                    icon: Icons.height),
              ),
            ],
          ),
          if (monster.elements.isNotEmpty) ...[
            const SizedBox(height: 16),
            MonsterInfoRow(l10n.elements, monster.elements.join(', ')),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.goldSoft.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldSoft.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.goldAccent(context), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
