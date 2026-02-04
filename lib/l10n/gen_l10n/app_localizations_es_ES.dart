// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizations {
  AppLocalizationsEsEs([String locale = 'es_ES']) : super(locale);

  @override
  String get appTitle => 'Asistente MHWilds';

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
  String rarityLevel(int n) => 'Rareza $n';

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
  String get typeSet => 'Set';

  @override
  String get weaponKindGreatSword => 'Gran espada';

  @override
  String get weaponKindLongSword => 'Espada Larga';

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
  String campsOfLevel(int n) => 'Campamentos de Nivel $n';

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
}
