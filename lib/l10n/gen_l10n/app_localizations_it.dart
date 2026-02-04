// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Assistente MHWilds';

  @override
  String get settings => 'Impostazioni';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

  @override
  String get locations => 'Luoghi';

  @override
  String get monsters => 'Mostri';

  @override
  String get weapons => 'Armi';

  @override
  String get armor => 'Armatura';

  @override
  String get items => 'Oggetti';

  @override
  String get decorations => 'Decorazioni';

  @override
  String get skills => 'Abilità';

  @override
  String get talismans => 'Talismani';

  @override
  String get reset => 'Reimposta';

  @override
  String get skillDetails => 'Dettagli abilità';

  @override
  String get monsterNotFound => 'Mostro non trovato';

  @override
  String errorWithMessage(String message) {
    return 'Errore: $message';
  }

  @override
  String get close => 'Chiudi';

  @override
  String get goToStore => 'Vai allo store';

  @override
  String get newVersionAvailable => 'Nuova versione disponibile';

  @override
  String get appearance => 'Aspetto';

  @override
  String get on => 'Attivo';

  @override
  String get offDefault => 'Disattivato (predefinito)';

  @override
  String get armorSets => 'Set di armatura';

  @override
  String get menuMonstersSubtitle => 'Database di tutti i mostri';

  @override
  String get menuItemsSubtitle => 'Materiali e risorse';

  @override
  String get menuDecorationsSubtitle => 'Gemme e gioielli abilità';

  @override
  String get menuTalismansSubtitle => 'Accessori potenti';

  @override
  String get menuArmorSetsSubtitle => 'Collezioni di armature complete';

  @override
  String get menuWeaponsSubtitle => 'Armi e strumenti da combattimento';

  @override
  String get menuSkillsSubtitle => 'Abilità ed effetti di combattimento';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Hai la versione $currentVersion. Una nuova versione ($newVersion) è disponibile nello store. Aggiorna per le ultime migliorie e correzioni.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Hai la versione $currentVersion. Una nuova versione è disponibile nello store. Aggiorna per le ultime migliorie e correzioni.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Una nuova versione ($newVersion) è disponibile nello store. Aggiorna per le ultime migliorie e correzioni.';
  }

  @override
  String get updateMessageGeneric =>
      'Una nuova versione è disponibile nello store. Aggiorna per le ultime migliorie e correzioni.';

  @override
  String get filters => 'Filtri';

  @override
  String get loadingSkills => 'Caricamento abilità...';

  @override
  String get searchByName => 'Cerca per nome';

  @override
  String get enterMonsterName => 'Inserisci il nome del mostro...';

  @override
  String get searchBySpecies => 'Cerca per specie';

  @override
  String get enterSpecies => 'Inserisci la specie...';

  @override
  String get loadingMonsters => 'Caricamento mostri...';

  @override
  String get noMonstersFound => 'Nessun mostro trovato';

  @override
  String get tryAdjustingFilters => 'Prova a modificare i filtri';

  @override
  String get type => 'Tipo';

  @override
  String get rarity => 'Rarità';

  @override
  String rarityLevel(int n) {
    return 'Rarità $n';
  }

  @override
  String get enterWeaponName => 'Inserisci il nome dell\'arma...';

  @override
  String get enterItemName => 'Inserisci il nome dell\'oggetto...';

  @override
  String get enterArmorSetName => 'Inserisci il nome del set armatura...';

  @override
  String get enterTalismanName => 'Inserisci il nome del talismano...';

  @override
  String get enterSkillName => 'Inserisci il nome dell\'abilità...';

  @override
  String get enterDecorationName => 'Inserisci il nome della decorazione...';

  @override
  String get loadingWeapons => 'Caricamento armi...';

  @override
  String get loadingItems => 'Caricamento oggetti...';

  @override
  String get loadingArmorSets => 'Caricamento set armatura...';

  @override
  String get loadingTalismans => 'Caricamento talismani...';

  @override
  String get loadingDecorations => 'Caricamento decorazioni...';

  @override
  String get noWeaponsFound => 'Nessuna arma trovata';

  @override
  String get noItemsFound => 'Nessun oggetto trovato';

  @override
  String get noArmorSetsFound => 'Nessun set armatura trovato';

  @override
  String get noTalismansFound => 'Nessun talismano trovato';

  @override
  String get noSkillsFound => 'Nessuna abilità trovata';

  @override
  String get noDecorationsFound => 'Nessuna decorazione trovata';

  @override
  String get armorSlotHead => 'Head';

  @override
  String get armorSlotChest => 'Chest';

  @override
  String get armorSlotArms => 'Arms';

  @override
  String get armorSlotWaist => 'Waist';

  @override
  String get armorSlotLegs => 'Legs';

  @override
  String get typeWeapon => 'Weapon';

  @override
  String get typeArmor => 'Armor';

  @override
  String get typeGroup => 'Group';

  @override
  String get typeSet => 'Set';

  @override
  String get weaponKindGreatSword => 'Spadone';

  @override
  String get weaponKindLongSword => 'Spada lunga';

  @override
  String get weaponKindSwordShield => 'Spada e scudo';

  @override
  String get weaponKindDualBlades => 'Doppie lame';

  @override
  String get weaponKindHammer => 'Martello';

  @override
  String get weaponKindHuntingHorn => 'Corno da caccia';

  @override
  String get weaponKindLance => 'Lancia';

  @override
  String get weaponKindGunlance => 'Lancia-fucile';

  @override
  String get weaponKindSwitchAxe => 'Spadascia';

  @override
  String get weaponKindChargeBlade => 'Lama caricata';

  @override
  String get weaponKindInsectGlaive => 'Falcione insetto';

  @override
  String get weaponKindBow => 'Arco';

  @override
  String get weaponKindLightBowgun => 'Balestra leggera';

  @override
  String get weaponKindHeavyBowgun => 'Balestra pesante';

  @override
  String get pieces => 'pezzi';

  @override
  String get defense => 'Difesa';

  @override
  String get baseDefense => 'Difesa base';

  @override
  String get slots => 'Slot';

  @override
  String get resistances => 'Resistenze';

  @override
  String get noSlots => 'Nessuno slot';

  @override
  String get noResistances => 'Nessuna resistenza';

  @override
  String get physicalDamage => 'Danno fisico';

  @override
  String get affinity => 'Affinità';

  @override
  String get sharpness => 'Nitidezza';

  @override
  String get element => 'Elemento';

  @override
  String get statusEffect => 'Effetto di stato';

  @override
  String get phial => 'Fiala';

  @override
  String get coatings => 'Rivestimenti';

  @override
  String get shell => 'Guscio';

  @override
  String get melody => 'Melodia';

  @override
  String get songs => 'canzoni';

  @override
  String get echoBubble => 'Bolla d\'eco';

  @override
  String get echoWave => 'Onda d\'eco';

  @override
  String get ammo => 'Munizioni';

  @override
  String get kinsect => 'Insetto';

  @override
  String get level => 'Livello';

  @override
  String campsOfLevel(int n) {
    return 'Accampamenti di Livello $n';
  }

  @override
  String get risk => 'Rischio';

  @override
  String get zone => 'Zona';

  @override
  String get loadingMap => 'Caricamento mappa...';

  @override
  String get noMapImagesFound => 'Nessuna immagine della mappa trovata';

  @override
  String get monsterInformation => 'Informazioni sul Mostro';

  @override
  String get species => 'Specie';

  @override
  String get description => 'Descrizione';

  @override
  String get features => 'Caratteristiche';

  @override
  String get huntingTips => 'Consigli di Caccia';

  @override
  String get monsterVariants => 'Varianti del Mostro';

  @override
  String get statistics => 'Statistiche';

  @override
  String get baseHealth => 'Salute Base';

  @override
  String get sizeRange => 'Intervallo di Dimensione';

  @override
  String get elements => 'Elementi';

  @override
  String get weaknessesAndResistances => 'Debolezze e Resistenze';

  @override
  String get weaknesses => 'Debolezze';

  @override
  String get noKnownResistances => 'Nessuna resistenza nota';

  @override
  String get highRank => 'Rango Alto';

  @override
  String get lowRank => 'Rango Basso';

  @override
  String get crownSizes => 'Dimensioni della Corona';

  @override
  String get baseSize => 'Dimensione base';

  @override
  String get miniCrown => 'Corona mini';

  @override
  String get silverCrown => 'Corona d\'argento';

  @override
  String get goldCrown => 'Corona d\'oro';

  @override
  String get elementsAndAilments => 'Elementi e Afflizioni';

  @override
  String get monstersThatDropThisItem =>
      'Mostri che lasciano cadere questo oggetto:';

  @override
  String get dropConditions => 'Condizioni di caduta:';

  @override
  String get craftingRecipe => 'Ricetta di Creazione:';

  @override
  String get requiredMaterials => 'Materiali Richiesti:';

  @override
  String get skillRanks => 'Ranghi di Abilità:';

  @override
  String get rank => 'Rango';

  @override
  String get errorLoadingSkills => 'Errore nel caricamento delle abilità';

  @override
  String get noSkillsAvailable => 'Nessuna abilità disponibile';

  @override
  String get craftingMaterials => 'Materiali di Creazione';

  @override
  String get craft => 'Crea';

  @override
  String get upgrade => 'Migliora';

  @override
  String get defenseBonus => 'Bonus Difesa';

  @override
  String get elderseal => 'Sigillo Antico';

  @override
  String get lv => 'Liv';

  @override
  String get sharpnessRed => 'Rosso';

  @override
  String get sharpnessOrange => 'Arancione';

  @override
  String get sharpnessYellow => 'Giallo';

  @override
  String get sharpnessGreen => 'Verde';

  @override
  String get sharpnessBlue => 'Blu';

  @override
  String get sharpnessWhite => 'Bianco';

  @override
  String get sharpnessPurple => 'Viola';

  @override
  String get setBonus => 'Bonus Set:';

  @override
  String get locationsLabel => 'Posizioni:';

  @override
  String get breakableParts => 'Parti Rompibili';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get unknownMap => 'Mappa Sconosciuta';

  @override
  String get map => 'Mappa';
}
