import 'package:flutter/material.dart';

class AppColors {
  // Color dorado suave
  static const Color goldSoft = Color(0xFFC3A35D);

  // Dorado oscuro para texto, iconos y bordes sobre fondo claro
  // (6,02:1 sobre blanco; goldSoft solo llega a 2,41:1).
  static const Color goldInk = Color(0xFF7A5F22);

  /// Dorado legible sobre el fondo del tema actual: [goldInk] en claro y
  /// [goldSoft] en oscuro. Para rellenos (AppBar, botones) usa [goldSoft].
  static Color goldAccent(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? goldSoft : goldInk;

  // Color marrón oliva
  static const Color oliveBrown = Color(0xFF605632);

  // Color negro profundo
  static const Color deepBlack = Color(0xFF040404);

  // Color verde oliva apagado
  static const Color mutedOlive = Color(0xFF758A61);
}
