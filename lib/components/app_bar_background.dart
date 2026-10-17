import 'package:flutter/material.dart';
import 'package:mhwilds_app/utils/colors.dart';

/// Fondo con degradado de la AppBar (`flexibleSpace`): dorado en claro y
/// marrón oscuro en oscuro, con un brillo suave en la esquina superior derecha
/// para que una barra baja no se vea plana.
class AppBarBackground extends StatelessWidget {
  const AppBarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = isDark ? AppColors.goldSoft : Colors.white;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.barGradient(context)),
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.1,
                colors: [
                  glow.withValues(alpha: isDark ? 0.16 : 0.28),
                  glow.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
