import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('es', 'ES'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MHWilds Assistant'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @monsters.
  ///
  /// In en, this message translates to:
  /// **'Monsters'**
  String get monsters;

  /// No description provided for @weapons.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get weapons;

  /// No description provided for @armor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get armor;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @decorations.
  ///
  /// In en, this message translates to:
  /// **'Decorations'**
  String get decorations;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @talismans.
  ///
  /// In en, this message translates to:
  /// **'Talismans'**
  String get talismans;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @skillDetails.
  ///
  /// In en, this message translates to:
  /// **'Skill Details'**
  String get skillDetails;

  /// No description provided for @monsterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Monster not found'**
  String get monsterNotFound;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @goToStore.
  ///
  /// In en, this message translates to:
  /// **'Go to store'**
  String get goToStore;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionAvailable;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @offDefault.
  ///
  /// In en, this message translates to:
  /// **'Off (default)'**
  String get offDefault;

  /// No description provided for @armorSets.
  ///
  /// In en, this message translates to:
  /// **'Armor Sets'**
  String get armorSets;

  /// No description provided for @menuMonstersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Database of all monsters'**
  String get menuMonstersSubtitle;

  /// No description provided for @menuItemsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Materials and resources'**
  String get menuItemsSubtitle;

  /// No description provided for @menuDecorationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Skill gems and jewels'**
  String get menuDecorationsSubtitle;

  /// No description provided for @menuTalismansSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Powerful accessories'**
  String get menuTalismansSubtitle;

  /// No description provided for @menuArmorSetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete armor collections'**
  String get menuArmorSetsSubtitle;

  /// No description provided for @menuWeaponsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Combat weapons and tools'**
  String get menuWeaponsSubtitle;

  /// No description provided for @menuSkillsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Combat abilities and effects'**
  String get menuSkillsSubtitle;

  /// No description provided for @updateMessageWithBoth.
  ///
  /// In en, this message translates to:
  /// **'You have version {currentVersion}. A new version ({newVersion}) is available in the store. Update to get the latest improvements and fixes.'**
  String updateMessageWithBoth(String currentVersion, String newVersion);

  /// No description provided for @updateMessageCurrentOnly.
  ///
  /// In en, this message translates to:
  /// **'You have version {currentVersion}. A new version is available in the store. Update to get the latest improvements and fixes.'**
  String updateMessageCurrentOnly(String currentVersion);

  /// No description provided for @updateMessageNewOnly.
  ///
  /// In en, this message translates to:
  /// **'A new version ({newVersion}) is available in the store. Update to get the latest improvements and fixes.'**
  String updateMessageNewOnly(String newVersion);

  /// No description provided for @updateMessageGeneric.
  ///
  /// In en, this message translates to:
  /// **'A new version is available in the store. Update to get the latest improvements and fixes.'**
  String get updateMessageGeneric;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @loadingSkills.
  ///
  /// In en, this message translates to:
  /// **'Loading skills...'**
  String get loadingSkills;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by Name'**
  String get searchByName;

  /// No description provided for @enterMonsterName.
  ///
  /// In en, this message translates to:
  /// **'Enter monster name...'**
  String get enterMonsterName;

  /// No description provided for @searchBySpecies.
  ///
  /// In en, this message translates to:
  /// **'Search by Species'**
  String get searchBySpecies;

  /// No description provided for @enterSpecies.
  ///
  /// In en, this message translates to:
  /// **'Enter species...'**
  String get enterSpecies;

  /// No description provided for @loadingMonsters.
  ///
  /// In en, this message translates to:
  /// **'Loading monsters...'**
  String get loadingMonsters;

  /// No description provided for @noMonstersFound.
  ///
  /// In en, this message translates to:
  /// **'No monsters found'**
  String get noMonstersFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @rarity.
  ///
  /// In en, this message translates to:
  /// **'Rarity'**
  String get rarity;

  /// No description provided for @rarityLevel.
  ///
  /// In en, this message translates to:
  /// **'Rarity {n}'**
  String rarityLevel(int n);

  /// No description provided for @enterWeaponName.
  ///
  /// In en, this message translates to:
  /// **'Enter weapon name...'**
  String get enterWeaponName;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter item name...'**
  String get enterItemName;

  /// No description provided for @enterArmorSetName.
  ///
  /// In en, this message translates to:
  /// **'Enter armor set name...'**
  String get enterArmorSetName;

  /// No description provided for @enterTalismanName.
  ///
  /// In en, this message translates to:
  /// **'Enter talisman name...'**
  String get enterTalismanName;

  /// No description provided for @enterSkillName.
  ///
  /// In en, this message translates to:
  /// **'Enter skill name...'**
  String get enterSkillName;

  /// No description provided for @enterDecorationName.
  ///
  /// In en, this message translates to:
  /// **'Enter decoration name...'**
  String get enterDecorationName;

  /// No description provided for @loadingWeapons.
  ///
  /// In en, this message translates to:
  /// **'Loading weapons...'**
  String get loadingWeapons;

  /// No description provided for @loadingItems.
  ///
  /// In en, this message translates to:
  /// **'Loading items...'**
  String get loadingItems;

  /// No description provided for @loadingArmorSets.
  ///
  /// In en, this message translates to:
  /// **'Loading armor sets...'**
  String get loadingArmorSets;

  /// No description provided for @loadingTalismans.
  ///
  /// In en, this message translates to:
  /// **'Loading talismans...'**
  String get loadingTalismans;

  /// No description provided for @loadingDecorations.
  ///
  /// In en, this message translates to:
  /// **'Loading decorations...'**
  String get loadingDecorations;

  /// No description provided for @noWeaponsFound.
  ///
  /// In en, this message translates to:
  /// **'No weapons found'**
  String get noWeaponsFound;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @noArmorSetsFound.
  ///
  /// In en, this message translates to:
  /// **'No armor sets found'**
  String get noArmorSetsFound;

  /// No description provided for @noTalismansFound.
  ///
  /// In en, this message translates to:
  /// **'No talismans found'**
  String get noTalismansFound;

  /// No description provided for @noSkillsFound.
  ///
  /// In en, this message translates to:
  /// **'No skills found'**
  String get noSkillsFound;

  /// No description provided for @noDecorationsFound.
  ///
  /// In en, this message translates to:
  /// **'No decorations found'**
  String get noDecorationsFound;

  /// No description provided for @armorSlotHead.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get armorSlotHead;

  /// No description provided for @armorSlotChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get armorSlotChest;

  /// No description provided for @armorSlotArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get armorSlotArms;

  /// No description provided for @armorSlotWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get armorSlotWaist;

  /// No description provided for @armorSlotLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get armorSlotLegs;

  /// No description provided for @typeWeapon.
  ///
  /// In en, this message translates to:
  /// **'Weapon'**
  String get typeWeapon;

  /// No description provided for @typeArmor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get typeArmor;

  /// No description provided for @typeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get typeGroup;

  /// No description provided for @typeSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get typeSet;

  /// No description provided for @weaponKindGreatSword.
  ///
  /// In en, this message translates to:
  /// **'Great Sword'**
  String get weaponKindGreatSword;

  /// No description provided for @weaponKindLongSword.
  ///
  /// In en, this message translates to:
  /// **'Long Sword'**
  String get weaponKindLongSword;

  /// No description provided for @weaponKindSwordShield.
  ///
  /// In en, this message translates to:
  /// **'Sword & Shield'**
  String get weaponKindSwordShield;

  /// No description provided for @weaponKindDualBlades.
  ///
  /// In en, this message translates to:
  /// **'Dual Blades'**
  String get weaponKindDualBlades;

  /// No description provided for @weaponKindHammer.
  ///
  /// In en, this message translates to:
  /// **'Hammer'**
  String get weaponKindHammer;

  /// No description provided for @weaponKindHuntingHorn.
  ///
  /// In en, this message translates to:
  /// **'Hunting Horn'**
  String get weaponKindHuntingHorn;

  /// No description provided for @weaponKindLance.
  ///
  /// In en, this message translates to:
  /// **'Lance'**
  String get weaponKindLance;

  /// No description provided for @weaponKindGunlance.
  ///
  /// In en, this message translates to:
  /// **'Gunlance'**
  String get weaponKindGunlance;

  /// No description provided for @weaponKindSwitchAxe.
  ///
  /// In en, this message translates to:
  /// **'Switch Axe'**
  String get weaponKindSwitchAxe;

  /// No description provided for @weaponKindChargeBlade.
  ///
  /// In en, this message translates to:
  /// **'Charge Blade'**
  String get weaponKindChargeBlade;

  /// No description provided for @weaponKindInsectGlaive.
  ///
  /// In en, this message translates to:
  /// **'Insect Glaive'**
  String get weaponKindInsectGlaive;

  /// No description provided for @weaponKindBow.
  ///
  /// In en, this message translates to:
  /// **'Bow'**
  String get weaponKindBow;

  /// No description provided for @weaponKindLightBowgun.
  ///
  /// In en, this message translates to:
  /// **'Light Bowgun'**
  String get weaponKindLightBowgun;

  /// No description provided for @weaponKindHeavyBowgun.
  ///
  /// In en, this message translates to:
  /// **'Heavy Bowgun'**
  String get weaponKindHeavyBowgun;

  /// No description provided for @pieces.
  ///
  /// In en, this message translates to:
  /// **'pieces'**
  String get pieces;

  /// No description provided for @defense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get defense;

  /// No description provided for @baseDefense.
  ///
  /// In en, this message translates to:
  /// **'Base Defense'**
  String get baseDefense;

  /// No description provided for @slots.
  ///
  /// In en, this message translates to:
  /// **'Slots'**
  String get slots;

  /// No description provided for @resistances.
  ///
  /// In en, this message translates to:
  /// **'Resistances'**
  String get resistances;

  /// No description provided for @noSlots.
  ///
  /// In en, this message translates to:
  /// **'No slots'**
  String get noSlots;

  /// No description provided for @noResistances.
  ///
  /// In en, this message translates to:
  /// **'No resistances'**
  String get noResistances;

  /// No description provided for @physicalDamage.
  ///
  /// In en, this message translates to:
  /// **'Physical Damage'**
  String get physicalDamage;

  /// No description provided for @affinity.
  ///
  /// In en, this message translates to:
  /// **'Affinity'**
  String get affinity;

  /// No description provided for @sharpness.
  ///
  /// In en, this message translates to:
  /// **'Sharpness'**
  String get sharpness;

  /// No description provided for @element.
  ///
  /// In en, this message translates to:
  /// **'Element'**
  String get element;

  /// No description provided for @statusEffect.
  ///
  /// In en, this message translates to:
  /// **'Status Effect'**
  String get statusEffect;

  /// No description provided for @phial.
  ///
  /// In en, this message translates to:
  /// **'Phial'**
  String get phial;

  /// No description provided for @coatings.
  ///
  /// In en, this message translates to:
  /// **'Coatings'**
  String get coatings;

  /// No description provided for @shell.
  ///
  /// In en, this message translates to:
  /// **'Shell'**
  String get shell;

  /// No description provided for @melody.
  ///
  /// In en, this message translates to:
  /// **'Melody'**
  String get melody;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get songs;

  /// No description provided for @echoBubble.
  ///
  /// In en, this message translates to:
  /// **'Echo Bubble'**
  String get echoBubble;

  /// No description provided for @echoWave.
  ///
  /// In en, this message translates to:
  /// **'Echo Wave'**
  String get echoWave;

  /// No description provided for @ammo.
  ///
  /// In en, this message translates to:
  /// **'Ammo'**
  String get ammo;

  /// No description provided for @kinsect.
  ///
  /// In en, this message translates to:
  /// **'Kinsect'**
  String get kinsect;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @campsOfLevel.
  ///
  /// In en, this message translates to:
  /// **'Camps of Level {n}'**
  String campsOfLevel(int n);

  /// No description provided for @risk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get risk;

  /// No description provided for @zone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zone;

  /// No description provided for @loadingMap.
  ///
  /// In en, this message translates to:
  /// **'Loading map...'**
  String get loadingMap;

  /// No description provided for @noMapImagesFound.
  ///
  /// In en, this message translates to:
  /// **'No map images found'**
  String get noMapImagesFound;

  /// No description provided for @monsterInformation.
  ///
  /// In en, this message translates to:
  /// **'Monster Information'**
  String get monsterInformation;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @huntingTips.
  ///
  /// In en, this message translates to:
  /// **'Hunting Tips'**
  String get huntingTips;

  /// No description provided for @monsterVariants.
  ///
  /// In en, this message translates to:
  /// **'Monster Variants'**
  String get monsterVariants;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @baseHealth.
  ///
  /// In en, this message translates to:
  /// **'Base Health'**
  String get baseHealth;

  /// No description provided for @sizeRange.
  ///
  /// In en, this message translates to:
  /// **'Size Range'**
  String get sizeRange;

  /// No description provided for @elements.
  ///
  /// In en, this message translates to:
  /// **'Elements'**
  String get elements;

  /// No description provided for @weaknessesAndResistances.
  ///
  /// In en, this message translates to:
  /// **'Weaknesses and Resistances'**
  String get weaknessesAndResistances;

  /// No description provided for @weaknesses.
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get weaknesses;

  /// No description provided for @noKnownResistances.
  ///
  /// In en, this message translates to:
  /// **'No known resistances'**
  String get noKnownResistances;

  /// No description provided for @highRank.
  ///
  /// In en, this message translates to:
  /// **'High Rank'**
  String get highRank;

  /// No description provided for @lowRank.
  ///
  /// In en, this message translates to:
  /// **'Low Rank'**
  String get lowRank;

  /// No description provided for @crownSizes.
  ///
  /// In en, this message translates to:
  /// **'Crown Sizes'**
  String get crownSizes;

  /// No description provided for @baseSize.
  ///
  /// In en, this message translates to:
  /// **'Base size'**
  String get baseSize;

  /// No description provided for @miniCrown.
  ///
  /// In en, this message translates to:
  /// **'Mini crown'**
  String get miniCrown;

  /// No description provided for @silverCrown.
  ///
  /// In en, this message translates to:
  /// **'Silver crown'**
  String get silverCrown;

  /// No description provided for @goldCrown.
  ///
  /// In en, this message translates to:
  /// **'Gold crown'**
  String get goldCrown;

  /// No description provided for @elementsAndAilments.
  ///
  /// In en, this message translates to:
  /// **'Elements and Ailments'**
  String get elementsAndAilments;

  /// No description provided for @monstersThatDropThisItem.
  ///
  /// In en, this message translates to:
  /// **'Monsters that drop this item:'**
  String get monstersThatDropThisItem;

  /// No description provided for @dropConditions.
  ///
  /// In en, this message translates to:
  /// **'Drop Conditions:'**
  String get dropConditions;

  /// No description provided for @craftingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Crafting Recipe:'**
  String get craftingRecipe;

  /// No description provided for @requiredMaterials.
  ///
  /// In en, this message translates to:
  /// **'Required Materials:'**
  String get requiredMaterials;

  /// No description provided for @skillRanks.
  ///
  /// In en, this message translates to:
  /// **'Skill Ranks:'**
  String get skillRanks;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @errorLoadingSkills.
  ///
  /// In en, this message translates to:
  /// **'Error loading skills'**
  String get errorLoadingSkills;

  /// No description provided for @noSkillsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No skills available'**
  String get noSkillsAvailable;

  /// No description provided for @craftingMaterials.
  ///
  /// In en, this message translates to:
  /// **'Crafting Materials'**
  String get craftingMaterials;

  /// No description provided for @craft.
  ///
  /// In en, this message translates to:
  /// **'Craft'**
  String get craft;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @defenseBonus.
  ///
  /// In en, this message translates to:
  /// **'Defense Bonus'**
  String get defenseBonus;

  /// No description provided for @elderseal.
  ///
  /// In en, this message translates to:
  /// **'Elderseal'**
  String get elderseal;

  /// No description provided for @lv.
  ///
  /// In en, this message translates to:
  /// **'Lv'**
  String get lv;

  /// No description provided for @sharpnessRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get sharpnessRed;

  /// No description provided for @sharpnessOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get sharpnessOrange;

  /// No description provided for @sharpnessYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get sharpnessYellow;

  /// No description provided for @sharpnessGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get sharpnessGreen;

  /// No description provided for @sharpnessBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get sharpnessBlue;

  /// No description provided for @sharpnessWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get sharpnessWhite;

  /// No description provided for @sharpnessPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get sharpnessPurple;

  /// No description provided for @setBonus.
  ///
  /// In en, this message translates to:
  /// **'Set Bonus:'**
  String get setBonus;

  /// No description provided for @locationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Locations:'**
  String get locationsLabel;

  /// No description provided for @breakableParts.
  ///
  /// In en, this message translates to:
  /// **'Breakable Parts'**
  String get breakableParts;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unknownMap.
  ///
  /// In en, this message translates to:
  /// **'Unknown Map'**
  String get unknownMap;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pl',
        'pt'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
          case 'ES':
            return AppLocalizationsEsEs();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
