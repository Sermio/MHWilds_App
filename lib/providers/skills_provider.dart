import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/skills_api.dart';
import 'package:mhwilds_app/models/skills.dart';

class SkillsProvider with ChangeNotifier {
  List<Skill2> _allSkills = [];
  List<Skill2> _filteredSkills = [];
  bool _isLoading = false;

  String _nameFilter = '';
  String _kindFilter = '';

  List<Skill2> get skills => _filteredSkills;
  bool get isLoading => _isLoading;
  bool get hasData => _allSkills.isNotEmpty;

  Future<void> fetchSkills() async {
    if (_allSkills.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allSkills = await SkillsApi.fetchSkills();
      _filteredSkills =
          List.from(_allSkills); // Copia para trabajar con el filtrado
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  void applyFilters({String? name, String? kind}) {
    // Actualizar los filtros solo si son proporcionados
    _nameFilter = name ?? _nameFilter;
    _kindFilter = kind ?? _kindFilter;

    _filteredSkills = _allSkills.where((skill) {
      final matchesName = _nameFilter.isEmpty ||
          skill.name
              .toLowerCase()
              .contains(_nameFilter.toLowerCase()); // Usamos `skill.name`

      final matchesKind = _kindFilter.isEmpty || skill.kind == _kindFilter;

      return matchesName && matchesKind;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _nameFilter = '';
    _kindFilter = '';
    _filteredSkills =
        List.from(_allSkills); // Reseteo de los filtros, sin cambios
    notifyListeners();
  }
}
