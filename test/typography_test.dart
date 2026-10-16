import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/spacing.dart';
import 'package:mhwilds_app/utils/theme.dart';

void main() {
  for (final entry in {
    'claro': AppTheme.lightTheme,
    'oscuro': AppTheme.darkTheme,
  }.entries) {
    test('textTheme ${entry.key} define los 15 estilos con >= 12 px', () {
      final t = entry.value.textTheme;
      final styles = [
        t.displayLarge,
        t.displayMedium,
        t.displaySmall,
        t.headlineLarge,
        t.headlineMedium,
        t.headlineSmall,
        t.titleLarge,
        t.titleMedium,
        t.titleSmall,
        t.bodyLarge,
        t.bodyMedium,
        t.bodySmall,
        t.labelLarge,
        t.labelMedium,
        t.labelSmall,
      ];
      for (final s in styles) {
        expect(s, isNotNull);
        expect(s!.fontSize, greaterThanOrEqualTo(12));
        expect(s.color, entry.value.colorScheme.onSurface);
      }
    });
  }

  test('tokens de espaciado y radio', () {
    expect([
      AppSpacing.xs,
      AppSpacing.sm,
      AppSpacing.md,
      AppSpacing.lg,
      AppSpacing.xl,
    ], [
      4,
      8,
      12,
      16,
      24
    ]);
    expect([AppRadius.sm, AppRadius.md, AppRadius.lg], [10, 15, 20]);
  });
}
