// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MHWilds Assistant';

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
  String get menuLocationsSubtitle => 'Explorez les cartes et les camps';

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
  String get buildOptimizer => 'Optimiseur de build';

  @override
  String get buildOptimizerMenuSubtitle =>
      'Optimisez votre build et vos compétences';

  @override
  String get buildOptimizerCreditsIntro =>
      'Cet écran intègre MH Wilds Build Optimizer dans le cadre d\'une collaboration externe.';

  @override
  String get buildOptimizerCreditsCreator => 'Créé par Nenrikido (Nenri).';

  @override
  String get buildCrafter => 'Créateur de build';

  @override
  String get buildCrafterMenuSubtitle => 'Planifiez et créez vos builds';

  @override
  String get buildCrafterCreditsIntro =>
      'Cet écran intègre MH Wilds Build Crafter dans le cadre d\'une collaboration externe.';

  @override
  String get buildCrafterCreditsCreator => 'Créé par Cay.';

  @override
  String get buildCrafterWebViewUnavailable =>
      'WebView n\'est pas disponible sur cette plateforme.';

  @override
  String get buildCrafterOpenInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get rateAppReminder =>
      'N\'oubliez pas de noter l\'application si elle vous plaît.';

  @override
  String get understood => 'Compris';

  @override
  String get web => 'Web';

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
  String get zones => 'Zones';

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
  String get noKnownWeaknesses => 'Aucune faiblesse connue';

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

  @override
  String get rateAppTitle => 'Enjoying the app?';

  @override
  String get rateAppMessage =>
      'Are you enjoying MHWilds Assistant? Your review helps us keep improving.';

  @override
  String get rateAppYes => 'Yes, I love it!';

  @override
  String get rateAppNo => 'Not now / No';

  @override
  String get rateAppAction => 'Rate application';

  @override
  String get speciesFangedWyvern => 'Wyverne à crocs';

  @override
  String get speciesFlyingWyvern => 'Wyverne volante';

  @override
  String get speciesBruteWyvern => 'Wyverne brute';

  @override
  String get speciesBirdWyvern => 'Wyverne rapace';

  @override
  String get speciesPiscineWyvern => 'Wyverne pisciforme';

  @override
  String get speciesFangedBeast => 'Bête à crocs';

  @override
  String get speciesElderDragon => 'Dragon ancien';

  @override
  String get speciesRelicat => 'Relicat';

  @override
  String get speciesNeopteron => 'Néoptéron';

  @override
  String get speciesTemnoceran => 'Temnocérane';

  @override
  String get speciesLeviathan => 'Léviathan';

  @override
  String get speciesAmphibian => 'Amphibien';

  @override
  String get speciesSnakeWyvern => 'Wyverne serpent';

  @override
  String get monsterKindLarge => 'Grand monstre';

  @override
  String get monsterKindSmall => 'Petit monstre';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get camps => 'Camps';

  @override
  String get openOptimizer => 'Ouvrir l\'optimiseur';

  @override
  String get ok => 'OK';

  @override
  String get webViewNotSupported =>
      'WebView n\'est pas disponible sur cette plateforme.';

  @override
  String get openInBrowserHint =>
      'Vous pouvez ouvrir l\'optimiseur dans votre navigateur.';

  @override
  String get weaponTree => 'Weapon Tree';

  @override
  String get previousWeapon => 'Upgrades from';

  @override
  String get upgradesTo => 'Upgrades to';

  @override
  String get listView => 'Liste';

  @override
  String get treeView => 'Arbre';

  @override
  String get treeSeries => 'Séries d\'arbres';

  @override
  String get enterSeriesName => 'Entrez le nom de la série...';

  @override
  String get noSeries => 'Sans série';

  @override
  String get treeViewTooltip => 'Vue en arbre';

  @override
  String get tableViewTooltip => 'Vue en tableau';

  @override
  String get errorLoadingWeaponDetails =>
      'Erreur lors du chargement des détails de l\'arme';

  @override
  String get masterRank => 'Rang Maître';

  @override
  String get retry => 'Réessayer';

  @override
  String get errorOffline =>
      'Pas de connexion. Vérifiez votre internet et réessayez.';

  @override
  String get errorLoadingData =>
      'Impossible de charger les données. Veuillez réessayer.';

  @override
  String offlineDataFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.Md(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Hors ligne · données du $dateString';
  }

  @override
  String get creditsTooltip => 'Crédits';

  @override
  String get elementFire => 'Feu';

  @override
  String get elementWater => 'Eau';

  @override
  String get elementIce => 'Glace';

  @override
  String get elementThunder => 'Foudre';

  @override
  String get elementDragon => 'Dragon';

  @override
  String get elementParalysis => 'Paralysie';

  @override
  String get elementPoison => 'Poison';

  @override
  String get elementSleep => 'Sommeil';

  @override
  String get elementBlastblight => 'Explosion';

  @override
  String get elementBlast => 'Explosif';

  @override
  String get elementFireblight => 'Fléau de feu';

  @override
  String get elementWaterblight => 'Fléau d\'eau';

  @override
  String get elementIceblight => 'Fléau de glace';

  @override
  String get elementThunderblight => 'Fléau de foudre';

  @override
  String get elementDragonblight => 'Fléau du dragon';

  @override
  String get elementFrostblight => 'Gelure';

  @override
  String get elementWebbed => 'Entoilé';

  @override
  String get elementBleeding => 'Saignement';

  @override
  String get elementFrenzy => 'Frénésie';

  @override
  String get ailmentDescThunderblight =>
      'Le fléau de foudre est causé par l\'élément Foudre et augmente la probabilité que les attaques des monstres étourdissent le chasseur.\nIl se soigne en consommant une Nulberry ou en utilisant un Cleanser Booster.';

  @override
  String get ailmentDescWaterblight =>
      'Le fléau d\'eau est causé par l\'élément Eau et réduit la récupération d\'endurance du chasseur.\nIl se soigne en consommant une Nulberry ou en utilisant un Cleanser Booster.';

  @override
  String get ailmentDescFireblight =>
      'Le fléau de feu est causé par l\'élément Feu et fait perdre de la santé au chasseur au fil du temps.\nIl se soigne en consommant une Nulberry. Si de l\'eau est proche, on peut y sauter ou rouler 3 fois au sol.';

  @override
  String get ailmentDescIceblight =>
      'Le fléau de glace est causé par l\'élément Glace et augmente la consommation d\'endurance quand on court, attaque ou esquive.\nIl se soigne en consommant une Nulberry.';

  @override
  String get ailmentDescDragonblight =>
      'Le fléau du dragon est causé par l\'élément Dragon et annule les effets de dégâts et l\'accumulation d\'état de cet élément.\nIl se soigne en consommant une Nulberry.';

  @override
  String get ailmentDescBlast =>
      'Explosif est un état qui marque un monstre et permet de l\'endommager par de petites explosions.\nIl se soigne avec une Nulberry ou en esquivant en roulade jusqu\'à trois fois.';

  @override
  String get ailmentDescBlastblight =>
      'L\'explosion fait exploser la cible après un certain temps ou lorsqu\'elle reçoit une attaque puissante.\nElle se soigne avec une Nulberry ou en esquivant en roulade jusqu\'à trois fois.';

  @override
  String get ailmentDescBleeding =>
      'Le saignement fait perdre de la santé au chasseur lorsqu\'il se déplace, attaque ou esquive.\nIl se soigne en mangeant un Astera Jerky, un Well-Done Steak ou une Sushifish Scale, ou en s\'accroupissant quelques secondes.';

  @override
  String get ailmentDescFrenzy =>
      'La frénésie fait subir temporairement plus de dégâts au chasseur lorsqu\'il est totalement infecté.\nElle se soigne en utilisant une Nulberry.';

  @override
  String get ailmentDescFrostblight =>
      'La gelure empêche temporairement le chasseur de bouger ou d\'agir.\nElle se soigne avec un Cleanser ou avec une Résistance à l\'immobilisation de niveau 3.';

  @override
  String get ailmentDescWebbed =>
      'Entoilé empêche temporairement le chasseur de bouger ou d\'agir.\nIl se soigne avec un Cleanser, en bougeant, en appuyant sur des boutons, en étant projeté par une attaque ou en subissant un coup.';

  @override
  String get ailmentDescPoison =>
      'Le poison réduit progressivement la santé de la cible au fil du temps.\nIl se soigne avec un Antidote, une Herbal Medicine ou une Herbal Powder.';

  @override
  String get ailmentDescSleep =>
      'Le sommeil endort la cible, qui devient vulnérable à une seule attaque.\nLa cible se réveille lorsqu\'elle subit des dégâts.\nIl se soigne avec un Energy Drink, par un allié ou un monstre.';

  @override
  String get ailmentDescParalysis =>
      'La paralysie immobilise le chasseur ou le monstre et le rend vulnérable à des dégâts accrus pendant sa durée.\nElle se soigne avec des impacts à fort recul, comme un coup montant d\'un Marteau ou d\'une Grande Épée.';

  @override
  String get announcements => 'Annonces';

  @override
  String get announcementsNew => 'Annonces (nouveau)';

  @override
  String get loadingAnnouncements => 'Chargement des annonces...';

  @override
  String get noAnnouncements => 'Aucune annonce pour le moment';

  @override
  String get openLink => 'Ouvrir le lien';

  @override
  String get reportBug => 'Signaler un bug';

  @override
  String get bugReportDescriptionLabel => 'Que s\'est-il passé ?';

  @override
  String get bugReportDescriptionHint =>
      'Décrivez le problème et comment le reproduire';

  @override
  String get bugReportDescriptionRequired => 'Veuillez décrire le problème';

  @override
  String get bugReportContactLabel => 'Votre e-mail (facultatif)';

  @override
  String get bugReportContactHint => 'Uniquement si vous souhaitez une réponse';

  @override
  String get bugReportAttach => 'Joindre des images ou des vidéos';

  @override
  String bugReportAttachLimit(int max, int mb) {
    return 'Jusqu\'à $max fichiers, $mb Mo au total';
  }

  @override
  String get bugReportRemoveAttachment => 'Retirer la pièce jointe';

  @override
  String get bugReportSend => 'Envoyer le rapport';

  @override
  String get bugReportSending => 'Envoi...';

  @override
  String get bugReportSent => 'Merci ! Votre rapport a été envoyé.';

  @override
  String get bugReportFailed =>
      'Impossible d\'envoyer le rapport. Réessayez plus tard.';

  @override
  String bugReportTooMany(int max) {
    return 'Vous pouvez joindre $max fichiers au maximum.';
  }

  @override
  String bugReportTooLarge(int mb) {
    return 'Les pièces jointes dépassent $mb Mo.';
  }

  @override
  String get bugReportPrivacy =>
      'Le rapport inclut la version de l\'appli, la plateforme et la langue.';

  @override
  String get rewardTargetReward => 'Récompense de cible';

  @override
  String get rewardCarve => 'Dépeçage';

  @override
  String get rewardBrokenPart => 'Partie brisée';

  @override
  String get rewardCarveRotten => 'Dépeçage (pourri)';

  @override
  String get rewardWoundDestroyed => 'Plaie détruite';

  @override
  String get rewardTemperedWoundDestroyed => 'Plaie détruite (tempéré)';

  @override
  String get rewardCarveSevered => 'Dépeçage (partie tranchée)';

  @override
  String get rewardCarveRottenSevered => 'Dépeçage (pourri, partie tranchée)';

  @override
  String get rewardCarveCrystallized => 'Dépeçage (cristallisé)';

  @override
  String get rewardBrokenFragment => 'Fragment brisé';

  @override
  String get maps => 'Cartes';
}
