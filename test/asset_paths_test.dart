import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/asset_paths.dart';

void main() {
  test('getTypeImage y getKindImage apuntan a assets que existen', () {
    for (final kind in ['weapon', 'armor', 'group', 'set', 'otro']) {
      expect(File(getTypeImage(kind)).existsSync(), isTrue, reason: kind);
      expect(File(getKindImage(kind)).existsSync(), isTrue, reason: kind);
    }
  });
}
