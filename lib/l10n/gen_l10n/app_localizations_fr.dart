// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Assistant MHWilds';

  @override
  String get settings => 'Paramètres';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get locations => 'Lieux';

  @override
  String get monsters => 'Monstres';

  @override
  String get weapons => 'Armes';

  @override
  String get armor => 'Armure';

  @override
  String get items => 'Objets';

  @override
  String get decorations => 'Décorations';

  @override
  String get skills => 'Compétences';

  @override
  String get talismans => 'Talismans';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get skillDetails => 'Détails de la compétence';

  @override
  String get monsterNotFound => 'Monstre introuvable';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get close => 'Fermer';

  @override
  String get goToStore => 'Aller au store';

  @override
  String get newVersionAvailable => 'Nouvelle version disponible';

  @override
  String get appearance => 'Apparence';

  @override
  String get on => 'Activé';

  @override
  String get offDefault => 'Désactivé (par défaut)';

  @override
  String get armorSets => 'Ensembles d\'armure';

  @override
  String get menuMonstersSubtitle => 'Base de données de tous les monstres';

  @override
  String get menuItemsSubtitle => 'Matériaux et ressources';

  @override
  String get menuDecorationsSubtitle => 'Gemmes et bijoux de compétences';

  @override
  String get menuTalismansSubtitle => 'Accessoires puissants';

  @override
  String get menuArmorSetsSubtitle => 'Collections d\'armure complètes';

  @override
  String get menuWeaponsSubtitle => 'Armes et outils de combat';

  @override
  String get menuSkillsSubtitle => 'Capacités et effets de combat';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Vous avez la version $currentVersion. Une nouvelle version ($newVersion) est disponible sur le store. Mettez à jour pour les dernières améliorations et corrections.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Vous avez la version $currentVersion. Une nouvelle version est disponible sur le store. Mettez à jour pour les dernières améliorations et corrections.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Une nouvelle version ($newVersion) est disponible sur le store. Mettez à jour pour les dernières améliorations et corrections.';
  }

  @override
  String get updateMessageGeneric =>
      'Une nouvelle version est disponible sur le store. Mettez à jour pour les dernières améliorations et corrections.';

  @override
  String get filters => 'Filtres';

  @override
  String get loadingSkills => 'Chargement des compétences...';

  @override
  String get searchByName => 'Rechercher par nom';

  @override
  String get enterMonsterName => 'Entrez le nom du monstre...';

  @override
  String get searchBySpecies => 'Rechercher par espèce';

  @override
  String get enterSpecies => 'Entrez l\'espèce...';

  @override
  String get loadingMonsters => 'Chargement des monstres...';

  @override
  String get noMonstersFound => 'Aucun monstre trouvé';

  @override
  String get tryAdjustingFilters => 'Essayez d\'ajuster les filtres';

  @override
  String get type => 'Type';

  @override
  String get rarity => 'Rareté';

  @override
  String rarityLevel(int n) {
    return 'Rareté $n';
  }

  @override
  String get enterWeaponName => 'Entrez le nom de l\'arme...';

  @override
  String get enterItemName => 'Entrez le nom de l\'objet...';

  @override
  String get enterArmorSetName => 'Entrez le nom de l\'ensemble d\'armure...';

  @override
  String get enterTalismanName => 'Entrez le nom du talisman...';

  @override
  String get enterSkillName => 'Entrez le nom de la compétence...';

  @override
  String get enterDecorationName => 'Entrez le nom de la décoration...';

  @override
  String get loadingWeapons => 'Chargement des armes...';

  @override
  String get loadingItems => 'Chargement des objets...';

  @override
  String get loadingArmorSets => 'Chargement des ensembles d\'armure...';

  @override
  String get loadingTalismans => 'Chargement des talismans...';

  @override
  String get loadingDecorations => 'Chargement des décorations...';

  @override
  String get noWeaponsFound => 'Aucune arme trouvée';

  @override
  String get noItemsFound => 'Aucun objet trouvé';

  @override
  String get noArmorSetsFound => 'Aucun ensemble d\'armure trouvé';

  @override
  String get noTalismansFound => 'Aucun talisman trouvé';

  @override
  String get noSkillsFound => 'Aucune compétence trouvée';

  @override
  String get noDecorationsFound => 'Aucune décoration trouvée';

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
  String get weaponKindGreatSword => 'Grande épée';

  @override
  String get weaponKindLongSword => 'Épée longue';

  @override
  String get weaponKindSwordShield => 'Épée et bouclier';

  @override
  String get weaponKindDualBlades => 'Lames doubles';

  @override
  String get weaponKindHammer => 'Marteau';

  @override
  String get weaponKindHuntingHorn => 'Corne de chasse';

  @override
  String get weaponKindLance => 'Lance';

  @override
  String get weaponKindGunlance => 'Lancecanon';

  @override
  String get weaponKindSwitchAxe => 'Morpho-hache';

  @override
  String get weaponKindChargeBlade => 'Volto-hache';

  @override
  String get weaponKindInsectGlaive => 'Insectoglaive';

  @override
  String get weaponKindBow => 'Arc';

  @override
  String get weaponKindLightBowgun => 'Fusarbalète léger';

  @override
  String get weaponKindHeavyBowgun => 'Fusarbalète lourd';

  @override
  String get pieces => 'pièces';

  @override
  String get defense => 'Défense';

  @override
  String get baseDefense => 'Défense de base';

  @override
  String get slots => 'Emplacements';

  @override
  String get resistances => 'Résistances';

  @override
  String get noSlots => 'Aucun emplacement';

  @override
  String get noResistances => 'Aucune résistance';

  @override
  String get physicalDamage => 'Dégâts physiques';

  @override
  String get affinity => 'Affinité';

  @override
  String get sharpness => 'Tranchant';

  @override
  String get element => 'Élément';

  @override
  String get statusEffect => 'Effet de statut';

  @override
  String get phial => 'Fiole';

  @override
  String get coatings => 'Revêtements';

  @override
  String get shell => 'Coquille';

  @override
  String get melody => 'Mélodie';

  @override
  String get songs => 'chansons';

  @override
  String get echoBubble => 'Bulle d\'écho';

  @override
  String get echoWave => 'Vague d\'écho';

  @override
  String get ammo => 'Munitions';

  @override
  String get kinsect => 'Insecte';

  @override
  String get level => 'Niveau';

  @override
  String campsOfLevel(int n) {
    return 'Camps du Niveau $n';
  }

  @override
  String get risk => 'Risque';

  @override
  String get zone => 'Zone';

  @override
  String get loadingMap => 'Chargement de la carte...';

  @override
  String get noMapImagesFound => 'Aucune image de carte trouvée';

  @override
  String get monsterInformation => 'Informations sur le Monstre';

  @override
  String get species => 'Espèce';

  @override
  String get description => 'Description';

  @override
  String get features => 'Caractéristiques';

  @override
  String get huntingTips => 'Conseils de Chasse';

  @override
  String get monsterVariants => 'Variantes du Monstre';

  @override
  String get statistics => 'Statistiques';

  @override
  String get baseHealth => 'Santé de Base';

  @override
  String get sizeRange => 'Plage de Taille';

  @override
  String get elements => 'Éléments';

  @override
  String get weaknessesAndResistances => 'Faiblesses et Résistances';

  @override
  String get weaknesses => 'Faiblesses';

  @override
  String get noKnownResistances => 'Aucune résistance connue';

  @override
  String get highRank => 'Rang Élevé';

  @override
  String get lowRank => 'Rang Bas';

  @override
  String get crownSizes => 'Tailles de Couronne';

  @override
  String get baseSize => 'Taille de base';

  @override
  String get miniCrown => 'Couronne mini';

  @override
  String get silverCrown => 'Couronne d\'argent';

  @override
  String get goldCrown => 'Couronne d\'or';

  @override
  String get elementsAndAilments => 'Éléments et Affections';

  @override
  String get monstersThatDropThisItem =>
      'Monstres qui laissent tomber cet objet:';

  @override
  String get dropConditions => 'Conditions d\'obtention:';

  @override
  String get craftingRecipe => 'Recette de Fabrication:';

  @override
  String get requiredMaterials => 'Matériaux Requis:';

  @override
  String get skillRanks => 'Rangs de Compétence:';

  @override
  String get rank => 'Rang';

  @override
  String get errorLoadingSkills => 'Erreur lors du chargement des compétences';

  @override
  String get noSkillsAvailable => 'Aucune compétence disponible';

  @override
  String get craftingMaterials => 'Matériaux de Fabrication';

  @override
  String get craft => 'Fabriquer';

  @override
  String get upgrade => 'Améliorer';

  @override
  String get defenseBonus => 'Bonus de Défense';

  @override
  String get elderseal => 'Sceau Ancien';

  @override
  String get lv => 'Nv';

  @override
  String get sharpnessRed => 'Rouge';

  @override
  String get sharpnessOrange => 'Orange';

  @override
  String get sharpnessYellow => 'Jaune';

  @override
  String get sharpnessGreen => 'Vert';

  @override
  String get sharpnessBlue => 'Bleu';

  @override
  String get sharpnessWhite => 'Blanc';

  @override
  String get sharpnessPurple => 'Violet';

  @override
  String get setBonus => 'Bonus de Set:';

  @override
  String get locationsLabel => 'Emplacements:';

  @override
  String get breakableParts => 'Parties Cassables';

  @override
  String get unknown => 'Inconnu';

  @override
  String get unknownMap => 'Carte Inconnue';

  @override
  String get map => 'Carte';
}
