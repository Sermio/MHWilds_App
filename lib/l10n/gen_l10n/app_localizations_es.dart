// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MHWilds Assistant';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get locations => 'Ubicaciones';

  @override
  String get monsters => 'Monstruos';

  @override
  String get weapons => 'Armas';

  @override
  String get armor => 'Armadura';

  @override
  String get items => 'Objetos';

  @override
  String get decorations => 'Decoraciones';

  @override
  String get skills => 'Habilidades';

  @override
  String get talismans => 'Talismanes';

  @override
  String get reset => 'Restablecer';

  @override
  String get skillDetails => 'Detalles de habilidad';

  @override
  String get monsterNotFound => 'No se encontró el monstruo';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get goToStore => 'Ir a la tienda';

  @override
  String get newVersionAvailable => 'Nueva versión disponible';

  @override
  String get appearance => 'Apariencia';

  @override
  String get on => 'Activado';

  @override
  String get offDefault => 'Desactivado (por defecto)';

  @override
  String get armorSets => 'Conjuntos de armadura';

  @override
  String get menuMonstersSubtitle => 'Base de datos de monstruos';

  @override
  String get menuLocationsSubtitle => 'Explora los mapas y campamentos';

  @override
  String get menuItemsSubtitle => 'Materiales y recursos';

  @override
  String get menuDecorationsSubtitle => 'Gemas y joyas de habilidades';

  @override
  String get menuTalismansSubtitle => 'Accesorios poderosos';

  @override
  String get menuArmorSetsSubtitle => 'Colecciones de armadura completas';

  @override
  String get menuWeaponsSubtitle => 'Armas y herramientas de combate';

  @override
  String get menuSkillsSubtitle => 'Habilidades de combate y efectos';

  @override
  String get buildOptimizer => 'Optimizador de builds';

  @override
  String get buildOptimizerMenuSubtitle => 'Optimiza tu build y habilidades';

  @override
  String get buildOptimizerCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Optimizer como colaboración externa.';

  @override
  String get buildOptimizerCreditsCreator => 'Creado por Nenrikido (Nenri).';

  @override
  String get buildCrafter => 'Constructor de builds';

  @override
  String get buildCrafterMenuSubtitle => 'Planifica y crea builds';

  @override
  String get buildCrafterCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Crafter como colaboración externa.';

  @override
  String get buildCrafterCreditsCreator => 'Creado por Cay.';

  @override
  String get buildCrafterWebViewUnavailable =>
      'WebView no está disponible en esta plataforma.';

  @override
  String get buildCrafterOpenInBrowser => 'Abrir en el navegador';

  @override
  String get rateAppReminder => 'No olvides calificar la app si te gusta.';

  @override
  String get understood => 'Entendido';

  @override
  String get web => 'Web';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String get updateMessageGeneric =>
      'Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';

  @override
  String get filters => 'Filtros';

  @override
  String get loadingSkills => 'Cargando habilidades...';

  @override
  String get searchByName => 'Buscar por nombre';

  @override
  String get enterMonsterName => 'Introduce el nombre del monstruo...';

  @override
  String get searchBySpecies => 'Buscar por especie';

  @override
  String get enterSpecies => 'Introduce la especie...';

  @override
  String get loadingMonsters => 'Cargando monstruos...';

  @override
  String get noMonstersFound => 'No se encontraron monstruos';

  @override
  String get tryAdjustingFilters => 'Prueba a ajustar los filtros';

  @override
  String get type => 'Tipo';

  @override
  String get rarity => 'Rareza';

  @override
  String rarityLevel(int n) {
    return 'Rareza $n';
  }

  @override
  String get enterWeaponName => 'Introduce el nombre del arma...';

  @override
  String get enterItemName => 'Introduce el nombre del objeto...';

  @override
  String get enterArmorSetName => 'Introduce el nombre del conjunto...';

  @override
  String get enterTalismanName => 'Introduce el nombre del talismán...';

  @override
  String get enterSkillName => 'Introduce el nombre de la habilidad...';

  @override
  String get enterDecorationName => 'Introduce el nombre de la decoración...';

  @override
  String get loadingWeapons => 'Cargando armas...';

  @override
  String get loadingItems => 'Cargando objetos...';

  @override
  String get loadingArmorSets => 'Cargando conjuntos de armadura...';

  @override
  String get loadingTalismans => 'Cargando talismanes...';

  @override
  String get loadingDecorations => 'Cargando decoraciones...';

  @override
  String get noWeaponsFound => 'No se encontraron armas';

  @override
  String get noItemsFound => 'No se encontraron objetos';

  @override
  String get noArmorSetsFound => 'No se encontraron conjuntos';

  @override
  String get noTalismansFound => 'No se encontraron talismanes';

  @override
  String get noSkillsFound => 'No se encontraron habilidades';

  @override
  String get noDecorationsFound => 'No se encontraron decoraciones';

  @override
  String get armorSlotHead => 'Cabeza';

  @override
  String get armorSlotChest => 'Torso';

  @override
  String get armorSlotArms => 'Brazos';

  @override
  String get armorSlotWaist => 'Cintura';

  @override
  String get armorSlotLegs => 'Piernas';

  @override
  String get typeWeapon => 'Arma';

  @override
  String get typeArmor => 'Armadura';

  @override
  String get typeGroup => 'Grupo';

  @override
  String get typeSet => 'Conjunto';

  @override
  String get weaponKindGreatSword => 'Gran espada';

  @override
  String get weaponKindLongSword => 'Espada larga';

  @override
  String get weaponKindSwordShield => 'Espada y escudo';

  @override
  String get weaponKindDualBlades => 'Espadas dobles';

  @override
  String get weaponKindHammer => 'Martillo';

  @override
  String get weaponKindHuntingHorn => 'Cornamusa';

  @override
  String get weaponKindLance => 'Lanza';

  @override
  String get weaponKindGunlance => 'Lanza pistola';

  @override
  String get weaponKindSwitchAxe => 'Hacha espada';

  @override
  String get weaponKindChargeBlade => 'Hacha cargada';

  @override
  String get weaponKindInsectGlaive => 'Glaive insecto';

  @override
  String get weaponKindBow => 'Arco';

  @override
  String get weaponKindLightBowgun => 'Ballesta ligera';

  @override
  String get weaponKindHeavyBowgun => 'Ballesta pesada';

  @override
  String get pieces => 'piezas';

  @override
  String get defense => 'Defensa';

  @override
  String get baseDefense => 'Defensa base';

  @override
  String get slots => 'Ranuras';

  @override
  String get resistances => 'Resistencias';

  @override
  String get noSlots => 'Sin ranuras';

  @override
  String get noResistances => 'Sin resistencias';

  @override
  String get physicalDamage => 'Daño físico';

  @override
  String get affinity => 'Afinidad';

  @override
  String get sharpness => 'Afilado';

  @override
  String get element => 'Elemento';

  @override
  String get statusEffect => 'Efecto de estado';

  @override
  String get phial => 'Frasco';

  @override
  String get coatings => 'Recubrimientos';

  @override
  String get shell => 'Cáscara';

  @override
  String get melody => 'Melodía';

  @override
  String get songs => 'canciones';

  @override
  String get echoBubble => 'Burbuja de eco';

  @override
  String get echoWave => 'Onda de eco';

  @override
  String get ammo => 'Munición';

  @override
  String get kinsect => 'Insecto';

  @override
  String get level => 'Nivel';

  @override
  String campsOfLevel(int n) {
    return 'Campamentos de Nivel $n';
  }

  @override
  String get risk => 'Riesgo';

  @override
  String get zone => 'Zona';

  @override
  String get loadingMap => 'Cargando mapa...';

  @override
  String get noMapImagesFound => 'No se encontraron imágenes del mapa';

  @override
  String get monsterInformation => 'Información del Monstruo';

  @override
  String get species => 'Especie';

  @override
  String get description => 'Descripción';

  @override
  String get features => 'Características';

  @override
  String get huntingTips => 'Consejos de Caza';

  @override
  String get monsterVariants => 'Variantes del Monstruo';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get baseHealth => 'Salud Base';

  @override
  String get sizeRange => 'Rango de Tamaño';

  @override
  String get elements => 'Elementos';

  @override
  String get weaknessesAndResistances => 'Debilidades y Resistencias';

  @override
  String get weaknesses => 'Debilidades';

  @override
  String get noKnownWeaknesses => 'No se conocen debilidades';

  @override
  String get noKnownResistances => 'No se conocen resistencias';

  @override
  String get highRank => 'Rango Alto';

  @override
  String get lowRank => 'Rango Bajo';

  @override
  String get crownSizes => 'Tamaños de Corona';

  @override
  String get baseSize => 'Tamaño base';

  @override
  String get miniCrown => 'Corona mini';

  @override
  String get silverCrown => 'Corona plateada';

  @override
  String get goldCrown => 'Corona dorada';

  @override
  String get elementsAndAilments => 'Elementos y Afecciones';

  @override
  String get monstersThatDropThisItem => 'Monstruos que sueltan este objeto:';

  @override
  String get dropConditions => 'Condiciones de Obtención:';

  @override
  String get craftingRecipe => 'Receta de Fabricación:';

  @override
  String get requiredMaterials => 'Materiales Requeridos:';

  @override
  String get skillRanks => 'Rangos de Habilidad:';

  @override
  String get rank => 'Rango';

  @override
  String get errorLoadingSkills => 'Error al cargar habilidades';

  @override
  String get noSkillsAvailable => 'No hay habilidades disponibles';

  @override
  String get craftingMaterials => 'Materiales de Fabricación';

  @override
  String get craft => 'Fabricar';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get defenseBonus => 'Bonificación de Defensa';

  @override
  String get elderseal => 'Sello Ancestral';

  @override
  String get lv => 'Nv';

  @override
  String get sharpnessRed => 'Rojo';

  @override
  String get sharpnessOrange => 'Naranja';

  @override
  String get sharpnessYellow => 'Amarillo';

  @override
  String get sharpnessGreen => 'Verde';

  @override
  String get sharpnessBlue => 'Azul';

  @override
  String get sharpnessWhite => 'Blanco';

  @override
  String get sharpnessPurple => 'Morado';

  @override
  String get setBonus => 'Bonificación de Set:';

  @override
  String get locationsLabel => 'Ubicaciones:';

  @override
  String get breakableParts => 'Partes Rompibles';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownMap => 'Mapa Desconocido';

  @override
  String get map => 'Mapa';

  @override
  String get rateAppTitle => '¿Te gusta la app?';

  @override
  String get rateAppMessage =>
      '¿Estás disfrutando de MHWilds Assistant? Tu valoración nos ayuda mucho a seguir mejorando.';

  @override
  String get rateAppYes => '¡Sí, me encanta!';

  @override
  String get rateAppNo => 'Ahora no / No';

  @override
  String get rateAppAction => 'Valorar aplicación';

  @override
  String get speciesFangedWyvern => 'Wyvern de colmillos';

  @override
  String get speciesFlyingWyvern => 'Wyvern volador';

  @override
  String get speciesBruteWyvern => 'Wyvern bruto';

  @override
  String get speciesBirdWyvern => 'Wyvern pájaro';

  @override
  String get speciesPiscineWyvern => 'Wyvern piscino';

  @override
  String get speciesFangedBeast => 'Bestia de colmillos';

  @override
  String get speciesElderDragon => 'Dragón anciano';

  @override
  String get speciesRelicat => 'Relicat';

  @override
  String get speciesNeopteron => 'Neopterón';

  @override
  String get speciesTemnoceran => 'Temnocerán';

  @override
  String get speciesLeviathan => 'Leviatán';

  @override
  String get speciesAmphibian => 'Anfibio';

  @override
  String get speciesSnakeWyvern => 'Wyvern serpiente';

  @override
  String get monsterKindLarge => 'Monstruo grande';

  @override
  String get monsterKindSmall => 'Monstruo pequeño';

  @override
  String get showMore => 'Ver más';

  @override
  String get showLess => 'Ver menos';

  @override
  String get camps => 'Campamentos';

  @override
  String get openOptimizer => 'Abrir optimizador';

  @override
  String get ok => 'OK';

  @override
  String get webViewNotSupported => 'WebView no disponible en esta plataforma.';

  @override
  String get openInBrowserHint =>
      'Puedes abrir el optimizador en tu navegador.';

  @override
  String get weaponTree => 'Árbol del arma';

  @override
  String get previousWeapon => 'Mejora de';

  @override
  String get upgradesTo => 'Mejora a';

  @override
  String get listView => 'Lista';

  @override
  String get treeView => 'Árbol';

  @override
  String get treeSeries => 'Series del árbol';

  @override
  String get enterSeriesName => 'Introducir nombre de la serie...';

  @override
  String get noSeries => 'Sin serie';

  @override
  String get treeViewTooltip => 'Vista de árbol';

  @override
  String get tableViewTooltip => 'Vista de tabla';

  @override
  String get errorLoadingWeaponDetails =>
      'Error al cargar los detalles del arma';

  @override
  String get masterRank => 'Rango Maestro';

  @override
  String get retry => 'Reintentar';

  @override
  String get errorOffline =>
      'Sin conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get errorLoadingData =>
      'No se pudieron cargar los datos. Inténtalo de nuevo.';

  @override
  String offlineDataFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sin conexión · datos del $dateString';
  }

  @override
  String get creditsTooltip => 'Créditos';

  @override
  String get elementFire => 'Fuego';

  @override
  String get elementWater => 'Agua';

  @override
  String get elementIce => 'Hielo';

  @override
  String get elementThunder => 'Rayo';

  @override
  String get elementDragon => 'Dragón';

  @override
  String get elementParalysis => 'Parálisis';

  @override
  String get elementPoison => 'Veneno';

  @override
  String get elementSleep => 'Sueño';

  @override
  String get elementBlastblight => 'Explosión';

  @override
  String get elementBlast => 'Explosivo';

  @override
  String get elementFireblight => 'Plaga de fuego';

  @override
  String get elementWaterblight => 'Plaga de agua';

  @override
  String get elementIceblight => 'Plaga de hielo';

  @override
  String get elementThunderblight => 'Plaga de rayo';

  @override
  String get elementDragonblight => 'Plaga de dragón';

  @override
  String get elementFrostblight => 'Congelación';

  @override
  String get elementWebbed => 'Enredado';

  @override
  String get elementBleeding => 'Hemorragia';

  @override
  String get elementFrenzy => 'Frenesí';

  @override
  String get ailmentDescThunderblight =>
      'La plaga de rayo la causa el elemento Rayo y aumenta la probabilidad de que los ataques de los monstruos aturdan al cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescWaterblight =>
      'La plaga de agua la causa el elemento Agua y reduce la recuperación de aguante del cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescFireblight =>
      'La plaga de fuego la causa el elemento Fuego y hace que el cazador pierda salud con el tiempo.\nSe cura consumiendo una Nulberry. Si hay agua cerca, se puede saltar a ella o rodar 3 veces por el suelo.';

  @override
  String get ailmentDescIceblight =>
      'La plaga de hielo la causa el elemento Hielo y aumenta el consumo de aguante al correr, atacar o esquivar.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescDragonblight =>
      'La plaga de dragón la causa el elemento Dragón y anula los efectos de daño y la acumulación de estados de este elemento.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescBlast =>
      'Explosivo es un estado que marca a un monstruo y permite dañarlo con pequeñas explosiones.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBlastblight =>
      'La explosión hace que el objetivo estalle pasado un tiempo o al recibir un ataque contundente.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBleeding =>
      'La hemorragia hace que el cazador pierda salud al moverse, atacar o esquivar.\nSe cura comiendo Astera Jerky, Well-Done Steak o Sushifish Scale, o agachándose unos segundos.';

  @override
  String get ailmentDescFrenzy =>
      'El frenesí hace que el cazador reciba temporalmente más daño cuando está totalmente infectado.\nSe cura usando una Nulberry.';

  @override
  String get ailmentDescFrostblight =>
      'La congelación impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser o con Resistencia a la inmovilización de nivel 3.';

  @override
  String get ailmentDescWebbed =>
      'Enredado impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser, moviéndose, pulsando botones, recibiendo el golpe de un ataque o un impacto.';

  @override
  String get ailmentDescPoison =>
      'El veneno reduce poco a poco la salud del objetivo con el tiempo.\nSe cura con Antidote, Herbal Medicine o Herbal Powder.';

  @override
  String get ailmentDescSleep =>
      'El sueño hace que el objetivo se duerma y quede expuesto a un único ataque.\nEl objetivo se despierta al recibir daño.\nSe cura con un Energy Drink, de un aliado o de un monstruo.';

  @override
  String get ailmentDescParalysis =>
      'La parálisis inmoviliza al cazador o al monstruo y lo hace vulnerable a más daño mientras dura.\nSe cura con impactos que lancen con mucha fuerza hacia atrás, como un golpe ascendente de un Martillo o un Espadón.';

  @override
  String get announcements => 'Anuncios';

  @override
  String get announcementsNew => 'Anuncios (nuevo)';

  @override
  String get loadingAnnouncements => 'Cargando anuncios...';

  @override
  String get noAnnouncements => 'Aún no hay anuncios';

  @override
  String get openLink => 'Abrir enlace';

  @override
  String get reportBug => 'Reportar un error';

  @override
  String get bugReportDescriptionLabel => '¿Qué ocurrió?';

  @override
  String get bugReportDescriptionHint =>
      'Describe el problema y cómo reproducirlo';

  @override
  String get bugReportDescriptionRequired => 'Describe el problema';

  @override
  String get bugReportContactLabel => 'Tu email (opcional)';

  @override
  String get bugReportContactHint => 'Solo si quieres recibir respuesta';

  @override
  String get bugReportAttach => 'Adjuntar imágenes o vídeos';

  @override
  String bugReportAttachLimit(int max, int mb) {
    return 'Hasta $max archivos, $mb MB en total';
  }

  @override
  String get bugReportRemoveAttachment => 'Quitar adjunto';

  @override
  String get bugReportSend => 'Enviar reporte';

  @override
  String get bugReportSending => 'Enviando...';

  @override
  String get bugReportSent => '¡Gracias! Tu reporte fue enviado.';

  @override
  String get bugReportFailed =>
      'No se pudo enviar el reporte. Inténtalo más tarde.';

  @override
  String bugReportTooMany(int max) {
    return 'Puedes adjuntar como máximo $max archivos.';
  }

  @override
  String bugReportTooLarge(int mb) {
    return 'Los adjuntos superan $mb MB.';
  }

  @override
  String get bugReportPrivacy =>
      'El reporte incluye la versión de la app, la plataforma y el idioma.';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get appTitle => 'MHWilds Assistant';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get locations => 'Ubicaciones';

  @override
  String get monsters => 'Monstruos';

  @override
  String get weapons => 'Armas';

  @override
  String get armor => 'Armadura';

  @override
  String get items => 'Objetos';

  @override
  String get decorations => 'Decoraciones';

  @override
  String get skills => 'Habilidades';

  @override
  String get talismans => 'Talismanes';

  @override
  String get reset => 'Restablecer';

  @override
  String get skillDetails => 'Detalles de habilidad';

  @override
  String get monsterNotFound => 'No se encontró el monstruo';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get goToStore => 'Ir a la tienda';

  @override
  String get newVersionAvailable => 'Nueva versión disponible';

  @override
  String get appearance => 'Apariencia';

  @override
  String get on => 'Activado';

  @override
  String get offDefault => 'Desactivado (por defecto)';

  @override
  String get armorSets => 'Conjuntos de armadura';

  @override
  String get menuMonstersSubtitle => 'Base de datos de monstruos';

  @override
  String get menuLocationsSubtitle => 'Explora los mapas y campamentos';

  @override
  String get menuItemsSubtitle => 'Materiales y recursos';

  @override
  String get menuDecorationsSubtitle => 'Gemas y joyas de habilidades';

  @override
  String get menuTalismansSubtitle => 'Accesorios poderosos';

  @override
  String get menuArmorSetsSubtitle => 'Colecciones de armadura completas';

  @override
  String get menuWeaponsSubtitle => 'Armas y herramientas de combate';

  @override
  String get menuSkillsSubtitle => 'Habilidades de combate y efectos';

  @override
  String get buildOptimizer => 'Optimizador de builds';

  @override
  String get buildOptimizerMenuSubtitle => 'Optimiza tu build y habilidades';

  @override
  String get buildOptimizerCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Optimizer como colaboración externa.';

  @override
  String get buildOptimizerCreditsCreator => 'Creado por Nenrikido (Nenri).';

  @override
  String get buildCrafter => 'Constructor de builds';

  @override
  String get buildCrafterMenuSubtitle => 'Planifica y crea builds';

  @override
  String get buildCrafterCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Crafter como colaboración externa.';

  @override
  String get buildCrafterCreditsCreator => 'Creado por Cay.';

  @override
  String get buildCrafterWebViewUnavailable =>
      'WebView no está disponible en esta plataforma.';

  @override
  String get buildCrafterOpenInBrowser => 'Abrir en el navegador';

  @override
  String get rateAppReminder => 'No olvides calificar la app si te gusta.';

  @override
  String get understood => 'Entendido';

  @override
  String get web => 'Web';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String get updateMessageGeneric =>
      'Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';

  @override
  String get filters => 'Filtros';

  @override
  String get loadingSkills => 'Cargando habilidades...';

  @override
  String get searchByName => 'Buscar por nombre';

  @override
  String get enterMonsterName => 'Introduce el nombre del monstruo...';

  @override
  String get searchBySpecies => 'Buscar por especie';

  @override
  String get enterSpecies => 'Introduce la especie...';

  @override
  String get loadingMonsters => 'Cargando monstruos...';

  @override
  String get noMonstersFound => 'No se encontraron monstruos';

  @override
  String get tryAdjustingFilters => 'Prueba a ajustar los filtros';

  @override
  String get type => 'Tipo';

  @override
  String get rarity => 'Rareza';

  @override
  String rarityLevel(int n) {
    return 'Rareza $n';
  }

  @override
  String get enterWeaponName => 'Introduce el nombre del arma...';

  @override
  String get enterItemName => 'Introduce el nombre del objeto...';

  @override
  String get enterArmorSetName => 'Introduce el nombre del conjunto...';

  @override
  String get enterTalismanName => 'Introduce el nombre del talismán...';

  @override
  String get enterSkillName => 'Introduce el nombre de la habilidad...';

  @override
  String get enterDecorationName => 'Introduce el nombre de la decoración...';

  @override
  String get loadingWeapons => 'Cargando armas...';

  @override
  String get loadingItems => 'Cargando objetos...';

  @override
  String get loadingArmorSets => 'Cargando conjuntos de armadura...';

  @override
  String get loadingTalismans => 'Cargando talismanes...';

  @override
  String get loadingDecorations => 'Cargando decoraciones...';

  @override
  String get noWeaponsFound => 'No se encontraron armas';

  @override
  String get noItemsFound => 'No se encontraron objetos';

  @override
  String get noArmorSetsFound => 'No se encontraron conjuntos';

  @override
  String get noTalismansFound => 'No se encontraron talismanes';

  @override
  String get noSkillsFound => 'No se encontraron habilidades';

  @override
  String get noDecorationsFound => 'No se encontraron decoraciones';

  @override
  String get armorSlotHead => 'Cabeza';

  @override
  String get armorSlotChest => 'Torso';

  @override
  String get armorSlotArms => 'Brazos';

  @override
  String get armorSlotWaist => 'Cintura';

  @override
  String get armorSlotLegs => 'Piernas';

  @override
  String get typeWeapon => 'Arma';

  @override
  String get typeArmor => 'Armadura';

  @override
  String get typeGroup => 'Grupo';

  @override
  String get typeSet => 'Conjunto';

  @override
  String get weaponKindGreatSword => 'Gran espada';

  @override
  String get weaponKindLongSword => 'Espada larga';

  @override
  String get weaponKindSwordShield => 'Espada y escudo';

  @override
  String get weaponKindDualBlades => 'Espadas dobles';

  @override
  String get weaponKindHammer => 'Martillo';

  @override
  String get weaponKindHuntingHorn => 'Cornamusa';

  @override
  String get weaponKindLance => 'Lanza';

  @override
  String get weaponKindGunlance => 'Lanza pistola';

  @override
  String get weaponKindSwitchAxe => 'Hacha espada';

  @override
  String get weaponKindChargeBlade => 'Hacha cargada';

  @override
  String get weaponKindInsectGlaive => 'Glaive insecto';

  @override
  String get weaponKindBow => 'Arco';

  @override
  String get weaponKindLightBowgun => 'Ballesta ligera';

  @override
  String get weaponKindHeavyBowgun => 'Ballesta pesada';

  @override
  String get pieces => 'piezas';

  @override
  String get defense => 'Defensa';

  @override
  String get baseDefense => 'Defensa base';

  @override
  String get slots => 'Ranuras';

  @override
  String get resistances => 'Resistencias';

  @override
  String get noSlots => 'Sin ranuras';

  @override
  String get noResistances => 'Sin resistencias';

  @override
  String get physicalDamage => 'Daño físico';

  @override
  String get affinity => 'Afinidad';

  @override
  String get sharpness => 'Afilado';

  @override
  String get element => 'Elemento';

  @override
  String get statusEffect => 'Efecto de estado';

  @override
  String get phial => 'Frasco';

  @override
  String get coatings => 'Recubrimientos';

  @override
  String get shell => 'Cáscara';

  @override
  String get melody => 'Melodía';

  @override
  String get songs => 'canciones';

  @override
  String get echoBubble => 'Burbuja de eco';

  @override
  String get echoWave => 'Onda de eco';

  @override
  String get ammo => 'Munición';

  @override
  String get kinsect => 'Insecto';

  @override
  String get level => 'Nivel';

  @override
  String campsOfLevel(int n) {
    return 'Campamentos de Nivel $n';
  }

  @override
  String get risk => 'Riesgo';

  @override
  String get zone => 'Zona';

  @override
  String get loadingMap => 'Cargando mapa...';

  @override
  String get noMapImagesFound => 'No se encontraron imágenes del mapa';

  @override
  String get monsterInformation => 'Información del Monstruo';

  @override
  String get species => 'Especie';

  @override
  String get description => 'Descripción';

  @override
  String get features => 'Características';

  @override
  String get huntingTips => 'Consejos de Caza';

  @override
  String get monsterVariants => 'Variantes del Monstruo';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get baseHealth => 'Salud Base';

  @override
  String get sizeRange => 'Rango de Tamaño';

  @override
  String get elements => 'Elementos';

  @override
  String get weaknessesAndResistances => 'Debilidades y Resistencias';

  @override
  String get weaknesses => 'Debilidades';

  @override
  String get noKnownWeaknesses => 'No se conocen debilidades';

  @override
  String get noKnownResistances => 'No se conocen resistencias';

  @override
  String get highRank => 'Rango Alto';

  @override
  String get lowRank => 'Rango Bajo';

  @override
  String get crownSizes => 'Tamaños de Corona';

  @override
  String get baseSize => 'Tamaño base';

  @override
  String get miniCrown => 'Corona mini';

  @override
  String get silverCrown => 'Corona plateada';

  @override
  String get goldCrown => 'Corona dorada';

  @override
  String get elementsAndAilments => 'Elementos y Afecciones';

  @override
  String get monstersThatDropThisItem => 'Monstruos que sueltan este objeto:';

  @override
  String get dropConditions => 'Condiciones de Obtención:';

  @override
  String get craftingRecipe => 'Receta de Fabricación:';

  @override
  String get requiredMaterials => 'Materiales Requeridos:';

  @override
  String get skillRanks => 'Rangos de Habilidad:';

  @override
  String get rank => 'Rango';

  @override
  String get errorLoadingSkills => 'Error al cargar habilidades';

  @override
  String get noSkillsAvailable => 'No hay habilidades disponibles';

  @override
  String get craftingMaterials => 'Materiales de Fabricación';

  @override
  String get craft => 'Fabricar';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get defenseBonus => 'Bonificación de Defensa';

  @override
  String get elderseal => 'Sello Ancestral';

  @override
  String get lv => 'Nv';

  @override
  String get sharpnessRed => 'Rojo';

  @override
  String get sharpnessOrange => 'Naranja';

  @override
  String get sharpnessYellow => 'Amarillo';

  @override
  String get sharpnessGreen => 'Verde';

  @override
  String get sharpnessBlue => 'Azul';

  @override
  String get sharpnessWhite => 'Blanco';

  @override
  String get sharpnessPurple => 'Morado';

  @override
  String get setBonus => 'Bonificación de Set:';

  @override
  String get locationsLabel => 'Ubicaciones:';

  @override
  String get breakableParts => 'Partes Rompibles';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownMap => 'Mapa Desconocido';

  @override
  String get map => 'Mapa';

  @override
  String get rateAppTitle => '¿Te gusta la app?';

  @override
  String get rateAppMessage =>
      '¿Estás disfrutando de MHWilds Assistant? Tu valoración nos ayuda mucho a seguir mejorando.';

  @override
  String get rateAppYes => '¡Sí, me encanta!';

  @override
  String get rateAppNo => 'Ahora no / No';

  @override
  String get rateAppAction => 'Valorar aplicación';

  @override
  String get speciesFangedWyvern => 'Wyvern de colmillos';

  @override
  String get speciesFlyingWyvern => 'Wyvern volador';

  @override
  String get speciesBruteWyvern => 'Wyvern bruto';

  @override
  String get speciesBirdWyvern => 'Wyvern pájaro';

  @override
  String get speciesPiscineWyvern => 'Wyvern piscino';

  @override
  String get speciesFangedBeast => 'Bestia de colmillos';

  @override
  String get speciesElderDragon => 'Dragón anciano';

  @override
  String get speciesRelicat => 'Relicat';

  @override
  String get speciesNeopteron => 'Neopterón';

  @override
  String get speciesTemnoceran => 'Temnocerán';

  @override
  String get speciesLeviathan => 'Leviatán';

  @override
  String get speciesAmphibian => 'Anfibio';

  @override
  String get speciesSnakeWyvern => 'Wyvern serpiente';

  @override
  String get monsterKindLarge => 'Monstruo grande';

  @override
  String get monsterKindSmall => 'Monstruo pequeño';

  @override
  String get camps => 'Campamentos';

  @override
  String get openOptimizer => 'Abrir optimizador';

  @override
  String get ok => 'OK';

  @override
  String get webViewNotSupported => 'WebView no disponible en esta plataforma.';

  @override
  String get openInBrowserHint =>
      'Puedes abrir el optimizador en tu navegador.';

  @override
  String get listView => 'Lista';

  @override
  String get treeView => 'Árbol';

  @override
  String get treeSeries => 'Series del árbol';

  @override
  String get enterSeriesName => 'Introducir nombre de la serie...';

  @override
  String get noSeries => 'Sin serie';

  @override
  String get treeViewTooltip => 'Vista de árbol';

  @override
  String get tableViewTooltip => 'Vista de tabla';

  @override
  String get errorLoadingWeaponDetails =>
      'Error al cargar los detalles del arma';

  @override
  String get masterRank => 'Rango Maestro';

  @override
  String get retry => 'Reintentar';

  @override
  String get errorOffline =>
      'Sin conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get errorLoadingData =>
      'No se pudieron cargar los datos. Inténtalo de nuevo.';

  @override
  String offlineDataFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sin conexión · datos del $dateString';
  }

  @override
  String get creditsTooltip => 'Créditos';

  @override
  String get elementFire => 'Fuego';

  @override
  String get elementWater => 'Agua';

  @override
  String get elementIce => 'Hielo';

  @override
  String get elementThunder => 'Rayo';

  @override
  String get elementDragon => 'Dragón';

  @override
  String get elementParalysis => 'Parálisis';

  @override
  String get elementPoison => 'Veneno';

  @override
  String get elementSleep => 'Sueño';

  @override
  String get elementBlastblight => 'Explosión';

  @override
  String get elementBlast => 'Explosivo';

  @override
  String get elementFireblight => 'Plaga de fuego';

  @override
  String get elementWaterblight => 'Plaga de agua';

  @override
  String get elementIceblight => 'Plaga de hielo';

  @override
  String get elementThunderblight => 'Plaga de rayo';

  @override
  String get elementDragonblight => 'Plaga de dragón';

  @override
  String get elementFrostblight => 'Congelación';

  @override
  String get elementWebbed => 'Enredado';

  @override
  String get elementBleeding => 'Hemorragia';

  @override
  String get elementFrenzy => 'Frenesí';

  @override
  String get ailmentDescThunderblight =>
      'La plaga de rayo la causa el elemento Rayo y aumenta la probabilidad de que los ataques de los monstruos aturdan al cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescWaterblight =>
      'La plaga de agua la causa el elemento Agua y reduce la recuperación de aguante del cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescFireblight =>
      'La plaga de fuego la causa el elemento Fuego y hace que el cazador pierda salud con el tiempo.\nSe cura consumiendo una Nulberry. Si hay agua cerca, se puede saltar a ella o rodar 3 veces por el suelo.';

  @override
  String get ailmentDescIceblight =>
      'La plaga de hielo la causa el elemento Hielo y aumenta el consumo de aguante al correr, atacar o esquivar.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescDragonblight =>
      'La plaga de dragón la causa el elemento Dragón y anula los efectos de daño y la acumulación de estados de este elemento.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescBlast =>
      'Explosivo es un estado que marca a un monstruo y permite dañarlo con pequeñas explosiones.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBlastblight =>
      'La explosión hace que el objetivo estalle pasado un tiempo o al recibir un ataque contundente.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBleeding =>
      'La hemorragia hace que el cazador pierda salud al moverse, atacar o esquivar.\nSe cura comiendo Astera Jerky, Well-Done Steak o Sushifish Scale, o agachándose unos segundos.';

  @override
  String get ailmentDescFrenzy =>
      'El frenesí hace que el cazador reciba temporalmente más daño cuando está totalmente infectado.\nSe cura usando una Nulberry.';

  @override
  String get ailmentDescFrostblight =>
      'La congelación impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser o con Resistencia a la inmovilización de nivel 3.';

  @override
  String get ailmentDescWebbed =>
      'Enredado impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser, moviéndose, pulsando botones, recibiendo el golpe de un ataque o un impacto.';

  @override
  String get ailmentDescPoison =>
      'El veneno reduce poco a poco la salud del objetivo con el tiempo.\nSe cura con Antidote, Herbal Medicine o Herbal Powder.';

  @override
  String get ailmentDescSleep =>
      'El sueño hace que el objetivo se duerma y quede expuesto a un único ataque.\nEl objetivo se despierta al recibir daño.\nSe cura con un Energy Drink, de un aliado o de un monstruo.';

  @override
  String get ailmentDescParalysis =>
      'La parálisis inmoviliza al cazador o al monstruo y lo hace vulnerable a más daño mientras dura.\nSe cura con impactos que lancen con mucha fuerza hacia atrás, como un golpe ascendente de un Martillo o un Espadón.';

  @override
  String get announcements => 'Anuncios';

  @override
  String get announcementsNew => 'Anuncios (nuevo)';

  @override
  String get loadingAnnouncements => 'Cargando anuncios...';

  @override
  String get noAnnouncements => 'Aún no hay anuncios';

  @override
  String get openLink => 'Abrir enlace';
}

