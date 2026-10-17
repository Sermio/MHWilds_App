import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/filter_panel_layout.dart';

Widget _app(Widget? panel) => MaterialApp(
      home: Scaffold(
        body: FilterPanelLayout(
          panel: panel,
          child: ListView(
            children: const [
              ListTile(key: Key('first'), title: Text('first')),
              ListTile(title: Text('second')),
            ],
          ),
        ),
      ),
    );

void main() {
  testWidgets('the list starts below the open panel instead of under it',
      (tester) async {
    await tester
        .pumpWidget(_app(const SizedBox(key: Key('panel'), height: 200)));
    await tester.pumpAndSettle();

    final panelBottom = tester.getBottomLeft(find.byKey(const Key('panel'))).dy;
    final firstTop = tester.getTopLeft(find.byKey(const Key('first'))).dy;
    expect(firstTop, greaterThanOrEqualTo(panelBottom));
  });

  testWidgets('without panel the list uses all the space', (tester) async {
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byKey(const Key('first'))).dy, 0);
  });

  testWidgets('a panel taller than the screen shrinks without overflow',
      (tester) async {
    await tester.pumpWidget(_app(SingleChildScrollView(
      child: Column(
        children: List.generate(
            40, (_) => const SizedBox(height: 40, width: double.infinity)),
      ),
    )));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('first'), findsOneWidget);
  });
}
