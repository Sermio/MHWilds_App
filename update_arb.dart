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

    // add listView
    if (isSpanish) jsonMap['listView'] = 'Lista';
    else if (isGerman) jsonMap['listView'] = 'Liste';
    else if (isFrench) jsonMap['listView'] = 'Liste';
    else if (isItalian) jsonMap['listView'] = 'Lista';
    else if (isPolish) jsonMap['listView'] = 'Lista';
    else if (isPortuguese) jsonMap['listView'] = 'Lista';
    else jsonMap['listView'] = 'List';

    // add treeView
    if (isSpanish) jsonMap['treeView'] = 'Árbol';
    else if (isGerman) jsonMap['treeView'] = 'Baum';
    else if (isFrench) jsonMap['treeView'] = 'Arbre';
    else if (isItalian) jsonMap['treeView'] = 'Albero';
    else if (isPolish) jsonMap['treeView'] = 'Drzewo';
    else if (isPortuguese) jsonMap['treeView'] = 'Árvore';
    else jsonMap['treeView'] = 'Tree';

    // add treeSeries
    if (isSpanish) jsonMap['treeSeries'] = 'Series del árbol';
    else if (isGerman) jsonMap['treeSeries'] = 'Baumserie';
    else if (isFrench) jsonMap['treeSeries'] = "Séries d'arbres";
    else if (isItalian) jsonMap['treeSeries'] = "Serie dell'albero";
    else if (isPolish) jsonMap['treeSeries'] = 'Serie drzewa';
    else if (isPortuguese) jsonMap['treeSeries'] = 'Séries da árvore';
    else jsonMap['treeSeries'] = 'Tree Series';

    // add enterSeriesName
    if (isSpanish) jsonMap['enterSeriesName'] = 'Introducir nombre de la serie...';
    else if (isGerman) jsonMap['enterSeriesName'] = 'Seriennamen eingeben...';
    else if (isFrench) jsonMap['enterSeriesName'] = 'Entrez le nom de la série...';
    else if (isItalian) jsonMap['enterSeriesName'] = 'Inserisci il nome della serie...';
    else if (isPolish) jsonMap['enterSeriesName'] = 'Wpisz nazwę serii...';
    else if (isPortuguese) jsonMap['enterSeriesName'] = 'Insira o nome da série...';
    else jsonMap['enterSeriesName'] = 'Enter series name...';

    // add noSeries
    if (isSpanish) jsonMap['noSeries'] = 'Sin serie';
    else if (isGerman) jsonMap['noSeries'] = 'Keine Serie';
    else if (isFrench) jsonMap['noSeries'] = 'Sans série';
    else if (isItalian) jsonMap['noSeries'] = 'Nessuna serie';
    else if (isPolish) jsonMap['noSeries'] = 'Brak serii';
    else if (isPortuguese) jsonMap['noSeries'] = 'Sem série';
    else jsonMap['noSeries'] = 'No Series';

    // add treeViewTooltip
    if (isSpanish) jsonMap['treeViewTooltip'] = 'Vista de árbol';
    else if (isGerman) jsonMap['treeViewTooltip'] = 'Baumansicht';
    else if (isFrench) jsonMap['treeViewTooltip'] = 'Vue en arbre';
    else if (isItalian) jsonMap['treeViewTooltip'] = 'Vista ad albero';
    else if (isPolish) jsonMap['treeViewTooltip'] = 'Widok drzewa';
    else if (isPortuguese) jsonMap['treeViewTooltip'] = 'Vista de árvore';
    else jsonMap['treeViewTooltip'] = 'Tree View';

    // add tableViewTooltip
    if (isSpanish) jsonMap['tableViewTooltip'] = 'Vista de tabla';
    else if (isGerman) jsonMap['tableViewTooltip'] = 'Tabellenansicht';
    else if (isFrench) jsonMap['tableViewTooltip'] = 'Vue en tableau';
    else if (isItalian) jsonMap['tableViewTooltip'] = 'Vista tabella';
    else if (isPolish) jsonMap['tableViewTooltip'] = 'Widok tabeli';
    else if (isPortuguese) jsonMap['tableViewTooltip'] = 'Vista de tabela';
    else jsonMap['tableViewTooltip'] = 'Table View';

    // add errorLoadingWeaponDetails
    if (isSpanish) jsonMap['errorLoadingWeaponDetails'] = 'Error al cargar los detalles del arma';
    else if (isGerman) jsonMap['errorLoadingWeaponDetails'] = 'Fehler beim Laden der Waffendetails';
    else if (isFrench) jsonMap['errorLoadingWeaponDetails'] = "Erreur lors du chargement des détails de l'arme";
    else if (isItalian) jsonMap['errorLoadingWeaponDetails'] = "Errore durante il caricamento dei dettagli dell'arma";
    else if (isPolish) jsonMap['errorLoadingWeaponDetails'] = 'Błąd podczas ładowania szczegółów broni';
    else if (isPortuguese) jsonMap['errorLoadingWeaponDetails'] = 'Erro ao carregar detalhes da arma';
    else jsonMap['errorLoadingWeaponDetails'] = 'Error loading weapon details';

    // add masterRank
    if (isSpanish) jsonMap['masterRank'] = 'Rango Maestro';
    else if (isGerman) jsonMap['masterRank'] = 'Meisterrang';
    else if (isFrench) jsonMap['masterRank'] = 'Rang Maître';
    else if (isItalian) jsonMap['masterRank'] = 'Rango Maestro';
    else if (isPolish) jsonMap['masterRank'] = 'Mistrzowska ranga';
    else if (isPortuguese) jsonMap['masterRank'] = 'Rank Mestre';
    else jsonMap['masterRank'] = 'Master Rank';

    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(jsonMap) + '\n');
  }
  print('Done updating ARB files.');
}
