import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tarjeta contenedora común a las secciones de detalle del monstruo.
class MonsterSectionCard extends StatelessWidget {
  final Color? shadowColor;
  final Widget child;

  const MonsterSectionCard({super.key, this.shadowColor, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? AppColors.goldSoft).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Título en "pill" de una sección.
class MonsterSectionTitle extends StatelessWidget {
  final String text;
  final Color? tint;

  const MonsterSectionTitle(this.text, {super.key, this.tint});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: (tint ?? AppColors.goldSoft).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
      ),
    );
  }
}

/// Fila etiqueta (negrita) + valor.
class MonsterInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDescription;

  const MonsterInfoRow(this.label, this.value,
      {super.key, this.isDescription = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isDescription ? 13 : 14,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
