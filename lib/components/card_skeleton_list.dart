import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/spacing.dart';

/// Marcador de posición de una lista que está cargando: tarjetas redondeadas
/// con la misma forma que las reales (icono + dos líneas de texto) y un pulso
/// suave, que se desactiva si el sistema pide reducir animaciones.
class CardSkeletonList extends StatefulWidget {
  const CardSkeletonList({
    super.key,
    required this.semanticLabel,
    this.count = 6,
    this.itemHeight = 96,
  });

  final String semanticLabel;
  final int count;
  final double itemHeight;

  @override
  State<CardSkeletonList> createState() => _CardSkeletonListState();
}

class _CardSkeletonListState extends State<CardSkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          itemCount: widget.count,
          itemBuilder: (_, __) => FadeTransition(
            opacity: Tween(begin: 0.45, end: 1.0).animate(_pulse),
            child: _SkeletonCard(height: widget.itemHeight, scheme: scheme),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height, required this.scheme});

  final double height;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final fill = scheme.onSurface.withValues(alpha: 0.08);
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: height - 2 * AppSpacing.md,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(fill, widthFactor: 0.7, height: 14),
                const SizedBox(height: AppSpacing.sm),
                _bar(fill, widthFactor: 0.45, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(Color color,
      {required double widthFactor, required double height}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
      ),
    );
  }
}
