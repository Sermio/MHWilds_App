class Amulet {
  final Map<String, String> names;
  final Map<String, String> descriptions;
  final int rarity;
  final int level;
  final int price;
  final Map<String, int> skills;
  final Recipe recipe;

  Amulet({
    required this.names,
    required this.descriptions,
    required this.rarity,
    required this.level,
    required this.price,
    required this.skills,
    required this.recipe,
  });

  factory Amulet.fromJson(Map<String, dynamic> json) {
    return Amulet(
      names: Map<String, String>.from(json['names']),
      descriptions: Map<String, String>.from(json['descriptions']),
      rarity: json['rarity'],
      level: json['level'],
      price: json['price'],
      skills: Map<String, int>.from(json['skills']),
      recipe: Recipe.fromJson(json['recipe']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'descriptions': descriptions,
      'rarity': rarity,
      'level': level,
      'price': price,
      'skills': skills,
      'recipe': recipe.toJson(),
    };
  }
}

class Recipe {
  final Map<String, int> inputs;

  Recipe({required this.inputs});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      inputs: Map<String, int>.from(json['inputs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inputs': inputs,
    };
  }
}
