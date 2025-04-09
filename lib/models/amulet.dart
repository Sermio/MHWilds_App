class Amulet {
  final List<AmuletRank> ranks;
  final int id;
  final int gameId;

  Amulet({
    required this.ranks,
    required this.id,
    required this.gameId,
  });

  factory Amulet.fromJson(Map<String, dynamic> json) {
    return Amulet(
      ranks: json['ranks'] != null
          ? (json['ranks'] as List).map((e) => AmuletRank.fromJson(e)).toList()
          : [],
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
    );
  }
}

class AmuletRank {
  final AmuletReference amulet;
  final String name;
  final String description;
  final int level;
  final int rarity;
  final List<AmuletSkill> skills;
  final Crafting crafting;
  final int id;

  AmuletRank({
    required this.amulet,
    required this.name,
    required this.description,
    required this.level,
    required this.rarity,
    required this.skills,
    required this.crafting,
    required this.id,
  });

  factory AmuletRank.fromJson(Map<String, dynamic> json) {
    return AmuletRank(
      amulet: json['amulet'] != null
          ? AmuletReference.fromJson(json['amulet'])
          : AmuletReference(id: 0),
      name: json['name'] ?? "Unknown",
      description: json['description'] ?? "No description",
      level: json['level'] ?? 0,
      rarity: json['rarity'] ?? 0,
      skills: json['skills'] != null
          ? (json['skills'] as List)
              .map((e) => AmuletSkill.fromJson(e))
              .toList()
          : [],
      crafting: json['crafting'] != null
          ? Crafting.fromJson(json['crafting'])
          : Crafting(
              amuletRank: AmuletRankReference(id: 0),
              craftable: false,
              materials: [],
              zennyCost: 0,
              id: 0),
      id: json['id'] ?? 0,
    );
  }
}

class AmuletReference {
  final int id;

  AmuletReference({required this.id});
  factory AmuletReference.fromJson(Map<String, dynamic> json) {
    return AmuletReference(id: json['id'] ?? 0);
  }
}

class AmuletSkill {
  final SkillReference skill;
  final int level;
  final String description;
  final int id;

  AmuletSkill({
    required this.skill,
    required this.level,
    required this.description,
    required this.id,
  });
  factory AmuletSkill.fromJson(Map<String, dynamic> json) {
    return AmuletSkill(
      skill: json['skill'] != null
          ? SkillReference.fromJson(json['skill'])
          : SkillReference(id: 0, name: "Unknown"),
      level: json['level'] ?? 0,
      description: json['description'] ?? "No description",
      id: json['id'] ?? 0,
    );
  }
}

class SkillReference {
  final int id;
  final String name;

  SkillReference({required this.id, required this.name});

  factory SkillReference.fromJson(Map<String, dynamic> json) {
    return SkillReference(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
    );
  }
}

class Crafting {
  final AmuletRankReference amuletRank;
  final bool craftable;
  final List<CraftingMaterial> materials;
  final int zennyCost;
  final int id;

  Crafting({
    required this.amuletRank,
    required this.craftable,
    required this.materials,
    required this.zennyCost,
    required this.id,
  });

  factory Crafting.fromJson(Map<String, dynamic> json) {
    return Crafting(
      amuletRank: json['amuletRank'] != null
          ? AmuletRankReference.fromJson(json['amuletRank'])
          : AmuletRankReference(id: 0),
      craftable: json['craftable'] ?? false,
      materials: json['materials'] != null
          ? (json['materials'] as List)
              .map((e) => CraftingMaterial.fromJson(e))
              .toList()
          : [],
      zennyCost: json['zennyCost'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}

class AmuletRankReference {
  final int id;

  AmuletRankReference({required this.id});

  factory AmuletRankReference.fromJson(Map<String, dynamic> json) {
    return AmuletRankReference(id: json['id'] ?? 0);
  }
}

class CraftingMaterial {
  final Item item;
  final int quantity;
  final int id;

  CraftingMaterial({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory CraftingMaterial.fromJson(Map<String, dynamic> json) {
    return CraftingMaterial(
      item: json['item'] != null
          ? Item.fromJson(json['item'])
          : Item(
              id: 0,
              gameId: 0,
              rarity: 0,
              name: "Unknown",
              description: "No description",
              value: 0,
              carryLimit: 0,
              recipes: [],
            ),
      quantity: json['quantity'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}

class Item {
  final int id;
  final int gameId;
  final int rarity;
  final String name;
  final String description;
  final int value;
  final int carryLimit;
  final List<Recipe> recipes;

  Item({
    required this.id,
    required this.gameId,
    required this.rarity,
    required this.name,
    required this.description,
    required this.value,
    required this.carryLimit,
    required this.recipes,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      gameId: json['gameId'] ?? 0,
      rarity: json['rarity'] ?? 0,
      name: json['name'] ?? "Unknown",
      description: json['description'] ?? "No description",
      value: json['value'] ?? 0,
      carryLimit: json['carryLimit'] ?? 0,
      recipes: json['recipes'] != null
          ? (json['recipes'] as List).map((e) => Recipe.fromJson(e)).toList()
          : [],
    );
  }
}

class Recipe {
  final Output output;
  final int amount;
  final List<RecipeInput> inputs;
  final int id;

  Recipe({
    required this.output,
    required this.amount,
    required this.inputs,
    required this.id,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      output: json['output'] != null
          ? Output.fromJson(json['output'])
          : Output(id: 0),
      amount: json['amount'] ?? 0,
      inputs: json['inputs'] != null
          ? (json['inputs'] as List)
              .map((e) => RecipeInput.fromJson(e))
              .toList()
          : [],
      id: json['id'] ?? 0,
    );
  }
}

class Output {
  final int id;

  Output({required this.id});

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(id: json['id'] ?? 0);
  }
}

class RecipeInput {
  final String name;
  final int id;

  RecipeInput({
    required this.name,
    required this.id,
  });

  factory RecipeInput.fromJson(Map<String, dynamic> json) {
    return RecipeInput(
      name: json['name'] ?? "Unknown",
      id: json['id'] ?? 0,
    );
  }
}
