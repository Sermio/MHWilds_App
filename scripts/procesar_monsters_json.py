import json
import re

# Datos de entrada
raw_data = """
AJARAKAN\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFanged Beast\nElements\t\nFire\nAilments\t\nFireblight\nWeakness\t\nWater\n\nIce\nResistances\t\nFire\nLocation(s)\t\nOilwell Basin\n\nRuins of Wyveria;

ARKVELD\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFlying Wyvern\nElements\t\nDragon\nAilments\t\nDragonblight\nWeakness\t\nDragon\nResistances\tNone\nLocation(s)\t\nWindward Plains\n\nScarlet Forest\n\nOilwell Basin\n\nIceshard Cliffs\n\nRuins of Wyveria;

BALAHARA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nLeviathan\nElements\t\nWater\nAilments\t\nWaterblight\nWeakness\t\nThunder\nResistances\t\nWater\nLocation(s)\t\nWindward Plains;

BLANGONGA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFanged Beast\nElements\t\nIce\nAilments\t\nIceblight\nWeakness\t\nFire\n\nThunder\nResistances\t \nIce\n\nDragon\nLocation(s)\t\nIceshard Cliffs;

CHATACABRA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nAmphibian\nElements\t--\nAilments\t--\nWeakness\t\nIce\n\nThunder\nResistances\t\nDragon\nLocation(s)\t\nWindward Plains;

CONGALALA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFanged Beast\nElements\t\nBlast\n\nPoison\n\nAilments\t\nBlastblight\n\nPoison\nWeakness\t\nFire\nResistances\tTBC\nLocation(s)\t\nScarlet Forest\n\nRuins of Wyveria;

DOSHAGUMA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFanged Beast\nElements\t\nBlast\nAilments\t\nBlastblight\nWeakness\t\nFire\nResistances\tNone\nLocation(s)\t\nWindward Plains\n\nScarlet Forest\n\nRuins of Wyveria;

GORE MAGALA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nDemi Elder\nElements\tTBC\nAilments\tFrenzy Virus\nWeakness\t\nFire\nResistances\t\nWater\nLocation(s)\t\nIceshard Cliffs;

GRAVIOS\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFlying Wyvern\nElements\t\nFire\nAilments\t\nFireblight\nWeakness\t\nWater\n\nIce\n\nDragon\nResistances\t\nFire\nLocation(s)\t\nOilwell Basin\n\nRuins of Wyveria;

GUARDIAN ARKVELD\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\t\nDragon\nAilments\t\nDragonblight\nWeakness\t\nDragon\nResistances\tTBC\nLocation(s)\t\nRuins of Wyveria;

GUARDIAN DOSHAGUMA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\tTBC\nAilments\tTBC\nWeakness\t\n\nIce\n\n\nResistances\tTBC\nLocation(s)\t\nRuins of Wyveria;

GUARDIAN EBONY ODOGARON\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\tTBC\nAilments\t\nBleeding\nWeakness\t\nWater\nResistances\tTBC\nLocation(s)\t\nRuins of Wyveria;

GUARDIAN FULGUR ANJANATH\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\t\nThunder\nAilments\t\nThunderblight\nWeakness\t\nIce\n\nWater\n\nDragon\n\nResistances\tTBC\nLocation(s)\t\nRuins of Wyveria;

GUARDIAN RATHALOS\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\t\nFire\nAilments\t\nFireblight\n\nPoison\n\nWeakness\t\nThunder\n\nDragon\nResistances\t\nFire\nLocation(s)\t\nRuins of Wyveria;

GYPCEROS\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nBird Wyvern\nElements\tNone\nAilments\t\nPoison\nWeakness\t\nFire\nResistances\tNone\nLocation(s)\t\nWindward Plains\n\nOilwell Basin\n\nIceshard Cliffs\n\nRuins of Wyveria;

HIRABAMI\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nLeviathan\nElements\t\nIce\nAilments\t\nFrostblight\nWeakness\t\n\nFire\n\nThunder\n\n\nResistances\t\nIce \nLocation(s)\t\nIceshard Cliffs\n\nRuins of Wyveria;

JIN DAHAAD\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nLeviathan\nElements\t\nIce\nAilments\t\n\nIceblight\n\nFrostblight\n\n\nWeakness\t\nFire\n\nResistances\t\nIce\nLocation(s)\t\nIceshard Cliffs;

LALA BARINA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nTemnoceran\nElements\tTBC\nAilments\t\nParalysis\nWeakness\t\nFire\nResistances\t\nWater\n\nDragon\nLocation(s)\t\nScarlet Forest\n\nRuins of Wyveria;

NERSCYLLA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nTemnoceran\nElements\tNone\nAilments\t\nPoison\n\nSleep\n\nWebbed\nWeakness\t\nFire\n\n\nResistances\t\nWater\n\nDragon\nLocation(s)\t\nOilwell Basin\n\nIceshard Cliffs\n\nRuins of Wyveria;

NU UDRA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nCephalopod\nElements\t\nFire\nAilments\t\nFireblight\nWeakness\t\nWater\nResistances\t\nFire\nLocation(s)\t\nOilwell Basin;

QUEMATRICE\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nBrute Wyvern\nElements\t\nFire\nAilments\t\nFireblight\nWeakness\t\nWater\nResistances\t\nFire\nLocation(s)\t\nWindward Plains\n\nRuins of Wyveria;

RATHALOS\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFlying Wyvern\nElements\t\nFire\nAilments\t\nFireblight\n\nPoison\n\nWeakness\t\nDragon\nResistances\t\nFire\nLocation(s)\t\nScarlet Forest\n\nOilwell Basin\n\nRuins of Wyveria;

RATHIAN\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFlying Wyvern\nElements\t\nFire\nAilments\t\nFireblight\n\nPoison\nWeakness\t\nDragon\nResistances\t\nFire\nLocation(s)\t\nWindward Plains\n\nScarlet Forest\n\nOilwell Basin;

REY DAU\n\n \n\n\nEnemy Type\tLarge Monster\nSpecies\t\nFlying Wyvern\nElements\t\nThunder\nAilments\t\nThunderblight\nWeakness\t\nIce\nResistances\t\nThunder\nLocation(s)\t\nWindward Plains;

ROMPOPOLO\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nBrute Wyvern\nElements\tNone\nAilments\t\nPoison\nWeakness\t\nWater\nResistances\t\nPoison\nLocation(s)\t\nOilwell Basin;

UTH DUNA\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nLeviathan\nElements\t\nWater\nAilments\t\nWaterblight\nWeakness\t\nThunder\nResistances\t\nWater\nLocation(s)\t\nScarlet Forest;

XU WU\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nCephalopod\nElements\t\nDragon\nAilments\tNone\nWeakness\t\nIce\nResistances\t\nDragon\nLocation(s)\t\nRuins of Wyveria;

YIAN KUT-KU\n\n\n\nEnemy Type\tLarge Monster\nSpecies\t\nBird Wyvern\nElements\t\nFire\nAilments\tNone\nWeakness\t\nThunder\n\nIce\n\nResistances\t\nDragon\nLocation(s)\t\nScarlet Forest\n\nIceshard Cliffs;

ZOH SHIA\n\n\n \n\nEnemy Type\tLarge Monster\nSpecies\t\nConstruct\nElements\tTBC\nAilments\t\nFireblight\n\nThunderblight\nWeakness\t\nDragon\nResistances\tNone\nLocation(s)\t\nRuins of Wyveria;

"""

