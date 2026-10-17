import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/screens/map_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overflow_helper.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('el diálogo del mapa no se desplaza a escala 1 pero admite zoom',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    final mapId = data.locations.zones.first.id!;
    await pumpAtStress(tester, MonsterMapDetails(mapId: mapId),
        data: data, textScale: 1, locale: const Locale('en'));
    await tester.pump(const Duration(seconds: 1));

    // La imagen aún no está decodificada en el test (tamaño 0): se invoca el
    // onTap del GestureDetector que la envuelve en vez de tocar por posición.
    final opener = find
        .ancestor(
            of: find.byType(Image).first,
            matching: find.byType(GestureDetector))
        .evaluate()
        .map((e) => e.widget as GestureDetector)
        .firstWhere((g) => g.onTap != null);
    opener.onTap!();
    await tester.pump(const Duration(milliseconds: 400));

    final viewer =
        tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
    expect(viewer.minScale, 1.0);
    expect(viewer.maxScale, greaterThan(1.0));

    expect(viewer.boundaryMargin, EdgeInsets.zero);
    await tester.drag(find.byType(InteractiveViewer), const Offset(120, 90));
    await tester.pump(const Duration(milliseconds: 400));
    final moved = find
        .descendant(
            of: find.byType(InteractiveViewer),
            matching: find.byType(Transform))
        .evaluate()
        .map((e) => (e.widget as Transform).transform)
        .any((m) => !m.isIdentity());
    expect(moved, isFalse);
  });
}
