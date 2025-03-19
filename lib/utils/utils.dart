import 'package:http/http.dart' as http;

Future<String?> getSkillUrl(String skillName, int slot, int skillLevel) async {
  // Encontramos la posición de la palabra 'jewel' (sin distinguir mayúsculas/minúsculas)
  int jewelIndex = skillName.toLowerCase().indexOf('jewel');

  // Encontramos la posición de la barra '/'
  int slashIndex = skillName.indexOf('/');

  // Contamos la cantidad de "I", "II" o "III" en el skillName
  int numberOfIs = countRomanNumerals(skillName);

  // Variable para guardar la parte de "I", "II" o "III"
  String fillIs = "";

  // Encontramos la posición mínima entre la palabra 'jewel' y la barra '/'
  int cutIndex = -1;
  if (jewelIndex != -1 && slashIndex != -1) {
    cutIndex = jewelIndex < slashIndex
        ? jewelIndex
        : slashIndex; // Usamos la posición más cercana
  } else if (jewelIndex != -1) {
    cutIndex = jewelIndex;
  } else if (slashIndex != -1) {
    cutIndex = slashIndex;
  }

  // Si encontramos "jewel" o "/", cortamos el nombre antes de ella
  String baseSkillName = cutIndex != -1
      ? skillName.substring(0, cutIndex).trim().toLowerCase()
      : skillName.trim().toLowerCase();

  // Asignamos el valor de "I", "II" o "III" basado en el número de 'I'
  if (numberOfIs == 2) {
    fillIs = "ii";
  } else if (numberOfIs == 3) {
    fillIs = "iii";
  }

  if (skillLevel == 2) {
    fillIs = "ii";
  } else if (skillLevel == 3) {
    fillIs = "iii";
  }

  // Creamos las posibles variaciones de URL
  List<String> urlVariations = [
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_decoration__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_decoration_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}__mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}jewel_${fillIs}_${slot}_mhwilds_wiki_guide.png",
    "https://monsterhunterwilds.wiki.fextralife.com/file/Monster-Hunter-Wilds/${baseSkillName}_jewel_${fillIs}_${slot}_mhwilds_wiki_guide.png",
  ];

  // Intentamos obtener la URL válida
  for (String url in urlVariations) {
    final response = await http.head(Uri.parse(url));

    if (response.statusCode == 200) {
      return url;
    }
  }

  // Si no encontramos ninguna URL válida, retornamos null
  return null;
}

int countRomanNumerals(String skillName) {
  // Expresión regular para encontrar ' I', ' II' o ' III' con un espacio antes
  RegExp regExp = RegExp(r'(?<=\s)I{1,3}(?=\s|$)');

  // Buscamos coincidencias y devolvemos la cantidad de veces que encontramos 'I', 'II' o 'III'
  Match? match = regExp.firstMatch(skillName);
  if (match != null) {
    return match.group(0)!.length; // La cantidad de 'I' en la coincidencia
  }
  return 0; // Si no hay coincidencias, retorna 0
}
