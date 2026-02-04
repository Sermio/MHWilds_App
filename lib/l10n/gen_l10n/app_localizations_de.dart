// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'MHWilds Assistent';

  @override
  String get settings => 'Einstellungen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get language => 'Sprache';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get locations => 'Orte';

  @override
  String get monsters => 'Monster';

  @override
  String get weapons => 'Waffen';

  @override
  String get armor => 'Rüstung';

  @override
  String get items => 'Gegenstände';

  @override
  String get decorations => 'Dekorationen';

  @override
  String get skills => 'Fertigkeiten';

  @override
  String get talismans => 'Talismane';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get skillDetails => 'Fähigkeitsdetails';

  @override
  String get monsterNotFound => 'Monster nicht gefunden';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get close => 'Schließen';

  @override
  String get goToStore => 'Zum Store';

  @override
  String get newVersionAvailable => 'Neue Version verfügbar';

  @override
  String get appearance => 'Darstellung';

  @override
  String get on => 'An';

  @override
  String get offDefault => 'Aus (Standard)';

  @override
  String get armorSets => 'Rüstungssets';

  @override
  String get menuMonstersSubtitle => 'Datenbank aller Monster';

  @override
  String get menuItemsSubtitle => 'Materialien und Ressourcen';

  @override
  String get menuDecorationsSubtitle => 'Fähigkeits-Edelsteine und Juwelen';

  @override
  String get menuTalismansSubtitle => 'Mächtige Accessoires';

  @override
  String get menuArmorSetsSubtitle => 'Vollständige Rüstungssammlungen';

  @override
  String get menuWeaponsSubtitle => 'Kampfwaffen und -werkzeuge';

  @override
  String get menuSkillsSubtitle => 'Kampffähigkeiten und -effekte';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Sie haben Version $currentVersion. Eine neue Version ($newVersion) ist im Store verfügbar. Aktualisieren Sie für die neuesten Verbesserungen und Korrekturen.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Sie haben Version $currentVersion. Eine neue Version ist im Store verfügbar. Aktualisieren Sie für die neuesten Verbesserungen und Korrekturen.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Eine neue Version ($newVersion) ist im Store verfügbar. Aktualisieren Sie für die neuesten Verbesserungen und Korrekturen.';
  }

  @override
  String get updateMessageGeneric =>
      'Eine neue Version ist im Store verfügbar. Aktualisieren Sie für die neuesten Verbesserungen und Korrekturen.';

  @override
  String get filters => 'Filter';

  @override
  String get loadingSkills => 'Fertigkeiten werden geladen...';

  @override
  String get searchByName => 'Nach Name suchen';

  @override
  String get enterMonsterName => 'Monstername eingeben...';

  @override
  String get searchBySpecies => 'Nach Art suchen';

  @override
  String get enterSpecies => 'Art eingeben...';

  @override
  String get loadingMonsters => 'Monster werden geladen...';

  @override
  String get noMonstersFound => 'Keine Monster gefunden';

  @override
  String get tryAdjustingFilters => 'Filter anpassen';

  @override
  String get type => 'Typ';

  @override
  String get rarity => 'Seltenheit';

  @override
  String rarityLevel(int n) {
    return 'Seltenheit $n';
  }

  @override
  String get enterWeaponName => 'Waffenname eingeben...';

  @override
  String get enterItemName => 'Gegenstandsname eingeben...';

  @override
  String get enterArmorSetName => 'Rüstungsset-Name eingeben...';

  @override
  String get enterTalismanName => 'Talisman-Name eingeben...';

  @override
  String get enterSkillName => 'Fähigkeitsname eingeben...';

  @override
  String get enterDecorationName => 'Dekorationsname eingeben...';

  @override
  String get loadingWeapons => 'Waffen werden geladen...';

  @override
  String get loadingItems => 'Gegenstände werden geladen...';

  @override
  String get loadingArmorSets => 'Rüstungssets werden geladen...';

  @override
  String get loadingTalismans => 'Talismane werden geladen...';

  @override
  String get loadingDecorations => 'Dekorationen werden geladen...';

  @override
  String get noWeaponsFound => 'Keine Waffen gefunden';

  @override
  String get noItemsFound => 'Keine Gegenstände gefunden';

  @override
  String get noArmorSetsFound => 'Keine Rüstungssets gefunden';

  @override
  String get noTalismansFound => 'Keine Talismane gefunden';

  @override
  String get noSkillsFound => 'Keine Fertigkeiten gefunden';

  @override
  String get noDecorationsFound => 'Keine Dekorationen gefunden';

  @override
  String get armorSlotHead => 'Kopf';

  @override
  String get armorSlotChest => 'Brust';

  @override
  String get armorSlotArms => 'Arme';

  @override
  String get armorSlotWaist => 'Taille';

  @override
  String get armorSlotLegs => 'Beine';

  @override
  String get typeWeapon => 'Waffe';

  @override
  String get typeArmor => 'Rüstung';

  @override
  String get typeGroup => 'Gruppe';

  @override
  String get typeSet => 'Set';

  @override
  String get weaponKindGreatSword => 'Großschwert';

  @override
  String get weaponKindLongSword => 'Langschwert';

  @override
  String get weaponKindSwordShield => 'Schwert & Schild';

  @override
  String get weaponKindDualBlades => 'Doppelklingen';

  @override
  String get weaponKindHammer => 'Hammer';

  @override
  String get weaponKindHuntingHorn => 'Jagdhorn';

  @override
  String get weaponKindLance => 'Lanze';

  @override
  String get weaponKindGunlance => 'Gewehrlanze';

  @override
  String get weaponKindSwitchAxe => 'Morph-Axt';

  @override
  String get weaponKindChargeBlade => 'Energieklinge';

  @override
  String get weaponKindInsectGlaive => 'Insektenglefe';

  @override
  String get weaponKindBow => 'Bogen';

  @override
  String get weaponKindLightBowgun => 'Leichtes Bogengewehr';

  @override
  String get weaponKindHeavyBowgun => 'Schweres Bogengewehr';

  @override
  String get pieces => 'Teile';

  @override
  String get defense => 'Verteidigung';

  @override
  String get baseDefense => 'Grundverteidigung';

  @override
  String get slots => 'Steckplätze';

  @override
  String get resistances => 'Resistenzen';

  @override
  String get noSlots => 'Keine Steckplätze';

  @override
  String get noResistances => 'Keine Resistenzen';

  @override
  String get physicalDamage => 'Physischer Schaden';

  @override
  String get affinity => 'Affinität';

  @override
  String get sharpness => 'Schärfe';

  @override
  String get element => 'Element';

  @override
  String get statusEffect => 'Status-Effekt';

  @override
  String get phial => 'Phiole';

  @override
  String get coatings => 'Beschichtungen';

  @override
  String get shell => 'Hülse';

  @override
  String get melody => 'Melodie';

  @override
  String get songs => 'Lieder';

  @override
  String get echoBubble => 'Echo-Blase';

  @override
  String get echoWave => 'Echo-Welle';

  @override
  String get ammo => 'Munition';

  @override
  String get kinsect => 'Insekt';

  @override
  String get level => 'Stufe';

  @override
  String campsOfLevel(int n) {
    return 'Lager der Stufe $n';
  }

  @override
  String get risk => 'Risiko';

  @override
  String get zone => 'Zone';

  @override
  String get loadingMap => 'Karte wird geladen...';

  @override
  String get noMapImagesFound => 'Keine Kartenbilder gefunden';

  @override
  String get monsterInformation => 'Monster-Informationen';

  @override
  String get species => 'Art';

  @override
  String get description => 'Beschreibung';

  @override
  String get features => 'Eigenschaften';

  @override
  String get huntingTips => 'Jagdtipps';

  @override
  String get monsterVariants => 'Monster-Varianten';

  @override
  String get statistics => 'Statistiken';

  @override
  String get baseHealth => 'Basis-Gesundheit';

  @override
  String get sizeRange => 'Größenbereich';

  @override
  String get elements => 'Elemente';

  @override
  String get weaknessesAndResistances => 'Schwächen und Widerstände';

  @override
  String get weaknesses => 'Schwächen';

  @override
  String get noKnownResistances => 'Keine bekannten Widerstände';

  @override
  String get highRank => 'Hoher Rang';

  @override
  String get lowRank => 'Niedriger Rang';

  @override
  String get crownSizes => 'Kronengrößen';

  @override
  String get baseSize => 'Basisgröße';

  @override
  String get miniCrown => 'Mini-Krone';

  @override
  String get silverCrown => 'Silberne Krone';

  @override
  String get goldCrown => 'Goldene Krone';

  @override
  String get elementsAndAilments => 'Elemente und Leiden';

  @override
  String get monstersThatDropThisItem =>
      'Monster, die diesen Gegenstand fallen lassen:';

  @override
  String get dropConditions => 'Bedingungen:';

  @override
  String get craftingRecipe => 'Herstellungsrezept:';

  @override
  String get requiredMaterials => 'Benötigte Materialien:';

  @override
  String get skillRanks => 'Fähigkeitsränge:';

  @override
  String get rank => 'Rang';

  @override
  String get errorLoadingSkills => 'Fehler beim Laden der Fähigkeiten';

  @override
  String get noSkillsAvailable => 'Keine Fähigkeiten verfügbar';

  @override
  String get craftingMaterials => 'Herstellungsmaterialien';

  @override
  String get craft => 'Herstellen';

  @override
  String get upgrade => 'Verbessern';

  @override
  String get defenseBonus => 'Verteidigungsbonus';

  @override
  String get elderseal => 'Ältestensiegel';

  @override
  String get lv => 'St.';

  @override
  String get sharpnessRed => 'Rot';

  @override
  String get sharpnessOrange => 'Orange';

  @override
  String get sharpnessYellow => 'Gelb';

  @override
  String get sharpnessGreen => 'Grün';

  @override
  String get sharpnessBlue => 'Blau';

  @override
  String get sharpnessWhite => 'Weiß';

  @override
  String get sharpnessPurple => 'Lila';

  @override
  String get setBonus => 'Set-Bonus:';

  @override
  String get locationsLabel => 'Standorte:';

  @override
  String get breakableParts => 'Zerbrechbare Teile';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get unknownMap => 'Unbekannte Karte';

  @override
  String get map => 'Karte';
}
