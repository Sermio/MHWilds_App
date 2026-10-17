import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:mhwilds_app/utils/theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  test('goldInk cumple 4,5:1 sobre blanco y goldSoft sobre oscuro', () {
    expect(_contrast(AppColors.goldInk, Colors.white), greaterThan(4.5));
    expect(_contrast(AppColors.goldSoft, const Color(0xFF121212)),
        greaterThan(4.5));
  });

  for (final entry in {
    'claro': AppTheme.lightScheme,
    'oscuro': AppTheme.darkScheme,
  }.entries) {
    final s = entry.value;
    group('esquema ${entry.key}', () {
      test('conserva dorado y no usa el turquesa por defecto', () {
        expect(s.primary, AppColors.goldSoft);
        expect(s.secondary, isNot(const Color(0xFF03DAC6)));
        expect(s.tertiary, isNot(const Color(0xFF03DAC6)));
      });

      test('pares on/fondo con contraste >= 4,5:1', () {
        expect(_contrast(s.onPrimary, s.primary), greaterThan(4.5));
        expect(_contrast(s.onSecondary, s.secondary), greaterThan(4.5));
        expect(_contrast(s.onTertiary, s.tertiary), greaterThan(4.5));
        expect(_contrast(s.onSurface, s.surface), greaterThan(4.5));
        expect(_contrast(s.onSurfaceVariant, s.surface), greaterThan(4.5));
        expect(_contrast(s.onSurfaceVariant, s.surfaceContainerHighest),
            greaterThan(4.5));
      });
    });
  }

  test('AppBar dorada en claro; en oscuro superficie con título dorado', () {
    expect(AppTheme.lightTheme.appBarTheme.backgroundColor, AppColors.goldSoft);
    final dark = AppTheme.darkTheme.appBarTheme;
    expect(dark.backgroundColor, AppTheme.darkScheme.surfaceContainer);
    expect(dark.foregroundColor, AppColors.goldSoft);
    expect(dark.titleTextStyle!.color, AppColors.goldSoft);
    expect(
        _contrast(AppColors.goldSoft, dark.backgroundColor!), greaterThan(4.5));
    final border = AppTheme
        .lightTheme.inputDecorationTheme.enabledBorder!.borderSide.color;
    expect(border, AppColors.goldInk);
  });
}
