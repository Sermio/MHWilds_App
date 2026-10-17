const _diacriticsMap = {
  'ÀÁÂÃÄÅ': 'A',
  'àáâãäå': 'a',
  'ÒÓÔÕÖØ': 'O',
  'òóôõöø': 'o',
  'ÈÉÊË': 'E',
  'èéêë': 'e',
  'Çç': 'C',
  'ÌÍÎÏ': 'I',
  'ìíîï': 'i',
  'ÙÚÛÜ': 'U',
  'ùúûü': 'u',
  'ÿ': 'y',
  'Ññ': 'N',
};

final Map<int, String> _diacriticsByCodeUnit = {
  for (final e in _diacriticsMap.entries)
    for (final c in e.key.split('')) c.codeUnitAt(0): e.value,
};

/// Minúsculas, sin tildes y sin espacios en los extremos, en un solo recorrido.
/// La ñ se pliega a n (como antes) para que "nino" encuentre "niño".
String removeDiacritics(String text) {
  final out = StringBuffer();
  for (final unit in text.codeUnits) {
    out.write(_diacriticsByCodeUnit[unit] ?? String.fromCharCode(unit));
  }
  return out.toString().toLowerCase().trim();
}

/// Quita el prefijo de zona del nombre de un campamento de la API
/// ("Zona 2: Bifurcación" / "Zone 2 - Fossé" -> "Bifurcación"), porque la
/// zona ya se muestra en su propio chip. Sin prefijo, devuelve el nombre.
String campNameWithoutZone(String? name) =>
    (name ?? '').replaceFirst(RegExp(r'^\S+\s+\d+\s*[:\-–]\s*'), '');
