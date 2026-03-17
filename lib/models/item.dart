class Item {
  final int id;
  final int gameId;
  final int rarity;
  final String name;
  final String description;
  final int value;
  final int carryLimit;
  final List<Recipe> recipes;
  final ItemIcon? icon;

  Item({
    required this.id,
    required this.gameId,
    required this.rarity,
    required this.name,
    required this.description,
    required this.value,
    required this.carryLimit,
    required this.recipes,
    this.icon,
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
      icon: json['icon'] != null ? ItemIcon.fromJson(json['icon']) : null,
    );
  }
}

class ItemIcon {
  final int id;
  final String kind;
  final int colorId;
  final String color;

  ItemIcon({
    required this.id,
    required this.kind,
    required this.colorId,
    required this.color,
  });

  factory ItemIcon.fromJson(Map<String, dynamic> json) {
    return ItemIcon(
      id: json['id'] ?? 0,
      kind: json['kind'] ?? '',
      colorId: json['colorId'] ?? 0,
      color: json['color'] ?? '',
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
