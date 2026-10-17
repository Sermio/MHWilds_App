import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/list_filters_panel.dart';
import 'package:mhwilds_app/utils/game_colors.dart';

void main() {
  testWidgets('el botón de reset flota: no suma altura al panel',
      (tester) async {
    var resets = 0;
    Widget panel() => MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: ListFiltersPanel(
                title: 'Filters',
                resetLabel: 'Reset',
                onReset: () => resets++,
                fields: [
                  ListFilterFieldConfig.custom(
                    id: 'a',
                    label: 'Name',
                    customBuilder: (_) =>
                        const SizedBox(key: Key('field'), height: 56),
                  ),
                ],
              ),
            ),
          ),
        );
    await tester.pumpWidget(panel());

    // Etiqueta (~24) + hueco (8) + campo (56) + márgenes: sin franja de 48 dp
    // reservada para el botón.
    expect(tester.getSize(find.byType(ListFiltersPanel)).height, lessThan(140));
    final field = tester.getRect(find.byKey(const Key('field')));
    final button = tester.getRect(find.text('Reset'));
    expect(button.bottom, lessThan(field.top), reason: 'no tapa el campo');

    await tester.tap(find.text('Reset'));
    expect(resets, 1);
  });

  test('colores de viales: elementos y estados tienen color, power no', () {
    final c = GameColors.light;
    for (final id in ['fire', 'dragon', 'poison', 'paralyze', 'blastblight']) {
      expect(c.elementOrNull(id), isNotNull, reason: id);
    }
    expect(c.elementOrNull('impact'), isNull);
    expect(c.elementOrNull('power'), isNull);
    expect(c.elementOrNull('paralyze'), c.element('paralysis'));
  });
}
