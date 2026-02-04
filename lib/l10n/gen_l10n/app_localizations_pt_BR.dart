// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizations {
  AppLocalizationsPtBr([String locale = 'pt_BR']) : super(locale);

  @override
  String get appTitle => 'Assistente MHWilds';

  @override
  String get settings => 'Configurações';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get locations => 'Localizações';

  @override
  String get monsters => 'Monstros';

  @override
  String get weapons => 'Armas';

  @override
  String get armor => 'Armadura';

  @override
  String get items => 'Itens';

  @override
  String get decorations => 'Decorações';

  @override
  String get skills => 'Habilidades';

  @override
  String get talismans => 'Talismãs';

  @override
  String get reset => 'Redefinir';

  @override
  String get skillDetails => 'Detalhes da habilidade';

  @override
  String get monsterNotFound => 'Monstro não encontrado';

  @override
  String errorWithMessage(String message) {
    return 'Erro: $message';
  }

  @override
  String get close => 'Fechar';

  @override
  String get goToStore => 'Ir à loja';

  @override
  String get newVersionAvailable => 'Nova versão disponível';

  @override
  String get appearance => 'Aparência';

  @override
  String get on => 'Ligado';

  @override
  String get offDefault => 'Desligado (padrão)';

  @override
  String get armorSets => 'Conjuntos de armadura';

  @override
  String get menuMonstersSubtitle => 'Banco de dados de todos os monstros';

  @override
  String get menuItemsSubtitle => 'Materiais e recursos';

  @override
  String get menuDecorationsSubtitle => 'Gemas e joias de habilidades';

  @override
  String get menuTalismansSubtitle => 'Acessórios poderosos';

  @override
  String get menuArmorSetsSubtitle => 'Coleções de armadura completas';

  @override
  String get menuWeaponsSubtitle => 'Armas e ferramentas de combate';

  @override
  String get menuSkillsSubtitle => 'Habilidades e efeitos de combate';

  @override
  String updateMessageWithBoth(String currentVersion, String newVersion) {
    return 'Você tem a versão $currentVersion. Uma nova versão ($newVersion) está disponível na loja. Atualize para as últimas melhorias e correções.';
  }

  @override
  String updateMessageCurrentOnly(String currentVersion) {
    return 'Você tem a versão $currentVersion. Uma nova versão está disponível na loja. Atualize para as últimas melhorias e correções.';
  }

  @override
  String updateMessageNewOnly(String newVersion) {
    return 'Uma nova versão ($newVersion) está disponível na loja. Atualize para as últimas melhorias e correções.';
  }

  @override
  String get updateMessageGeneric =>
      'Uma nova versão está disponível na loja. Atualize para as últimas melhorias e correções.';

  @override
  String get filters => 'Filtros';

  @override
  String get loadingSkills => 'Carregando habilidades...';

  @override
  String get searchByName => 'Pesquisar por nome';

  @override
  String get enterMonsterName => 'Digite o nome do monstro...';

  @override
  String get searchBySpecies => 'Pesquisar por espécie';

  @override
  String get enterSpecies => 'Digite a espécie...';

  @override
  String get loadingMonsters => 'Carregando monstros...';

  @override
  String get noMonstersFound => 'Nenhum monstro encontrado';

  @override
  String get tryAdjustingFilters => 'Tente ajustar os filtros';

  @override
  String get type => 'Tipo';

  @override
  String get rarity => 'Raridade';

  @override
  String rarityLevel(int n) => 'Raridade $n';

  @override
  String get enterWeaponName => 'Digite o nome da arma...';

  @override
  String get enterItemName => 'Digite o nome do item...';

  @override
  String get enterArmorSetName => 'Digite o nome do conjunto de armadura...';

  @override
  String get enterTalismanName => 'Digite o nome do talismã...';

  @override
  String get enterSkillName => 'Digite o nome da habilidade...';

  @override
  String get enterDecorationName => 'Digite o nome da decoração...';

  @override
  String get loadingWeapons => 'Carregando armas...';

  @override
  String get loadingItems => 'Carregando itens...';

  @override
  String get loadingArmorSets => 'Carregando conjuntos de armadura...';

  @override
  String get loadingTalismans => 'Carregando talismãs...';

  @override
  String get loadingDecorations => 'Carregando decorações...';

  @override
  String get noWeaponsFound => 'Nenhuma arma encontrada';

  @override
  String get noItemsFound => 'Nenhum item encontrado';

  @override
  String get noArmorSetsFound => 'Nenhum conjunto de armadura encontrado';

  @override
  String get noTalismansFound => 'Nenhum talismã encontrado';

  @override
  String get noSkillsFound => 'Nenhuma habilidade encontrada';

  @override
  String get noDecorationsFound => 'Nenhuma decoração encontrada';

  @override
  String get armorSlotHead => 'Cabeça';

  @override
  String get armorSlotChest => 'Peito';

  @override
  String get armorSlotArms => 'Braços';

  @override
  String get armorSlotWaist => 'Cintura';

  @override
  String get armorSlotLegs => 'Pernas';

  @override
  String get typeWeapon => 'Arma';

  @override
  String get typeArmor => 'Armadura';

  @override
  String get typeGroup => 'Grupo';

  @override
  String get typeSet => 'Set';

  @override
  String get weaponKindGreatSword => 'Espadão';

  @override
  String get weaponKindLongSword => 'Espada Longa';

  @override
  String get weaponKindSwordShield => 'Espada e Escudo';

  @override
  String get weaponKindDualBlades => 'Duplas-lâminas';

  @override
  String get weaponKindHammer => 'Martelo';

  @override
  String get weaponKindHuntingHorn => 'Berrante de Caça';

  @override
  String get weaponKindLance => 'Lança';

  @override
  String get weaponKindGunlance => 'Lançarma';

  @override
  String get weaponKindSwitchAxe => 'Transmachado';

  @override
  String get weaponKindChargeBlade => 'Lâmina Dínamo';

  @override
  String get weaponKindInsectGlaive => 'Glaive Inseto';

  @override
  String get weaponKindBow => 'Arco';

  @override
  String get weaponKindLightBowgun => 'Fuzilarco Leve';

  @override
  String get weaponKindHeavyBowgun => 'Fuzilarco Pesado';

  @override
  String get pieces => 'peças';

  @override
  String get defense => 'Defesa';

  @override
  String get baseDefense => 'Defesa base';

  @override
  String get slots => 'Encantos';

  @override
  String get resistances => 'Resistências';

  @override
  String get noSlots => 'Sem encantos';

  @override
  String get noResistances => 'Sem resistências';

  @override
  String get physicalDamage => 'Dano físico';

  @override
  String get affinity => 'Afinidade';

  @override
  String get sharpness => 'Nitidez';

  @override
  String get element => 'Elemento';

  @override
  String get statusEffect => 'Efeito de status';

  @override
  String get phial => 'Frasco';

  @override
  String get coatings => 'Revestimentos';

  @override
  String get shell => 'Casca';

  @override
  String get melody => 'Melodia';

  @override
  String get songs => 'canções';

  @override
  String get echoBubble => 'Bolha de eco';

  @override
  String get echoWave => 'Onda de eco';

  @override
  String get ammo => 'Munição';

  @override
  String get kinsect => 'Inseto';

  @override
  String get level => 'Nível';

  @override
  String campsOfLevel(int n) => 'Acampamentos do Nível $n';

  @override
  String get risk => 'Risco';

  @override
  String get zone => 'Zona';

  @override
  String get loadingMap => 'Carregando mapa...';

  @override
  String get noMapImagesFound => 'Nenhuma imagem do mapa encontrada';

  @override
  String get monsterInformation => 'Informações do Monstro';

  @override
  String get species => 'Espécie';

  @override
  String get description => 'Descrição';

  @override
  String get features => 'Características';

  @override
  String get huntingTips => 'Dicas de Caça';

  @override
  String get monsterVariants => 'Variantes do Monstro';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get baseHealth => 'Vida Base';

  @override
  String get sizeRange => 'Faixa de Tamanho';

  @override
  String get elements => 'Elementos';

  @override
  String get weaknessesAndResistances => 'Fraquezas e Resistências';

  @override
  String get weaknesses => 'Fraquezas';

  @override
  String get noKnownResistances => 'Nenhuma resistência conhecida';

  @override
  String get highRank => 'Alto Rank';

  @override
  String get lowRank => 'Baixo Rank';

  @override
  String get crownSizes => 'Tamanhos de Coroa';

  @override
  String get baseSize => 'Tamanho base';

  @override
  String get miniCrown => 'Coroa mini';

  @override
  String get silverCrown => 'Coroa de prata';

  @override
  String get goldCrown => 'Coroa de ouro';

  @override
  String get elementsAndAilments => 'Elementos e Afecções';

  @override
  String get monstersThatDropThisItem => 'Monstros que soltam este item:';

  @override
  String get dropConditions => 'Condições de queda:';

  @override
  String get craftingRecipe => 'Receita de Criação:';

  @override
  String get requiredMaterials => 'Materiais Necessários:';

  @override
  String get skillRanks => 'Níveis de Habilidade:';

  @override
  String get rank => 'Rank';

  @override
  String get errorLoadingSkills => 'Erro ao carregar habilidades';

  @override
  String get noSkillsAvailable => 'Nenhuma habilidade disponível';

  @override
  String get craftingMaterials => 'Materiais de Criação';

  @override
  String get craft => 'Criar';

  @override
  String get upgrade => 'Melhorar';

  @override
  String get defenseBonus => 'Bônus de Defesa';

  @override
  String get elderseal => 'Selos dos Antigos';

  @override
  String get lv => 'Nv';

  @override
  String get sharpnessRed => 'Vermelho';

  @override
  String get sharpnessOrange => 'Laranja';

  @override
  String get sharpnessYellow => 'Amarelo';

  @override
  String get sharpnessGreen => 'Verde';

  @override
  String get sharpnessBlue => 'Azul';

  @override
  String get sharpnessWhite => 'Branco';

  @override
  String get sharpnessPurple => 'Roxo';

  @override
  String get setBonus => 'Bônus do Set:';

  @override
  String get locationsLabel => 'Localizações:';

  @override
  String get breakableParts => 'Partes Quebráveis';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get unknownMap => 'Mapa Desconhecido';

  @override
  String get map => 'Mapa';
}
