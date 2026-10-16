import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/utils/utils.dart';

void main() {
  test('removeDiacritics quita tildes', () {
    expect(removeDiacritics('Árbol Éxito ÍÓÚ àèìòù üç'),
        'arbol exito iou aeiou uc');
  });

  test('removeDiacritics pliega la ñ a n', () {
    expect(removeDiacritics('Niño ÑANDÚ'), 'nino nandu');
  });

  test('removeDiacritics pasa a minúsculas, recorta y respeta el resto', () {
    expect(removeDiacritics('  Rathalos-X 2 '), 'rathalos-x 2');
    expect(removeDiacritics(''), '');
  });
}
