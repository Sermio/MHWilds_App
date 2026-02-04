// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MHWilds Assistant';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get locations => 'Locations';

  @override
  String get monsters => 'Monsters';

  @override
  String get weapons => 'Weapons';

  @override
  String get armor => 'Armor';

  @override
  String get items => 'Items';

  @override
  String get decorations => 'Decorations';

  @override
  String get skills => 'Skills';

  @override
  String get talismans => 'Talismans';

  @override
  String get reset => 'Reset';

  @override
  String get skillDetails => 'Skill Details';

  @override
  String get monsterNotFound => 'Monster not found';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get close => 'Close';

  @override
  String get goToStore => 'Go to store';

  @override
  String get newVersionAvailable => 'New version available';

  @override
  String get appearance => 'Appearance';

  @override
  String get on => 'On';

  @override
  String get offDefault => 'Off (default)';

  @override
  String get armorSets => 'Armor Sets';

  @override
  String get menuMonstersSubtitle => 'Database of all monsters';

  @override
  String get menuItemsSubtitle => 'Materials and resources';

  @override
  String get menuDecorationsSubtitle => 'Skill gems and jewels';

  @override
  String get menuTalismansSubtitle => 'Powerful accessories';

  @override
  String get menuArmorSetsSubtitle => 'Complete armor collections';

  @override
  String get menuWeaponsSubtitle => 'Combat weapons and tools';

  @override
  String get menuSkillsSubtitle => 'Combat abilities and effects';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'You have version $currentVersion. A new version ($newVersion) is available in the store. Update to get the latest improvements and fixes.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'You have version $currentVersion. A new version is available in the store. Update to get the latest improvements and fixes.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'A new version ($newVersion) is available in the store. Update to get the latest improvements and fixes.';
  }

  @override
  String get updateMessageGeneric =>
      'A new version is available in the store. Update to get the latest improvements and fixes.';

  @override
  String get filters => 'Filters';

  @override
  String get loadingSkills => 'Loading skills...';

  @override
  String get searchByName => 'Search by Name';

  @override
  String get enterMonsterName => 'Enter monster name...';

  @override
  String get searchBySpecies => 'Search by Species';

  @override
  String get enterSpecies => 'Enter species...';

  @override
  String get loadingMonsters => 'Loading monsters...';

  @override
  String get noMonstersFound => 'No monsters found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get type => 'Type';

  @override
  String get rarity => 'Rarity';

  @override
  String rarityLevel(int n) {
    return 'Rarity $n';
  }

  @override
  String get enterWeaponName => 'Enter weapon name...';

  @override
  String get enterItemName => 'Enter item name...';

  @override
  String get enterArmorSetName => 'Enter armor set name...';

  @override
  String get enterTalismanName => 'Enter talisman name...';

  @override
  String get enterSkillName => 'Enter skill name...';

  @override
  String get enterDecorationName => 'Enter decoration name...';

  @override
  String get loadingWeapons => 'Loading weapons...';

  @override
  String get loadingItems => 'Loading items...';

  @override
  String get loadingArmorSets => 'Loading armor sets...';

  @override
  String get loadingTalismans => 'Loading talismans...';

  @override
  String get loadingDecorations => 'Loading decorations...';

  @override
  String get noWeaponsFound => 'No weapons found';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get noArmorSetsFound => 'No armor sets found';

  @override
  String get noTalismansFound => 'No talismans found';

  @override
  String get noSkillsFound => 'No skills found';

  @override
  String get noDecorationsFound => 'No decorations found';

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
  String get weaponKindGreatSword => 'Great Sword';

  @override
  String get weaponKindLongSword => 'Long Sword';

  @override
  String get weaponKindSwordShield => 'Sword & Shield';

  @override
  String get weaponKindDualBlades => 'Dual Blades';

  @override
  String get weaponKindHammer => 'Hammer';

  @override
  String get weaponKindHuntingHorn => 'Hunting Horn';

  @override
  String get weaponKindLance => 'Lance';

  @override
  String get weaponKindGunlance => 'Gunlance';

  @override
  String get weaponKindSwitchAxe => 'Switch Axe';

  @override
  String get weaponKindChargeBlade => 'Charge Blade';

  @override
  String get weaponKindInsectGlaive => 'Insect Glaive';

  @override
  String get weaponKindBow => 'Bow';

  @override
  String get weaponKindLightBowgun => 'Light Bowgun';

  @override
  String get weaponKindHeavyBowgun => 'Heavy Bowgun';

  @override
  String get pieces => 'pieces';

  @override
  String get defense => 'Defense';

  @override
  String get baseDefense => 'Base Defense';

  @override
  String get slots => 'Slots';

  @override
  String get resistances => 'Resistances';

  @override
  String get noSlots => 'No slots';

  @override
  String get noResistances => 'No resistances';

  @override
  String get physicalDamage => 'Physical Damage';

  @override
  String get affinity => 'Affinity';

  @override
  String get sharpness => 'Sharpness';

  @override
  String get element => 'Element';

  @override
  String get statusEffect => 'Status Effect';

  @override
  String get phial => 'Phial';

  @override
  String get coatings => 'Coatings';

  @override
  String get shell => 'Shell';

  @override
  String get melody => 'Melody';

  @override
  String get songs => 'songs';

  @override
  String get echoBubble => 'Echo Bubble';

  @override
  String get echoWave => 'Echo Wave';

  @override
  String get ammo => 'Ammo';

  @override
  String get kinsect => 'Kinsect';

  @override
  String get level => 'Level';

  @override
  String campsOfLevel(int n) {
    return 'Camps of Level $n';
  }

  @override
  String get risk => 'Risk';

  @override
  String get zone => 'Zone';

  @override
  String get loadingMap => 'Loading map...';

  @override
  String get noMapImagesFound => 'No map images found';

  @override
  String get monsterInformation => 'Monster Information';

  @override
  String get species => 'Species';

  @override
  String get description => 'Description';

  @override
  String get features => 'Features';

  @override
  String get huntingTips => 'Hunting Tips';

  @override
  String get monsterVariants => 'Monster Variants';

  @override
  String get statistics => 'Statistics';

  @override
  String get baseHealth => 'Base Health';

  @override
  String get sizeRange => 'Size Range';

  @override
  String get elements => 'Elements';

  @override
  String get weaknessesAndResistances => 'Weaknesses and Resistances';

  @override
  String get weaknesses => 'Weaknesses';

  @override
  String get noKnownResistances => 'No known resistances';

  @override
  String get highRank => 'High Rank';

  @override
  String get lowRank => 'Low Rank';

  @override
  String get crownSizes => 'Crown Sizes';

  @override
  String get baseSize => 'Base size';

  @override
  String get miniCrown => 'Mini crown';

  @override
  String get silverCrown => 'Silver crown';

  @override
  String get goldCrown => 'Gold crown';

  @override
  String get elementsAndAilments => 'Elements and Ailments';

  @override
  String get monstersThatDropThisItem => 'Monsters that drop this item:';

  @override
  String get dropConditions => 'Drop Conditions:';

  @override
  String get craftingRecipe => 'Crafting Recipe:';

  @override
  String get requiredMaterials => 'Required Materials:';

  @override
  String get skillRanks => 'Skill Ranks:';

  @override
  String get rank => 'Rank';

  @override
  String get errorLoadingSkills => 'Error loading skills';

  @override
  String get noSkillsAvailable => 'No skills available';

  @override
  String get craftingMaterials => 'Crafting Materials';

  @override
  String get craft => 'Craft';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get defenseBonus => 'Defense Bonus';

  @override
  String get elderseal => 'Elderseal';

  @override
  String get lv => 'Lv';

  @override
  String get sharpnessRed => 'Red';

  @override
  String get sharpnessOrange => 'Orange';

  @override
  String get sharpnessYellow => 'Yellow';

  @override
  String get sharpnessGreen => 'Green';

  @override
  String get sharpnessBlue => 'Blue';

  @override
  String get sharpnessWhite => 'White';

  @override
  String get sharpnessPurple => 'Purple';

  @override
  String get setBonus => 'Set Bonus:';

  @override
  String get locationsLabel => 'Locations:';

  @override
  String get breakableParts => 'Breakable Parts';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownMap => 'Unknown Map';

  @override
  String get map => 'Map';
}
