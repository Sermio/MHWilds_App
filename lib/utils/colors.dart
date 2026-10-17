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

  // Degradado dorado de cabeceras (AppBar clara y menú lateral).
  static const Color goldLight = Color(0xFFD9C084);
  static const Color goldDeep = Color(0xFFA8863E);
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, goldSoft, goldDeep],
  );

  // Degradado de la AppBar oscura: marrón casi negro con un rastro dorado.
  static const LinearGradient darkBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D1812), Color(0xFF33291A)],
  );

  static LinearGradient barGradient(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBarGradient
          : goldGradient;

  // Superficies cálidas (tema claro): fondo de página y tarjetas.
  static const Color parchment = Color(0xFFF6F0E1);
  static const Color parchmentCard = Color(0xFFFFFCF5);

  // Color marrón oliva
  static const Color oliveBrown = Color(0xFF605632);

  // Color negro profundo
  static const Color deepBlack = Color(0xFF040404);

  // Color verde oliva apagado
  static const Color mutedOlive = Color(0xFF758A61);
}
