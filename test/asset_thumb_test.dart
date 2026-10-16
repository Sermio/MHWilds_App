import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';

Image _img(WidgetTester t) => t.widget<Image>(find.byType(Image));

void main() {
  testWidgets('cacheWidth = width × dpr', (t) async {
    t.view.devicePixelRatio = 3;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: AssetThumb('x.png', width: 40)));
    expect((_img(t).image as ResizeImage).width, 120);
  });

  testWidgets('falls back to max width, then height only', (t) async {
    t.view.devicePixelRatio = 2;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(
        home: Center(child: SizedBox(width: 100, child: AssetThumb('x.png')))));
    expect((_img(t).image as ResizeImage).width, 200);
    await t.pumpWidget(const MaterialApp(
        home: Center(child: AssetThumb('x.png', height: 16))));
    expect((_img(t).image as ResizeImage).height, 32);
  });
}
