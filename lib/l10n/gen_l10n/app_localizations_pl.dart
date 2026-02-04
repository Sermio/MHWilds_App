// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Asystent MHWilds';

  @override
  String get settings => 'Ustawienia';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get language => 'Język';

  @override
  String get systemDefault => 'Domyślny systemowy';

  @override
  String get locations => 'Lokalizacje';

  @override
  String get monsters => 'Potwory';

  @override
  String get weapons => 'Broń';

  @override
  String get armor => 'Zbroja';

  @override
  String get items => 'Przedmioty';

  @override
  String get decorations => 'Dekoracje';

  @override
  String get skills => 'Umiejętności';

  @override
  String get talismans => 'Talismany';

  @override
  String get reset => 'Resetuj';

  @override
  String get skillDetails => 'Szczegóły umiejętności';

  @override
  String get monsterNotFound => 'Nie znaleziono potwora';

  @override
  String errorWithMessage(String message) {
    return 'Błąd: $message';
  }

  @override
  String get close => 'Zamknij';

  @override
  String get goToStore => 'Przejdź do sklepu';

  @override
  String get newVersionAvailable => 'Dostępna nowa wersja';

  @override
  String get appearance => 'Wygląd';

  @override
  String get on => 'Wł.';

  @override
  String get offDefault => 'Wył. (domyślnie)';

  @override
  String get armorSets => 'Zestawy zbroi';

  @override
  String get menuMonstersSubtitle => 'Baza wszystkich potworów';

  @override
  String get menuItemsSubtitle => 'Materiały i zasoby';

  @override
  String get menuDecorationsSubtitle => 'Klejnoty i kamienie umiejętności';

  @override
  String get menuTalismansSubtitle => 'Potężne akcesoria';

  @override
  String get menuArmorSetsSubtitle => 'Pełne kolekcje zbroi';

  @override
  String get menuWeaponsSubtitle => 'Broń i narzędzia bojowe';

  @override
  String get menuSkillsSubtitle => 'Umiejętności i efekty bojowe';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Masz wersję $currentVersion. Nowa wersja ($newVersion) jest dostępna w sklepie. Zaktualizuj, aby uzyskać najnowsze ulepszenia i poprawki.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Masz wersję $currentVersion. Nowa wersja jest dostępna w sklepie. Zaktualizuj, aby uzyskać najnowsze ulepszenia i poprawki.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Nowa wersja ($newVersion) jest dostępna w sklepie. Zaktualizuj, aby uzyskać najnowsze ulepszenia i poprawki.';
  }

  @override
  String get updateMessageGeneric =>
      'Nowa wersja jest dostępna w sklepie. Zaktualizuj, aby uzyskać najnowsze ulepszenia i poprawki.';

  @override
  String get filters => 'Filtry';

  @override
  String get loadingSkills => 'Ładowanie umiejętności...';

  @override
  String get searchByName => 'Szukaj po nazwie';

  @override
  String get enterMonsterName => 'Wprowadź nazwę potwora...';

  @override
  String get searchBySpecies => 'Szukaj po gatunku';

  @override
  String get enterSpecies => 'Wprowadź gatunek...';

  @override
  String get loadingMonsters => 'Ładowanie potworów...';

  @override
  String get noMonstersFound => 'Nie znaleziono potworów';

  @override
  String get tryAdjustingFilters => 'Spróbuj dostosować filtry';

  @override
  String get type => 'Typ';

  @override
  String get rarity => 'Rzadkość';

  @override
  String rarityLevel(int n) {
    return 'Rzadkość $n';
  }

  @override
  String get enterWeaponName => 'Wprowadź nazwę broni...';

  @override
  String get enterItemName => 'Wprowadź nazwę przedmiotu...';

  @override
  String get enterArmorSetName => 'Wprowadź nazwę zestawu zbroi...';

  @override
  String get enterTalismanName => 'Wprowadź nazwę talizmanu...';

  @override
  String get enterSkillName => 'Wprowadź nazwę umiejętności...';

  @override
  String get enterDecorationName => 'Wprowadź nazwę dekoracji...';

  @override
  String get loadingWeapons => 'Ładowanie broni...';

  @override
  String get loadingItems => 'Ładowanie przedmiotów...';

  @override
  String get loadingArmorSets => 'Ładowanie zestawów zbroi...';

  @override
  String get loadingTalismans => 'Ładowanie talizmanów...';

  @override
  String get loadingDecorations => 'Ładowanie dekoracji...';

  @override
  String get noWeaponsFound => 'Nie znaleziono broni';

  @override
  String get noItemsFound => 'Nie znaleziono przedmiotów';

  @override
  String get noArmorSetsFound => 'Nie znaleziono zestawów zbroi';

  @override
  String get noTalismansFound => 'Nie znaleziono talizmanów';

  @override
  String get noSkillsFound => 'Nie znaleziono umiejętności';

  @override
  String get noDecorationsFound => 'Nie znaleziono dekoracji';

  @override
  String get armorSlotHead => 'Głowa';

  @override
  String get armorSlotChest => 'Klatka';

  @override
  String get armorSlotArms => 'Ręce';

  @override
  String get armorSlotWaist => 'Pas';

  @override
  String get armorSlotLegs => 'Nogi';

  @override
  String get typeWeapon => 'Broń';

  @override
  String get typeArmor => 'Zbroja';

  @override
  String get typeGroup => 'Grupa';

  @override
  String get typeSet => 'Set';

  @override
  String get weaponKindGreatSword => 'Miecz dwuręczny';

  @override
  String get weaponKindLongSword => 'Miecz długi';

  @override
  String get weaponKindSwordShield => 'Miecz i tarcza';

  @override
  String get weaponKindDualBlades => 'Bliźniacze ostrza';

  @override
  String get weaponKindHammer => 'Młot';

  @override
  String get weaponKindHuntingHorn => 'Róg łowiecki';

  @override
  String get weaponKindLance => 'Lanca';

  @override
  String get weaponKindGunlance => 'Lancopał';

  @override
  String get weaponKindSwitchAxe => 'Topór sprężynowy';

  @override
  String get weaponKindChargeBlade => 'Ładowane ostrze';

  @override
  String get weaponKindInsectGlaive => 'Owadzia glewia';

  @override
  String get weaponKindBow => 'Łuk';

  @override
  String get weaponKindLightBowgun => 'Lekkie łukodziałko';

  @override
  String get weaponKindHeavyBowgun => 'Ciężkie łukodziałko';

  @override
  String get pieces => 'części';

  @override
  String get defense => 'Obrona';

  @override
  String get baseDefense => 'Obrona bazowa';

  @override
  String get slots => 'Gniazda';

  @override
  String get resistances => 'Odporności';

  @override
  String get noSlots => 'Brak gniazd';

  @override
  String get noResistances => 'Brak odporności';

  @override
  String get physicalDamage => 'Obrażenia fizyczne';

  @override
  String get affinity => 'Powinowactwo';

  @override
  String get sharpness => 'Ostrość';

  @override
  String get element => 'Element';

  @override
  String get statusEffect => 'Efekt statusu';

  @override
  String get phial => 'Fiolka';

  @override
  String get coatings => 'Powłoki';

  @override
  String get shell => 'Pocisk';

  @override
  String get melody => 'Melodia';

  @override
  String get songs => 'piosenki';

  @override
  String get echoBubble => 'Bańka echa';

  @override
  String get echoWave => 'Fala echa';

  @override
  String get ammo => 'Amunicja';

  @override
  String get kinsect => 'Owad';

  @override
  String get level => 'Poziom';

  @override
  String campsOfLevel(int n) {
    return 'Obozy Poziomu $n';
  }

  @override
  String get risk => 'Ryzyko';

  @override
  String get zone => 'Strefa';

  @override
  String get loadingMap => 'Ładowanie mapy...';

  @override
  String get noMapImagesFound => 'Nie znaleziono obrazów mapy';

  @override
  String get monsterInformation => 'Informacje o Potworze';

  @override
  String get species => 'Gatunek';

  @override
  String get description => 'Opis';

  @override
  String get features => 'Cechy';

  @override
  String get huntingTips => 'Wskazówki Łowieckie';

  @override
  String get monsterVariants => 'Warianty Potwora';

  @override
  String get statistics => 'Statystyki';

  @override
  String get baseHealth => 'Podstawowe Zdrowie';

  @override
  String get sizeRange => 'Zakres Rozmiaru';

  @override
  String get elements => 'Żywioły';

  @override
  String get weaknessesAndResistances => 'Słabości i Odporności';

  @override
  String get weaknesses => 'Słabości';

  @override
  String get noKnownResistances => 'Brak znanych odporności';

  @override
  String get highRank => 'Wysoka Ranga';

  @override
  String get lowRank => 'Niska Ranga';

  @override
  String get crownSizes => 'Rozmiary Koron';

  @override
  String get baseSize => 'Rozmiar podstawowy';

  @override
  String get miniCrown => 'Mini korona';

  @override
  String get silverCrown => 'Srebrna korona';

  @override
  String get goldCrown => 'Złota korona';

  @override
  String get elementsAndAilments => 'Żywioły i Dolegliwości';

  @override
  String get monstersThatDropThisItem =>
      'Potwory, które upuszczają ten przedmiot:';

  @override
  String get dropConditions => 'Warunki upuszczenia:';

  @override
  String get craftingRecipe => 'Przepis na Wytworzenie:';

  @override
  String get requiredMaterials => 'Wymagane Materiały:';

  @override
  String get skillRanks => 'Rangi Umiejętności:';

  @override
  String get rank => 'Ranga';

  @override
  String get errorLoadingSkills => 'Błąd podczas ładowania umiejętności';

  @override
  String get noSkillsAvailable => 'Brak dostępnych umiejętności';

  @override
  String get craftingMaterials => 'Materiały do Wytworzenia';

  @override
  String get craft => 'Wytwórz';

  @override
  String get upgrade => 'Ulepsz';

  @override
  String get defenseBonus => 'Bonus Obrony';

  @override
  String get elderseal => 'Pieczęć Starszych';

  @override
  String get lv => 'Poziom';

  @override
  String get sharpnessRed => 'Czerwony';

  @override
  String get sharpnessOrange => 'Pomarańczowy';

  @override
  String get sharpnessYellow => 'Żółty';

  @override
  String get sharpnessGreen => 'Zielony';

  @override
  String get sharpnessBlue => 'Niebieski';

  @override
  String get sharpnessWhite => 'Biały';

  @override
  String get sharpnessPurple => 'Fioletowy';

  @override
  String get setBonus => 'Bonus Zestawu:';

  @override
  String get locationsLabel => 'Lokalizacje:';

  @override
  String get breakableParts => 'Łamiące Się Części';

  @override
  String get unknown => 'Nieznane';

  @override
  String get unknownMap => 'Nieznana Mapa';

  @override
  String get map => 'Mapa';
}
