import json
import re

# Definir manualmente las cabeceras de la tabla
headers = [
    "Material", "Frequency", "Target Rewards", "Break Part Rewards", "Carves", "Destroyed Wounds"
]

# JSON de entrada (simulando tu estructura)
raw_data = """

Kut-Ku Scale +\t\n\t20%\t -\t30%\t50%\n\nKut-Ku Carapace\t\n \t20%\t- \t23%\t50%\n\nKut-Ku Ear\t\n \t8%\t100% (Head)\t13%\t-\n\nKut-Ku Wing\t\n \t15%\t-\t18%\t-\n\nInferno Sac\t\n \t18%\t-\t-\t-\n\nYian Kut-Ku Certificate S\t\n \t8%\t-\t-\t-\n\nGiant Beak\t\n\t8%\t-\t11%\t-\n\nBird Wyvern Gem\t\n\t3%\t-\t5%\t-


"""


# Separar líneas respetando los saltos dobles como separadores de objetos
entries = raw_data.split("\n\n")
formatted_data = []

for entry in entries:
    # Limpiar y separar las líneas dentro de cada entrada
    lines = [line.strip() for line in entry.split("\n\n") if line.strip()]
    current_entry = dict.fromkeys(headers, "-")
    
    for line in lines:
        # Separar por tabuladores
        values = re.split(r'\t+', line)
        values = [v.strip() if v else "-" for v in values]  # Eliminar cualquier espacio adicional y sustituir por "-"
        
        # Asegurarse de que no se estén asignando saltos de línea "\n" en lugar de los valores correctos
        for i in range(len(values)):
            if values[i] and values[i] != "\n":  # Verificar que no sea un salto de línea
                current_entry[headers[i]] = values[i]
    
    formatted_data.append(current_entry)

# Convertir a JSON formateado
formatted_json = json.dumps(formatted_data, indent=4, ensure_ascii=False)

# Mostrar el resultado
print(formatted_json)
