import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Tarjeta contenedora común a todas las secciones del detalle de arma.
class WeaponSectionCard extends StatelessWidget {
  const WeaponSectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Tarjeta con título fijo (icono + texto) y contenido con padding de 20.
class WeaponTitledCard extends StatelessWidget {
  const WeaponTitledCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WeaponSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: WeaponSectionTitle(icon: icon, title: title),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

/// Icono + título de sección. [fill] hace que el texto ocupe el espacio libre
/// (para colocar acciones a la derecha); [trailing] es ese contenido.
class WeaponSectionTitle extends StatelessWidget {
  const WeaponSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.fill = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final bool fill;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        fill ? Expanded(child: text) : Flexible(child: text),
        if (trailing != null) trailing!,
      ],
    );
  }
}
