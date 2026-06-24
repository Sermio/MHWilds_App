import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';
import 'package:flutter/services.dart';
import 'package:mhwilds_app/models/item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Test ItemIconAssetResolver', () async {
    final assetPath = await ItemIconAssetResolver.resolve(apiKind: 'plant', apiColor: 'sage-green');
    print('Resolved asset for plant|sage-green: $assetPath');

    final potionPath = await ItemIconAssetResolver.resolve(apiKind: 'potion', apiColor: 'green');
    print('Resolved asset for potion|green: $potionPath');
  });
}
