import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/label_value_row.dart';

Widget _host(double width, {double scale = 1}) => MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: Material(
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: const LabelValueRow(
              label: Text('Defense:'),
              value: Text('12345'),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('cabe en una línea: etiqueta a la izquierda, valor a la derecha',
      (tester) async {
    await tester.pumpWidget(_host(300));
    final label = tester.getTopLeft(find.text('Defense:'));
    final value = tester.getTopRight(find.text('12345'));
    expect(label.dy, value.dy);
    expect(value.dx, closeTo(300, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('si no cabe, el valor pasa a la línea siguiente sin overflow',
      (tester) async {
    await tester.pumpWidget(_host(200, scale: 1.5));
    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.text('12345')).dy,
        greaterThan(tester.getTopLeft(find.text('Defense:')).dy));
  });
}
