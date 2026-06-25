import 'dart:convert';
import 'dart:io';

void main() async {
  final l10nDir = Directory('lib/l10n');
  final arbFiles = l10nDir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (final file in arbFiles) {
    final content = await file.readAsString();
    final Map<String, dynamic> jsonMap = jsonDecode(content);

    final isSpanish = file.path.contains('es');
    final isGerman = file.path.contains('de');
    final isFrench = file.path.contains('fr');
    final isItalian = file.path.contains('it');
    final isPolish = file.path.contains('pl');
    final isPortuguese = file.path.contains('pt');

    // add camps
    if (isSpanish) jsonMap['camps'] = 'Campamentos';
    else if (isGerman) jsonMap['camps'] = 'Lager';
    else if (isFrench) jsonMap['camps'] = 'Camps';
    else if (isItalian) jsonMap['camps'] = 'Accampamenti';
    else if (isPolish) jsonMap['camps'] = 'Obozy';
    else if (isPortuguese) jsonMap['camps'] = 'Acampamentos';
    else jsonMap['camps'] = 'Camps';

    // add openOptimizer
    if (isSpanish) jsonMap['openOptimizer'] = 'Abrir optimizador';
    else if (isGerman) jsonMap['openOptimizer'] = 'Optimierer öffnen';
    else if (isFrench) jsonMap['openOptimizer'] = "Ouvrir l'optimiseur";
    else if (isItalian) jsonMap['openOptimizer'] = 'Apri ottimizzatore';
    else if (isPolish) jsonMap['openOptimizer'] = 'Otwórz optymalizator';
    else if (isPortuguese) jsonMap['openOptimizer'] = 'Abrir otimizador';
    else jsonMap['openOptimizer'] = 'Open optimizer';

    // add ok
    jsonMap['ok'] = 'OK';

    if (isSpanish) {
      jsonMap['webViewNotSupported'] = 'WebView no disponible en esta plataforma.';
      jsonMap['openInBrowserHint'] = 'Puedes abrir el optimizador en tu navegador.';
    } else if (isGerman) {
      jsonMap['webViewNotSupported'] = 'WebView ist auf dieser Plattform nicht verfügbar.';
      jsonMap['openInBrowserHint'] = 'Sie können den Optimierer in Ihrem Browser öffnen.';
    } else if (isFrench) {
      jsonMap['webViewNotSupported'] = "WebView n'est pas disponible sur cette plateforme.";
      jsonMap['openInBrowserHint'] = "Vous pouvez ouvrir l'optimiseur dans votre navigateur.";
    } else if (isItalian) {
      jsonMap['webViewNotSupported'] = "WebView non è disponibile su questa piattaforma.";
      jsonMap['openInBrowserHint'] = "Puoi aprire l'ottimizzatore nel tuo browser.";
    } else if (isPolish) {
      jsonMap['webViewNotSupported'] = 'WebView nie jest dostępne na tej platformie.';
      jsonMap['openInBrowserHint'] = 'Możesz otworzyć optymalizator w przeglądarce.';
    } else if (isPortuguese) {
      jsonMap['webViewNotSupported'] = 'WebView não está disponível nesta plataforma.';
      jsonMap['openInBrowserHint'] = 'Você pode abrir o otimizador no seu navegador.';
    } else {
      jsonMap['webViewNotSupported'] = 'WebView is not available on this platform.';
      jsonMap['openInBrowserHint'] = 'You can open the optimizer in your browser.';
    }

    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonMap) + '\n');
  }
  print('Done updating ARB files.');
}
