import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mhwilds_app/models/decoration.dart';

class DecoProvider extends ChangeNotifier {
  List<Deco> _decos = [];
  Map<String, Deco> _decoMap = {};

  List<Deco> get decos => _decos;
  Deco? getByName(String name) => _decoMap[name];

  Future<void> loadDecos() async {
    String jsonString =
        await rootBundle.loadString('assets/data/decorations_list.json');
    List<dynamic> jsonList = json.decode(jsonString);
    _decos = jsonList.map((json) => Deco.fromJson(json)).toList();
    _decoMap = {for (var deco in _decos) deco.name: deco};
    notifyListeners();
  }

  List<Deco> filterDecos(
      {String? name,
      String? type,
      String? rarity,
      String? slot,
      String? skill}) {
    return _decos.where((deco) {
      return (name == null ||
              deco.name.toLowerCase().contains(name.toLowerCase())) &&
          (type == null || deco.type == type) &&
          (rarity == null || deco.rarity == rarity) &&
          (slot == null || deco.slot == slot) &&
          (skill == null || _filterSkills(deco.skills, skill));
    }).toList();
  }

  // Función para filtrar las skills dentro de la lista de habilidades
  bool _filterSkills(List<Skill> skills, String skill) {
    return skills
        .any((s) => s.skillName.toLowerCase().contains(skill.toLowerCase()));
  }
}
