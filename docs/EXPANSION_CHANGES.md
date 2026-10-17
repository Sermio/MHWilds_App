# Preparar la app para la expansión (Rango Maestro)

Fecha: 2026-10-17 · Estado: análisis hecho, sin tareas ejecutadas.

Regla de partida: **rareza mayor que 8 = Rango Maestro**, para armas, armaduras y talismanes. No hace falta que la API traiga un campo de rango: se deduce de `rarity`. Los monstruos son la excepción, porque ya traen `rank` en sus recompensas.

---

## 1. Estado actual

| Tema | Estado | Dónde |
|------|--------|-------|
| Rango en monstruos (LR/HR/MR) | Listo: filtro, chips y recompensas por rango | `monsters_list.dart`, `monster_filter.dart` |
| Colores de rareza hasta 12 | Listo: 13 colores y `rarity()` con `clamp` | `game_colors.dart` |
| Sprite de armaduras, armas y talismanes por rareza | Listo: `gear.webp` tiene 13 filas (rareza 0–12) y `spriteRowForRarity` hace `clamp` | `gear_sprite_icon.dart` |
| Slots de gema de nivel 4 | Listo: icono, color y `displayLevel` hasta 4 | `decoration.dart`, `weapon_slots.dart` |
| Filtros de rareza | **Fijos en 1–8**: una rareza 9–12 no se podría filtrar | `weapon_filters.dart:120`, `armor_set_filters.dart:109`, `talismans_list.dart:380`, `items_list.dart:268` |
| Filtro por rango en armas, armaduras y talismanes | **No existe** | — |
| Afilado | **7 campos fijos** (red a purple); un nivel nuevo se ignoraría | `Sharpness` en `weapon.dart`, `sharpness_bar.dart` |
| `getKindImage` | Usa `rarity8.webp` fijo | `asset_paths.dart` |
| `getJewelSlotIcon` | Código muerto con rutas `.png` que ya no existen | `asset_paths.dart` |

Pendiente de verificar con la API real cuando salgan los datos: que los sets de armadura mezclen piezas de una misma rareza, que el afilado llegue con un campo nuevo y si hay talismanes de rareza > 8.

---

## 2. Decisión de diseño: rango derivado de la rareza

Una sola función, en un solo sitio, decide el rango. Todo lo demás (filtros, chips) la usa.

```dart
enum GearRank { low, high, master }

GearRank gearRankForRarity(int rarity) => switch (rarity) {
      <= 4 => GearRank.low,   // ver nota
      <= 8 => GearRank.high,
      _ => GearRank.master,
    };
```

- **Nota:** el límite entre rango bajo y alto (`<= 4`) es una suposición; **no está confirmado**. Si el filtro solo ofrece «Maestro» (rareza > 8) frente a «Resto», la suposición no hace falta. Lo más simple y seguro es empezar por esa opción de dos valores.
- Ponerla en `lib/utils/` con su test: 8 es alto, 9 es maestro, 12 es maestro, 0 y negativos no rompen.
- Etiquetas traducidas para el chip y el filtro (ARB, 10 idiomas). Los monstruos ya tienen `lowRank`, `highRank` y `masterRank`: reutilizarlos.

---

## 3. Tareas

Reglas comunes (ya están en `CLAUDE.md`): no quitar funcionalidades, reutilizar componentes, `flutter analyze` sin avisos, tests en verde y un test por cada cambio de comportamiento. Una tarea = una rama = un PR contra `develop`.

#### T42 · Rarezas dinámicas en los filtros
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md y docs/EXPANSION_CHANGES.md. Los filtros de rareza usan la lista fija `[1..8]` en `weapon_filters.dart`, `armor_set_filters.dart`, `talismans_list.dart` e `items_list.dart`. Crea un helper compartido que reciba las rarezas presentes en los datos y devuelva las opciones (de la mínima a la máxima, sin huecos inventados), y úsalo en los cuatro sitios. Con los datos actuales el resultado debe ser idéntico (1–8). Tests: con rarezas 1–8, 1–12 y lista vacía.

#### T43 · Rango derivado de la rareza y filtro por rango
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T42
- **Prompt:**
  > Lee CLAUDE.md y la sección 2 de docs/EXPANSION_CHANGES.md. Crea `GearRank` y `gearRankForRarity` en `lib/utils/` (rareza > 8 = maestro). Añade a `WeaponFilter`, `ArmorSetFilter` y `AmuletFilter` un campo `rank` y un desplegable (`ListFilterFieldConfig.select`) con las etiquetas traducidas que ya usa el filtro de monstruos; `provider.filter` sigue siendo la única fuente. Un set de armadura se filtra por la rareza de sus piezas. Con el filtro vacío, el comportamiento actual no cambia. Reutiliza el chip de rango de monstruos extrayéndolo a un componente compartido (hoy está sin tema, con `Colors.blue[400]` y similares) y muéstralo en las tarjetas de arma, set y talismán cuando el rango sea maestro. Tests: la función de rango con casos límite, los filtros puros y que el filtro se conserva al volver a la sección.

#### T44 · Afilado como lista de niveles
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** ver un JSON real con el afilado nuevo
- **Prompt:**
  > Lee CLAUDE.md y docs/EXPANSION_CHANGES.md. `Sharpness` tiene 7 campos fijos y `SharpnessBar` un `if` por color. Cambia el modelo a una lista ordenada de niveles (clave, valor) leída del JSON, conservando el orden y los colores actuales, y haz que `SharpnessBar` y `GameColors` salgan de esa lista. Un nivel desconocido debe pintarse con un color neutro y no romperse. Actualiza los usos (`weapon_card.dart`, `weapon_sharpness_section.dart`, `weapon_tree_*`). Tests: parseo con el fixture actual (mismo resultado visual), con un nivel extra inventado y con el campo ausente.

#### T45 · Limpieza de iconos y robustez de slots
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. Confirma con grep que nadie llama a `getJewelSlotIcon` (definida en `lib/utils/asset_paths.dart`) y bórrala. Haz que `getKindImage` no dependa de `rarity8.webp` fijo si existe un asset por rareza; si no existe, déjalo como está y anótalo. En `Decoration.displayLevel`, amplía el rango de slots de `1..4` a una constante con nombre (`maxSlotLevel`) usada también por `weapon_slots.dart` y por el fallback de `DecorationImage`. Sin cambios visuales.

---

## 4. Orden y comprobaciones

```
T42 → T43 · T45 (en paralelo) · T44 (cuando haya JSON real)
```

- **Antes de publicar la expansión:** abrir cada lista con un fixture que incluya rarezas 9–12 y confirmar que se ven bien (colores, sprite y filtro).
- **Test de sprites:** para cada rareza de 0 a 12 debe existir fila en `gear.webp`. Si la expansión sube de 12, `spriteRowForRarity` haría `clamp` y mostraría el icono equivocado sin avisar.
- **Anuncio:** cuando salga la expansión, añadir uno en `announcements/announcements.json` (ver [ANUNCIOS.md](ANUNCIOS.md)).
