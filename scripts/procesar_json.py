import json
import re

# Definir manualmente las cabeceras de la tabla
headers = [
    "Material", "Frequency", "Target Rewards", "Break Part Rewards", "Carves", "Destroyed Wounds"
]

# JSON de entrada (simulando tu estructura)
raw_data = """

Guardian Scale\t\n\t20%\t100%\t50%\t45%\n\nGuardian Pelt\t\n \t20%\t100%(Left Chainblade)\n100%(Right Chainblade)\t30%\t43%\n\nGuardian Blood\t\n \t10%\t-\t20%\n100%(Tail)\t12%\n\nNourishing Extract\t\n \t30%\t-\t-\t-\n\nTough Guardian Bone\t\n \t20%\t-\t-\t-

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