# Expresiones regulares para extraer la información
patterns = {
    "monsterName": r"^(.*?)\n\n\n\n",
    "monsterType": r"Enemy Type\t(.*?)\n",
    "monsterSpecie": r"Species\t\n(.*?)\n",
    "element": r"Elements\t\n(.*?)\n",
    "ailment": r"Ailments\t\n(.*?)\n",
    "weaknesses": r"Weakness\t\n(.*?)(?:\n\n|\nResistances)",
    "resistances": r"Resistances\t\n(.*?)\n",
    "locations": r"Location\(s\)\t\n(.*)"
}

# Separar las entradas de monstruos por ";"
monster_entries = raw_data.strip().split(";")

monsters_data = []

for entry in monster_entries:
    entry = entry.strip()
    if not entry:
        continue  # Saltar entradas vacías

    monster_data = {}

    for key, pattern in patterns.items():
        match = re.search(pattern, entry, re.DOTALL)
        if match:
            value = match.group(1).strip()
            # Convertir a lista si hay múltiples valores separados por saltos de línea
            if key in ["element", "ailment", "weaknesses", "resistances", "locations"]:
                monster_data[key] = [v.strip() for v in value.split("\n") if v.strip()]
            else:
                monster_data[key] = value
        else:
            monster_data[key] = None  # Si no se encuentra, asignar None

    monsters_data.append(monster_data)

# Convertir a JSON formateado
formatted_json = json.dumps(monsters_data, indent=4, ensure_ascii=False)

# Mostrar el resultado
print(formatted_json)