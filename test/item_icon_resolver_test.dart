import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/item_icon_asset_resolver.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ItemIconAssetResolver resolves kind + color to an asset', () async {
    final plant = await ItemIconAssetResolver.resolve(
        apiKind: 'plant', apiColor: 'sage-green');
    final potion = await ItemIconAssetResolver.resolve(
        apiKind: 'potion', apiColor: 'green');
    expect(plant,
        startsWith('assets/imgs/item_icons/MHWilds-Herb_Icon_Light_Green'));
    expect(potion,
        startsWith('assets/imgs/item_icons/MHWilds-Medicine_Icon_Green'));
  });
}