/// The translations for Spanish Castilian, as used in Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizationsEs {
  AppLocalizationsEsEs() : super('es_ES');

  @override
  String get appTitle => 'MHWilds Assistant';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get locations => 'Ubicaciones';

  @override
  String get monsters => 'Monstruos';

  @override
  String get weapons => 'Armas';

  @override
  String get armor => 'Armadura';

  @override
  String get items => 'Objetos';

  @override
  String get decorations => 'Decoraciones';

  @override
  String get skills => 'Habilidades';

  @override
  String get talismans => 'Talismanes';

  @override
  String get reset => 'Restablecer';

  @override
  String get skillDetails => 'Detalles de habilidad';

  @override
  String get monsterNotFound => 'No se encontró el monstruo';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get goToStore => 'Ir a la tienda';

  @override
  String get newVersionAvailable => 'Nueva versión disponible';

  @override
  String get appearance => 'Apariencia';

  @override
  String get on => 'Activado';

  @override
  String get offDefault => 'Desactivado (por defecto)';

  @override
  String get armorSets => 'Conjuntos de armadura';

  @override
  String get menuMonstersSubtitle => 'Base de datos de monstruos';

  @override
  String get menuLocationsSubtitle => 'Explora los mapas y campamentos';

  @override
  String get menuItemsSubtitle => 'Materiales y recursos';

  @override
  String get menuDecorationsSubtitle => 'Gemas y joyas de habilidades';

  @override
  String get menuTalismansSubtitle => 'Accesorios poderosos';

  @override
  String get menuArmorSetsSubtitle => 'Colecciones de armadura completas';

  @override
  String get menuWeaponsSubtitle => 'Armas y herramientas de combate';

  @override
  String get menuSkillsSubtitle => 'Habilidades de combate y efectos';

  @override
  String get buildOptimizer => 'Optimizador de builds';

  @override
  String get buildOptimizerMenuSubtitle => 'Optimiza tu build y habilidades';

  @override
  String get buildOptimizerCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Optimizer como colaboración externa.';

  @override
  String get buildOptimizerCreditsCreator => 'Creado por Nenrikido (Nenri).';

  @override
  String get buildCrafter => 'Constructor de builds';

  @override
  String get buildCrafterMenuSubtitle => 'Planifica y crea builds';

  @override
  String get buildCrafterCreditsIntro =>
      'Esta pantalla integra MH Wilds Build Crafter como colaboración externa.';

  @override
  String get buildCrafterCreditsCreator => 'Creado por Cay.';

  @override
  String get buildCrafterWebViewUnavailable =>
      'WebView no está disponible en esta plataforma.';

  @override
  String get buildCrafterOpenInBrowser => 'Abrir en el navegador';

  @override
  String get rateAppReminder => 'No olvides calificar la app si te gusta.';

  @override
  String get understood => 'Entendido';

  @override
  String get web => 'Web';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Tienes la versión $currentVersion. Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Hay una nueva versión ($newVersion) en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';
  }

  @override
  String get updateMessageGeneric =>
      'Hay una nueva versión en la tienda. Actualiza para obtener las últimas mejoras y correcciones.';

  @override
  String get filters => 'Filtros';

  @override
  String get loadingSkills => 'Cargando habilidades...';

  @override
  String get searchByName => 'Buscar por nombre';

  @override
  String get enterMonsterName => 'Introduce el nombre del monstruo...';

  @override
  String get searchBySpecies => 'Buscar por especie';

  @override
  String get enterSpecies => 'Introduce la especie...';

  @override
  String get loadingMonsters => 'Cargando monstruos...';

  @override
  String get noMonstersFound => 'No se encontraron monstruos';

  @override
  String get tryAdjustingFilters => 'Prueba a ajustar los filtros';

  @override
  String get type => 'Tipo';

  @override
  String get rarity => 'Rareza';

  @override
  String rarityLevel(int n) {
    return 'Rareza $n';
  }

  @override
  String get enterWeaponName => 'Introduce el nombre del arma...';

  @override
  String get enterItemName => 'Introduce el nombre del objeto...';

  @override
  String get enterArmorSetName => 'Introduce el nombre del conjunto...';

  @override
  String get enterTalismanName => 'Introduce el nombre del talismán...';

  @override
  String get enterSkillName => 'Introduce el nombre de la habilidad...';

  @override
  String get enterDecorationName => 'Introduce el nombre de la decoración...';

  @override
  String get loadingWeapons => 'Cargando armas...';

  @override
  String get loadingItems => 'Cargando objetos...';

  @override
  String get loadingArmorSets => 'Cargando conjuntos de armadura...';

  @override
  String get loadingTalismans => 'Cargando talismanes...';

  @override
  String get loadingDecorations => 'Cargando decoraciones...';

  @override
  String get noWeaponsFound => 'No se encontraron armas';

  @override
  String get noItemsFound => 'No se encontraron objetos';

  @override
  String get noArmorSetsFound => 'No se encontraron conjuntos';

  @override
  String get noTalismansFound => 'No se encontraron talismanes';

  @override
  String get noSkillsFound => 'No se encontraron habilidades';

  @override
  String get noDecorationsFound => 'No se encontraron decoraciones';

  @override
  String get armorSlotHead => 'Cabeza';

  @override
  String get armorSlotChest => 'Torso';

  @override
  String get armorSlotArms => 'Brazos';

  @override
  String get armorSlotWaist => 'Cintura';

  @override
  String get armorSlotLegs => 'Piernas';

  @override
  String get typeWeapon => 'Arma';

  @override
  String get typeArmor => 'Armadura';

  @override
  String get typeGroup => 'Grupo';

  @override
  String get typeSet => 'Conjunto';

  @override
  String get weaponKindGreatSword => 'Gran espada';

  @override
  String get weaponKindLongSword => 'Espada larga';

  @override
  String get weaponKindSwordShield => 'Espada y escudo';

  @override
  String get weaponKindDualBlades => 'Espadas dobles';

  @override
  String get weaponKindHammer => 'Martillo';

  @override
  String get weaponKindHuntingHorn => 'Cornamusa';

  @override
  String get weaponKindLance => 'Lanza';

  @override
  String get weaponKindGunlance => 'Lanza pistola';

  @override
  String get weaponKindSwitchAxe => 'Hacha espada';

  @override
  String get weaponKindChargeBlade => 'Hacha cargada';

  @override
  String get weaponKindInsectGlaive => 'Glaive insecto';

  @override
  String get weaponKindBow => 'Arco';

  @override
  String get weaponKindLightBowgun => 'Ballesta ligera';

  @override
  String get weaponKindHeavyBowgun => 'Ballesta pesada';

  @override
  String get pieces => 'piezas';

  @override
  String get defense => 'Defensa';

  @override
  String get baseDefense => 'Defensa base';

  @override
  String get slots => 'Ranuras';

  @override
  String get resistances => 'Resistencias';

  @override
  String get noSlots => 'Sin ranuras';

  @override
  String get noResistances => 'Sin resistencias';

  @override
  String get physicalDamage => 'Daño físico';

  @override
  String get affinity => 'Afinidad';

  @override
  String get sharpness => 'Afilado';

  @override
  String get element => 'Elemento';

  @override
  String get statusEffect => 'Efecto de estado';

  @override
  String get phial => 'Frasco';

  @override
  String get coatings => 'Recubrimientos';

  @override
  String get shell => 'Cáscara';

  @override
  String get melody => 'Melodía';

  @override
  String get songs => 'canciones';

  @override
  String get echoBubble => 'Burbuja de eco';

  @override
  String get echoWave => 'Onda de eco';

  @override
  String get ammo => 'Munición';

  @override
  String get kinsect => 'Insecto';

  @override
  String get level => 'Nivel';

  @override
  String campsOfLevel(int n) {
    return 'Campamentos de Nivel $n';
  }

  @override
  String get risk => 'Riesgo';

  @override
  String get zone => 'Zona';

  @override
  String get loadingMap => 'Cargando mapa...';

  @override
  String get noMapImagesFound => 'No se encontraron imágenes del mapa';

  @override
  String get monsterInformation => 'Información del Monstruo';

  @override
  String get species => 'Especie';

  @override
  String get description => 'Descripción';

  @override
  String get features => 'Características';

  @override
  String get huntingTips => 'Consejos de Caza';

  @override
  String get monsterVariants => 'Variantes del Monstruo';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get baseHealth => 'Salud Base';

  @override
  String get sizeRange => 'Rango de Tamaño';

  @override
  String get elements => 'Elementos';

  @override
  String get weaknessesAndResistances => 'Debilidades y Resistencias';

  @override
  String get weaknesses => 'Debilidades';

  @override
  String get noKnownWeaknesses => 'No se conocen debilidades';

  @override
  String get noKnownResistances => 'No se conocen resistencias';

  @override
  String get highRank => 'Rango Alto';

  @override
  String get lowRank => 'Rango Bajo';

  @override
  String get crownSizes => 'Tamaños de Corona';

  @override
  String get baseSize => 'Tamaño base';

  @override
  String get miniCrown => 'Corona mini';

  @override
  String get silverCrown => 'Corona plateada';

  @override
  String get goldCrown => 'Corona dorada';

  @override
  String get elementsAndAilments => 'Elementos y Afecciones';

  @override
  String get monstersThatDropThisItem => 'Monstruos que sueltan este objeto:';

  @override
  String get dropConditions => 'Condiciones de Obtención:';

  @override
  String get craftingRecipe => 'Receta de Fabricación:';

  @override
  String get requiredMaterials => 'Materiales Requeridos:';

  @override
  String get skillRanks => 'Rangos de Habilidad:';

  @override
  String get rank => 'Rango';

  @override
  String get errorLoadingSkills => 'Error al cargar habilidades';

  @override
  String get noSkillsAvailable => 'No hay habilidades disponibles';

  @override
  String get craftingMaterials => 'Materiales de Fabricación';

  @override
  String get craft => 'Fabricar';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get defenseBonus => 'Bonificación de Defensa';

  @override
  String get elderseal => 'Sello Ancestral';

  @override
  String get lv => 'Nv';

  @override
  String get sharpnessRed => 'Rojo';

  @override
  String get sharpnessOrange => 'Naranja';

  @override
  String get sharpnessYellow => 'Amarillo';

  @override
  String get sharpnessGreen => 'Verde';

  @override
  String get sharpnessBlue => 'Azul';

  @override
  String get sharpnessWhite => 'Blanco';

  @override
  String get sharpnessPurple => 'Morado';

  @override
  String get setBonus => 'Bonificación de Set:';

  @override
  String get locationsLabel => 'Ubicaciones:';

  @override
  String get breakableParts => 'Partes Rompibles';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownMap => 'Mapa Desconocido';

  @override
  String get map => 'Mapa';

  @override
  String get rateAppTitle => '¿Te gusta la app?';

  @override
  String get rateAppMessage =>
      '¿Estás disfrutando de MHWilds Assistant? Tu valoración nos ayuda mucho a seguir mejorando.';

  @override
  String get rateAppYes => '¡Sí, me encanta!';

  @override
  String get rateAppNo => 'Ahora no / No';

  @override
  String get rateAppAction => 'Valorar aplicación';

  @override
  String get speciesFangedWyvern => 'Wyvern de colmillos';

  @override
  String get speciesFlyingWyvern => 'Wyvern volador';

  @override
  String get speciesBruteWyvern => 'Wyvern bruto';

  @override
  String get speciesBirdWyvern => 'Wyvern pájaro';

  @override
  String get speciesPiscineWyvern => 'Wyvern piscino';

  @override
  String get speciesFangedBeast => 'Bestia de colmillos';

  @override
  String get speciesElderDragon => 'Dragón anciano';

  @override
  String get speciesRelicat => 'Relicat';

  @override
  String get speciesNeopteron => 'Neopterón';

  @override
  String get speciesTemnoceran => 'Temnocerán';

  @override
  String get speciesLeviathan => 'Leviatán';

  @override
  String get speciesAmphibian => 'Anfibio';

  @override
  String get speciesSnakeWyvern => 'Wyvern serpiente';

  @override
  String get monsterKindLarge => 'Monstruo grande';

  @override
  String get monsterKindSmall => 'Monstruo pequeño';

  @override
  String get camps => 'Campamentos';

  @override
  String get openOptimizer => 'Abrir optimizador';

  @override
  String get ok => 'OK';

  @override
  String get webViewNotSupported => 'WebView no disponible en esta plataforma.';

  @override
  String get openInBrowserHint =>
      'Puedes abrir el optimizador en tu navegador.';

  @override
  String get listView => 'Lista';

  @override
  String get treeView => 'Árbol';

  @override
  String get treeSeries => 'Series del árbol';

  @override
  String get enterSeriesName => 'Introducir nombre de la serie...';

  @override
  String get noSeries => 'Sin serie';

  @override
  String get treeViewTooltip => 'Vista de árbol';

  @override
  String get tableViewTooltip => 'Vista de tabla';

  @override
  String get errorLoadingWeaponDetails =>
      'Error al cargar los detalles del arma';

  @override
  String get masterRank => 'Rango Maestro';

  @override
  String get retry => 'Reintentar';

  @override
  String get errorOffline =>
      'Sin conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get errorLoadingData =>
      'No se pudieron cargar los datos. Inténtalo de nuevo.';

  @override
  String offlineDataFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sin conexión · datos del $dateString';
  }

  @override
  String get creditsTooltip => 'Créditos';

  @override
  String get elementFire => 'Fuego';

  @override
  String get elementWater => 'Agua';

  @override
  String get elementIce => 'Hielo';

  @override
  String get elementThunder => 'Rayo';

  @override
  String get elementDragon => 'Dragón';

  @override
  String get elementParalysis => 'Parálisis';

  @override
  String get elementPoison => 'Veneno';

  @override
  String get elementSleep => 'Sueño';

  @override
  String get elementBlastblight => 'Explosión';

  @override
  String get elementBlast => 'Explosivo';

  @override
  String get elementFireblight => 'Plaga de fuego';

  @override
  String get elementWaterblight => 'Plaga de agua';

  @override
  String get elementIceblight => 'Plaga de hielo';

  @override
  String get elementThunderblight => 'Plaga de rayo';

  @override
  String get elementDragonblight => 'Plaga de dragón';

  @override
  String get elementFrostblight => 'Congelación';

  @override
  String get elementWebbed => 'Enredado';

  @override
  String get elementBleeding => 'Hemorragia';

  @override
  String get elementFrenzy => 'Frenesí';

  @override
  String get ailmentDescThunderblight =>
      'La plaga de rayo la causa el elemento Rayo y aumenta la probabilidad de que los ataques de los monstruos aturdan al cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescWaterblight =>
      'La plaga de agua la causa el elemento Agua y reduce la recuperación de aguante del cazador.\nSe cura consumiendo una Nulberry o usando un Cleanser Booster.';

  @override
  String get ailmentDescFireblight =>
      'La plaga de fuego la causa el elemento Fuego y hace que el cazador pierda salud con el tiempo.\nSe cura consumiendo una Nulberry. Si hay agua cerca, se puede saltar a ella o rodar 3 veces por el suelo.';

  @override
  String get ailmentDescIceblight =>
      'La plaga de hielo la causa el elemento Hielo y aumenta el consumo de aguante al correr, atacar o esquivar.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescDragonblight =>
      'La plaga de dragón la causa el elemento Dragón y anula los efectos de daño y la acumulación de estados de este elemento.\nSe cura consumiendo una Nulberry.';

  @override
  String get ailmentDescBlast =>
      'Explosivo es un estado que marca a un monstruo y permite dañarlo con pequeñas explosiones.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBlastblight =>
      'La explosión hace que el objetivo estalle pasado un tiempo o al recibir un ataque contundente.\nSe cura con una Nulberry o esquivando con una voltereta hasta tres veces.';

  @override
  String get ailmentDescBleeding =>
      'La hemorragia hace que el cazador pierda salud al moverse, atacar o esquivar.\nSe cura comiendo Astera Jerky, Well-Done Steak o Sushifish Scale, o agachándose unos segundos.';

  @override
  String get ailmentDescFrenzy =>
      'El frenesí hace que el cazador reciba temporalmente más daño cuando está totalmente infectado.\nSe cura usando una Nulberry.';

  @override
  String get ailmentDescFrostblight =>
      'La congelación impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser o con Resistencia a la inmovilización de nivel 3.';

  @override
  String get ailmentDescWebbed =>
      'Enredado impide temporalmente que el cazador se mueva o actúe.\nSe cura con un Cleanser, moviéndose, pulsando botones, recibiendo el golpe de un ataque o un impacto.';

  @override
  String get ailmentDescPoison =>
      'El veneno reduce poco a poco la salud del objetivo con el tiempo.\nSe cura con Antidote, Herbal Medicine o Herbal Powder.';

  @override
  String get ailmentDescSleep =>
      'El sueño hace que el objetivo se duerma y quede expuesto a un único ataque.\nEl objetivo se despierta al recibir daño.\nSe cura con un Energy Drink, de un aliado o de un monstruo.';

  @override
  String get ailmentDescParalysis =>
      'La parálisis inmoviliza al cazador o al monstruo y lo hace vulnerable a más daño mientras dura.\nSe cura con impactos que lancen con mucha fuerza hacia atrás, como un golpe ascendente de un Martillo o un Espadón.';

  @override
  String get announcements => 'Anuncios';

  @override
  String get announcementsNew => 'Anuncios (nuevo)';

  @override
  String get loadingAnnouncements => 'Cargando anuncios...';

  @override
  String get noAnnouncements => 'Aún no hay anuncios';

  @override
  String get openLink => 'Abrir enlace';
}
