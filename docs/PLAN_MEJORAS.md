# MHWilds App — Plan de mejoras

Fecha: 2026-10-16 · Rama base: `develop` · Versión analizada: 1.7.1+37

Plan para mejorar rendimiento, diseño y arquitectura **sin quitar ninguna funcionalidad**. Se mantienen las 10 secciones del drawer, los 7 idiomas, el tema claro/oscuro, los WebViews (Build Optimizer y Build Crafter), el aviso de actualización y la petición de reseña.

La segunda mitad del documento (sección 9) divide el trabajo en tareas pequeñas. Cada una lleva su prompt, el modelo recomendado y el nivel de razonamiento.

---

## 1. Resumen

| # | Problema | Mejora | Impacto |
|---|----------|--------|---------|
| 1 | El arranque no muestra nada hasta que acaban 4 descargas completas, solo para sacar nombres en inglés | Quitar `EnNamesCache` y usar un mapa `id → asset` | Alto |
| 2 | No hay timeout ni caché en disco; sin conexión no se ve nada | `ApiClient` compartido + caché en disco que se valida con `/version` | Alto |
| 3 | Los errores se tragan con `print`; si no hay conexión, la lista dice "no se encontraron monstruos" | Estado `LoadState` + vista de error con Reintentar | Alto |
| 4 | 51 MB de assets, casi todo PNG (mapas 20 MB, iconos 20 MB) | Pasarlos a WebP | Alto |
| 5 | El dorado sobre blanco tiene un contraste de 2,41:1, y la paleta no define `secondary`/`tertiary` | Paleta con `fromSeed`, conservando el dorado | Medio |
| 6 | Hay 306 `Text` y solo 17 tienen `overflow`; ninguna pantalla se ha probado con texto grande | Arnés de tests de overflow y corrección | Medio |
| 7 | Hay unas 5.700 líneas muertas: datos, componentes y helpers | Borrarlas | Medio |
| 8 | El único widget test es el del contador de la plantilla | Tests de modelos, filtros, providers y overflow, más CI | Alto (habilita el resto) |

---

## 2. Datos offline sin quedarse con datos viejos

**Duda:** si guardamos los datos para usarlos sin conexión, ¿cómo nos enteramos de que hay datos nuevos en la API?

**Respuesta:** la API trae dos mecanismos pensados justo para esto. Los he probado contra el servidor real:

- `GET https://wilds.mhdb.io/version` devuelve la fecha de la última importación de datos (ahora `2026-04-15T01:28:18+00:00`). Pesa unos 50 bytes. Si la versión guardada coincide, la caché está al día.
- Si se envía `If-Modified-Since: <fecha de la caché>`, el servidor responde `304 Not Modified` cuando no hay cambios. Comprobado: con la fecha de hoy devuelve 304 y con una fecha de 2024 devuelve 200.
- Cloudflare manda `Cache-Control: public, max-age=14400` (4 horas).

**Estrategia propuesta (stale-while-revalidate):**

1. **Al abrir una sección**, se muestran al instante los datos guardados para el idioma actual, si los hay.
2. **En segundo plano**, la app pide `/version` como mucho una vez por arranque, y otra al volver a primer plano si han pasado más de 4 h.
   - Si la versión es la misma, no se hace nada más.
   - Si es más nueva, se vuelve a pedir el endpoint con `If-Modified-Since`. Con un 200, se guarda la respuesta y la lista se refresca sola. Con un 304, solo se actualiza la fecha.
3. **Pull-to-refresh** fuerza la petición aunque la versión no haya cambiado. Es la salida manual para el usuario.
4. **Sin conexión**, se usa la caché y aparece un aviso discreto: "Sin conexión · datos del 12/10".
5. **Sin conexión y sin caché**, se muestra la vista de error con Reintentar.

**Detalles:**

- Se guarda el **JSON crudo** de la API, no los modelos. Así, si una actualización de la app cambia un `fromJson`, la caché sigue sirviendo.
- La clave de caché es `idioma/endpoint`, y se guardan además metadatos: `version` y `fetchedAt`.
- Almacenamiento: un archivo por endpoint en el directorio de soporte de la app (`path_provider`). `SharedPreferences` no vale para JSON de 2,5 MB.
- El idioma deja de requerir invalidaciones manuales: cada idioma tiene su propia caché.

---

## 3. ¿Paginación y filtros de la API?

**Veredicto:** no conviene paginar. Sí conviene usar dos funciones concretas de la API: la proyección `p` y el filtro `q` con `$in`.

Mediciones reales (`/en/…`, octubre de 2026). `dart:io` envía `Accept-Encoding: gzip` por defecto, así que lo que se descarga de verdad es la columna gzip:

| Endpoint | Elementos | JSON | gzip | Primera carga |
|----------|----------:|-----:|-----:|--------------:|
| weapons | 1.188 | 2.547 KB | 340 KB | 4,4 s |
| armor/sets | 194 | 1.758 KB | 202 KB | 3,3 s |
| armor | 714 | 1.490 KB | 172 KB | 3,5 s |
| monsters | 34 | 453 KB | 65 KB | 1,4 s |
| charms | 64 | 284 KB | 45 KB | 1,4 s |
| items | 773 | 207 KB | 40 KB | 0,8 s |
| decorations | 361 | 156 KB | 16 KB | 0,9 s |
| skills | 179 | 94 KB | 16 KB | 0,6 s |
| locations | 5 | 8 KB | 2 KB | 0,3 s |

Por qué no paginar:

- El catálogo entero ocupa unos 900 KB comprimidos. Con la caché de la sección 2 se descarga una vez por versión de datos, no en cada arranque.
- Los filtros en local responden al momento. Con paginación, cada cambio de filtro o cada scroll es una petición nueva con su latencia.
- El modo offline necesita la lista completa.
- Hay pantallas que cruzan datos entre listas (`itemsById` en recetas, recompensas de monstruos, skills de armaduras) y necesitan el conjunto entero.
- El ahorro es pequeño: 10 monstruos ya pesan 134 KB, porque cada monstruo es un objeto grande.

Qué sí usar de la API:

| Caso | Hoy | Con la API | Ganancia |
|------|-----|------------|----------|
| Nombres en inglés (`EnNamesCache`) | `/items` completo, 207 KB | `?p={"id":true,"name":true}`, 27 KB | 87 % menos. Además, la tarea T27 propone quitar esta caché del todo |
| Skills de una armadura o arma | N peticiones `/skills/{id}` en serie | `?q={"id":{"$in":[…]}}`, 1 petición (comprobado) | De N viajes a 1 |
| Armas por tipo (opcional) | `/weapons` completo, 4,4 s la primera vez | `?q={"kind":"great-sword"}` | Solo si la primera carga molesta; con caché probablemente no hace falta |

---

## 4. ¿Bloc u otro gestor de estado?

**Decisión: seguir con Provider.** Con un estado de carga tipado y un provider base común es suficiente.

| | Provider (actual) | Bloc / Cubit | Riverpod |
|---|---|---|---|
| Encaje con la app | Catálogo de solo lectura: cargar, filtrar, mostrar | Brilla con flujos de eventos complejos, que esta app no tiene | Muy bueno: `AsyncValue`, `family` por id, caché integrada |
| Coste de migrar | 0 | Alto: unos 3 archivos por entidad (eventos, estados, bloc) en 8 entidades y 20 pantallas | Alto: hay que tocar todas las pantallas |
| Testabilidad | Buena si la lógica sale a repositorios y funciones puras | Muy buena | Muy buena |
| Riesgo de regresiones | Bajo | Alto | Alto |

Lo que hoy duele no es Provider. Es la falta de capa de datos (sin caché ni timeouts), los 8 providers copiados y pegados, y los filtros repartidos entre la pantalla y el provider. Todo eso se arregla dentro de Provider (tareas T15–T17 y T24–T25).

Si algún día se añaden flujos con estado real, como un constructor de builds propio con deshacer y comparar, Riverpod sería la evolución natural antes que Bloc.

---

## 5. Imágenes de fextralife: comprobación

Tenías casi razón: **ya no se usan en el flujo normal**, pero quedan como fallback y como código muerto.

| Sitio | Estado |
|-------|--------|
| `components/armor_piece_image.dart` (`Image.network` de fextralife) | Muerto: nadie lo importa |
| `components/skill_item.dart` → `url_image_loader.dart` → `getValidSkillImageUrl` | Muerto: solo aparece en código comentado de `decoration_details.dart`. La imagen de error del loader también carga una imagen de fextralife |
| `utils.dart`: `getSkillUrl`, `isGrayScaleFromUrl`, `getValidMonsterImageUrl` | Muertos: sin llamadas. `isGrayScaleFromUrl` es lo único que usa el paquete `image` |
| `components/material_image.dart` → `getValidItemImageUrl` | **Vivo como fallback.** Si `item` es `null` o su icono no se resuelve a un asset local, lanza hasta 6 peticiones `HEAD` a fextralife. Puede ocurrir en `items_list.dart:415` con `itemsById[recipeItem.id]` |

Además, `EnNamesCache`, que bloquea el arranque, ya no sirve para fextralife. Hoy solo traduce `id → nombre en inglés` para construir rutas de assets locales (`monster_icons/<nombre>.png`, `maps/<nombre>/…`) y para el fallback de `MaterialImage`. Un mapa `id → asset` generado una sola vez lo sustituye por completo (tarea T27).

---

## 6. Diseño: paleta, componentes y overflow

Se mantiene la identidad actual: dorado `#C3A35D` sobre superficies neutras, tarjetas redondeadas e iconos del juego. Las búsquedas de paletas genéricas de juegos no encajaban con esta identidad, así que la propuesta parte del dorado actual y corrige el contraste.

### 6.1 Paleta

| Combinación | Contraste | Mínimo | Estado |
|-------------|----------:|-------:|--------|
| Texto `black87` sobre dorado (AppBar, botones) | 7,55:1 | 4,5:1 | OK |
| Dorado sobre blanco (bordes de input, iconos, texto dorado) | 2,41:1 | 3:1 iconos y bordes / 4,5:1 texto | **Falla** |
| Dorado sobre `#121212` (oscuro) | 7,78:1 | 4,5:1 | OK |
| `onSurface` al 50 % sobre blanco (textos secundarios) | 3,19:1 | 4,5:1 | **Falla** |
| `onSurface` al 60 % sobre blanco | 4,29:1 | 4,5:1 | Justo por debajo |
| `onSurface` al 50 % sobre `#121212` | 4,30:1 | 4,5:1 | Justo por debajo |

Propuesta:

- **Dos dorados.** `goldSoft #C3A35D` para rellenos (AppBar, FAB, botones) y un `goldInk #7A5F22` (6,02:1 sobre blanco) para texto, iconos y bordes sobre fondo claro. En oscuro, el dorado actual ya cumple.
- **Esquema completo.** `ColorScheme.light()`/`.dark()` solo definen `primary`, así que `secondary` y `tertiary` caen en los valores por defecto de Flutter (un turquesa `#03DAC6`). En Material 3, componentes como `FilterChip` seleccionado o `secondaryContainer` usan esos colores. Hay que generar el esquema con `ColorScheme.fromSeed(seedColor: goldSoft, brightness: …)`, fijar `primary: goldSoft` encima y revisar `secondary` y `tertiary`; `mutedOlive #758A61` y `oliveBrown #605632` ya existen en `AppColors`.
- **Opacidades mínimas.** Para texto secundario, nada por debajo de `alpha: 0.7`; mejor aún, usar `onSurfaceVariant`.
- **Colores del juego en una `ThemeExtension`** (`GameColors`: elementos, rarezas, afilado, zonas), con variante clara y oscura. Hoy hay 393 `Colors.*` y 30 `Color(0x…)` repartidos por las pantallas.
- **AppBar en oscuro.** La barra dorada sólida sobre `#121212` es el elemento más brillante de la pantalla. Opcional: en oscuro, `surfaceContainer` con título e iconos dorados. Es un cambio de identidad, así que lo decides tú (tarea T20, opcional).

### 6.2 Componentes

| Hallazgo | Acción |
|----------|--------|
| `DecorationSpriteIcon`, `SkillSpriteIcon` y `GearSpriteIcon` hacen lo mismo: cargar una hoja de sprites y recortar un rectángulo. Tienen entre un 59 % y un 77 % de código igual y una caché de `ui.Image` cada uno | Un único `SpriteIcon(sheet, rect)` con caché compartida; los tres quedan como envoltorios finos |
| Sin uso: `c_preview_container.dart`, `filter_panel.dart`, `armor_piece_image.dart`, `widgets/custom_card.dart`, `skill_item.dart`, `url_image_loader.dart` | Borrar |
| Cada lista repite 30–40 líneas de estado vacío y de carga | Un `AsyncStateView` (carga / vacío / error) |
| Las tarjetas de lista se construyen dentro de `itemBuilder` | Extraerlas a widgets propios (`MonsterCard`…) con constructor `const` |
| 268 `fontSize:` sueltos frente a 3 usos de `textTheme`; 22 tamaños por debajo de 12 px | Escala tipográfica en el tema, con 12 px como mínimo para texto legible |
| `EdgeInsets` y `BorderRadius` con valores dispares | Tokens `AppSpacing` (4/8/12/16/24) y `AppRadius` (10/15/20) |

### 6.3 Overflow y texto grande

- Hay 306 `Text` en pantallas y componentes. Solo 17 tienen `overflow:` y 9 tienen `maxLines`.
- Hay 292 alturas fijas (`height: <n>`) y ningún uso de `LayoutBuilder` ni de `textScaler`.
- Riesgo real con alemán y polaco (cadenas más largas) y con el texto del sistema al 130–200 %.

Propuesta:

1. Un test que monte cada tarjeta y cada cabecera de detalle con `textScaler: TextScaler.linear(2.0)` y `locale: de`, a 360 px de ancho. Falla si aparece un `RenderFlex overflowed`.
2. Arreglos típicos:
   - Títulos dentro de `Row`: `Expanded` + `maxLines` + `TextOverflow.ellipsis`.
   - Grupos de chips: `Wrap` en lugar de `Row`.
   - Alturas fijas: `ConstrainedBox(minHeight:)` en lugar de `height:`.
3. Acotar la escala en las zonas densas (tablas de afilado o de daño) con `MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3)`. No se aplica a toda la app.

### 6.4 Accesibilidad e interacción

- Solo hay 2 `tooltip` o `Semantics` en toda la app. Hacen falta `tooltip` en los `IconButton` y `semanticLabel` en las imágenes que dan información (debilidades, elementos, rareza).
- La información no debe depender solo del color: mantener icono o texto junto al color.
- Hace falta pull-to-refresh, skeletons con la forma de la tarjeta, debounce de 250 ms en la búsqueda, y conservar el filtro y el scroll al cambiar de sección.

---

## 7. Rendimiento (resto)

| Problema | Dónde | Cambio |
|----------|-------|--------|
| Skills pedidas una a una en serie | `armor_piece_details.dart:39`, `weapon_details.dart:46` | `q={"id":{"$in":[…]}}`, o leerlas de `SkillsProvider` |
| `MonsterDetails` vuelve a pedir el monstruo aunque ya esté en memoria | `monster_details.dart:30` | Usar el de `MonstersProvider` y pedir por id solo si falta |
| JSON de 1,5–2,5 MB parseados en el hilo de UI | `lib/api/*` | `Isolate.run` / `compute` |
| Ninguna imagen usa `cacheWidth` | Listas y mapas | Decodificar al tamaño mostrado |
| `removeDiacritics` hace 52 `replaceAll` por elemento y por tecla | `utils.dart` y providers | Normalizar una vez al cargar |
| 68 `Provider.of` que escuchan el provider entero | Pantallas | `context.select` / `context.watch` |

Assets: mapas (20 MB, 21 archivos) e iconos de items (20 MB, 2.008 archivos) a WebP. Los iconos se resuelven por nombre de archivo, así que el script de conversión debe conservar el nombre y cambiar solo la extensión, y hay que actualizar las rutas `.png` del código.

---

## 8. Tests (decisión tomada)

Me diste libertad en esta sección. Decido lo siguiente:

- **Sí:**
  - Tests de `fromJson` con fixtures reales.
  - Tests de las funciones de filtro puras.
  - Tests de providers con un repositorio falso: carga, error, reintento y caché.
  - Tests de overflow con texto grande y alemán.
  - Smoke test de `HomeScreen`.
  - CI en GitHub Actions con `analyze` + `test` en cada PR a `develop` y `main`.
- **No por ahora:**
  - **Golden tests**: dependen del sistema operativo y de las fuentes, dan falsos fallos entre Windows y la CI de Linux, y su mantenimiento no compensa en una app de un solo desarrollador. Los tests de overflow cubren el riesgo principal.
  - **Crashlytics/Sentry**: exigen Firebase o una cuenta externa y una actualización de la política de privacidad. Se puede reconsiderar más adelante.
- **Orden:** los tests van primero (fase 0), porque protegen todos los refactors posteriores.

---

## 9. Tareas

Leyenda de modelos:

- **Haiku 5.5**: cambios mecánicos y bien acotados.
- **Sonnet 5.5**: la mayoría de tareas de código.
- **Opus 5.5**: diseño de arquitectura o cambios con muchas piezas que encajar.

Razonamiento: `low` / `medium` / `high`.

Reglas comunes a todos los prompts (ya están en `CLAUDE.md`): no quitar funcionalidades, reutilizar componentes existentes, `flutter analyze` sin avisos nuevos, `flutter test` en verde y un test por cada cambio de comportamiento. Una tarea = una rama = un PR contra `develop`.

### Fase 0 — Red de seguridad

#### T01 · Sustituir el test de plantilla por un smoke test
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. `test/widget_test.dart` es el test del contador de la plantilla de Flutter y no prueba nada de la app. Sustitúyelo por un smoke test que monte `HomeScreen` dentro de un `MultiProvider` y un `MaterialApp` con localizaciones. Ningún test debe hacer peticiones reales: haz que los providers de datos no carguen (o usa subclases falsas) y que `EnNamesCache` complete sin red. Comprueba que se ven la AppBar con el título de Monstruos y el drawer al abrirlo. Ejecuta `flutter test` y `flutter analyze`.

#### T02 · Fixtures y tests de `fromJson`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. Crea `test/fixtures/` con un JSON real recortado (2–3 elementos) de cada endpoint que usa la app: monsters, weapons (al menos una de cada tipo con campos especiales: switch-axe, charge-blade, gunlance, bow, bowguns, hunting-horn, insect-glaive), armor, armor/sets, decorations, charms, items, skills y locations. Descárgalos de `https://wilds.mhdb.io/en/...` una sola vez y guárdalos. Escribe un test por modelo en `lib/models/` que parsee el fixture y compruebe 3–5 campos clave. No cambies los modelos salvo que un test destape un bug real; en ese caso, explícalo.

#### T03 · CI en GitHub Actions
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** T01
- **Prompt:**
  > Lee CLAUDE.md. Crea `.github/workflows/ci.yml` que, en cada push y en cada PR a `develop` y `main`, instale Flutter estable (`subosito/flutter-action`, versión fijada al canal stable con caché), ejecute `flutter pub get`, `flutter analyze` y `flutter test`. No añadas despliegues ni secretos.

### Fase 1 — Limpieza (sin cambios de comportamiento)

#### T04 · Borrar código y datos muertos
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T01
- **Prompt:**
  > Lee CLAUDE.md y la sección 5 de docs/PLAN_MEJORAS.md. Antes de borrar cada símbolo, confirma con grep que nadie lo usa. Borra: `lib/data/materials.dart`, `materials_high_rank.dart`, `materials_low_rank.dart`, `monsters.dart`; `lib/components/c_preview_container.dart`, `filter_panel.dart`, `armor_piece_image.dart`, `skill_item.dart`, `url_image_loader.dart`; `lib/widgets/custom_card.dart`; en `lib/utils/utils.dart`, `getSkillUrl`, `isGrayScaleFromUrl`, `getValidMonsterImageUrl`, `getValidSkillImageUrl`, `countRomanNumerals` y `_skillImageUrlCache` (solo los que queden sin uso); el bloque comentado que usa `SkillItem` en `decoration_details.dart`; y en la raíz, `temp_old_weapons.dart` y `test_regex.dart`. Mueve `update_arb.dart` a `scripts/`. No toques `lib/data/ailments.dart`, que sí se usa. Ejecuta `flutter analyze` y `flutter test`.

#### T05 · Dependencias sobrantes
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** T04
- **Prompt:**
  > Lee CLAUDE.md. En `pubspec.yaml`: elimina `cached_network_image` y `transparent_image` (confirma con grep que no hay imports); mueve `image` a `dev_dependencies`, porque solo la usan los scripts de `scripts/`; cambia la `description` por una frase real sobre la app. Ejecuta `flutter pub get`, `flutter analyze` y `flutter test`.

#### T06 · Avisos del analizador
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** T04
- **Prompt:**
  > Lee CLAUDE.md. Ejecuta `dart fix --apply`. Después sustituye todos los `.withOpacity(x)` por `.withValues(alpha: x)`, los `print(` de `lib/` por `debugPrint(` y los `_XState createState()` públicos por `State<X> createState()`. Elimina las variables sin uso que señale el analizador (p. ej. `successCount`/`errorCount` en `weapons_api.dart`). Objetivo: `flutter analyze` sin avisos en `lib/`. No cambies lógica.

#### T07 · Lints más estrictos
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T06
- **Prompt:**
  > Lee CLAUDE.md. En `analysis_options.yaml`, excluye `lib/l10n/gen_l10n/**` y `scripts/**`, y activa `prefer_const_constructors`, `prefer_final_locals`, `unawaited_futures`, `use_build_context_synchronously` y `avoid_dynamic_calls`. Corrige lo que salga; si `avoid_dynamic_calls` genera más de 50 avisos en los modelos, déjalo desactivado y anótalo en el PR. Ejecuta `flutter analyze` y `flutter test`.

### Fase 2 — Rendimiento rápido

#### T08 · Skills en una sola petición
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T02
- **Prompt:**
  > Lee CLAUDE.md y la sección 3 de docs/PLAN_MEJORAS.md. En `armor_piece_details.dart` (`fetchSkillsForArmor`) y en `weapon_details.dart` se piden las skills una a una con `await` dentro de un `for`. Añade a `SkillsApi` un `fetchSkillsByIds(Set<int> ids)` que use `GET skills?q={"id":{"$in":[...]}}` (con `Uri` y los parámetros codificados) y úsalo en ambos sitios. Si `SkillsProvider` ya tiene las skills cargadas, tómalas de ahí sin ir a red. Conserva el orden actual de las skills. Añade un test del método nuevo con un `http.Client` falso.

#### T09 · `MonsterDetails` sin petición duplicada
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T02
- **Prompt:**
  > Lee CLAUDE.md. `MonsterDetails` (`monster_details.dart:30`) llama a `MonstersApi.fetchMonsterById` aunque `MonstersProvider` ya tenga ese monstruo con todos sus campos. Compara el JSON de `/monsters` y de `/monsters/{id}`. Si son equivalentes, usa el objeto del provider y pide por id solo si no está. Si el detalle trae campos extra, documéntalo y no cambies nada. Añade un test.

#### ✅ T10 · Decodificar imágenes al tamaño mostrado
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. Ninguna imagen usa `cacheWidth`/`cacheHeight`. En cada `Image.asset` de las listas (monstruos, mapas, items, armas, armaduras, talismanes, decoraciones) y en las miniaturas de mapas, pasa `cacheWidth` igual al ancho mostrado × `MediaQuery.devicePixelRatioOf(context)`, redondeado. Si hay 3 o más sitios con el mismo patrón, crea un helper en `lib/components/`. No lo apliques a las vistas de mapa a pantalla completa con zoom. Comprueba visualmente que no se ven borrosas.

#### ✅ T11 · Assets PNG a WebP
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T04
- **Prompt:**
  > Lee CLAUDE.md y la sección 7 de docs/PLAN_MEJORAS.md. Crea `scripts/optimize_assets.dart` (o `.py`) que convierta a WebP los PNG de `assets/imgs/maps`, `item_icons`, `monsters`, `monster_icons`, `sprites` y `logo`: calidad 82 para mapas y fotos, `-lossless` para iconos y sprites. Debe conservar el nombre y cambiar solo la extensión. Después actualiza todas las rutas que construyen `.png` en el código (grep `'.png'`, `ItemIconAssetResolver`, `monster_icons`, `maps/`, sprites). Ojo: el resolvedor de iconos indexa por nombre de archivo, así que comprueba que su test sigue pasando. No toques los iconos de lanzador de `android/` ni de `ios/`. Informa del tamaño de `assets/` antes y después, y compara visualmente 3 mapas y 10 iconos.

#### ✅ T12 · Búsqueda más ligera
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T02
- **Prompt:**
  > Lee CLAUDE.md. `removeDiacritics` (`lib/utils/utils.dart`) hace 52 `replaceAll` y se llama para cada elemento en cada tecla. Reescríbela con un único recorrido y un mapa de caracteres. En los providers, calcula el nombre normalizado una vez al cargar los datos. En los campos de búsqueda de las listas, añade un debounce de 250 ms, reutilizable si se repite. Añade tests de `removeDiacritics` con tildes, ñ y mayúsculas.

#### ✅ T13 · Parseo de JSON fuera del hilo de UI
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T02
- **Prompt:**
  > Lee CLAUDE.md. En `lib/api/`, las respuestas de weapons, armor, armor/sets, monsters y charms (entre 0,3 y 2,5 MB) se decodifican y se parsean en el hilo principal. Mueve `json.decode` + `fromJson` a `Isolate.run` en esos endpoints. Los tests de fixtures (T02) deben seguir pasando.

### Fase 3 — Red fiable y offline

#### ✅ T14 · `ApiClient` compartido
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T02, T08
- **Prompt:**
  > Lee CLAUDE.md. Crea `lib/api/api_client.dart` con un `ApiClient` que reciba un `http.Client` (inyectable en tests) y ofrezca `Future<dynamic> getJson(String path, {String? lang, Map<String, String>? query, Map<String, String>? headers})`. Debe tener: timeout de 15 s, un reintento ante errores de red o 5xx, y excepciones tipadas (`NetworkException`, `ApiHttpException(statusCode)`, `ApiParseException`). Además debe devolver la cabecera `last-modified` y aceptar `If-Modified-Since`, que hará falta en T16. Migra las 8 clases de `lib/api/` para que lo usen sin cambiar sus firmas públicas. Expón el cliente con `Provider`. Escribe tests con `MockClient` de `package:http/testing.dart`.

#### ✅ T15 · `LoadState` y `AsyncStateView`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T14
- **Prompt:**
  > Lee CLAUDE.md. Crea una clase sellada `LoadState<T>` (`Idle`, `Loading`, `Data(T, {bool stale, DateTime? updatedAt})`, `Failure(Object error)`) y un widget `AsyncStateView` en `lib/components/` con los estados de carga, vacío y error. El de error lleva mensaje traducido y botón "Reintentar". Añade las claves nuevas a todos los ARB y ejecuta `flutter gen-l10n`. Migra solo `MonstersProvider` y `MonstersList` como piloto: el provider ya no traga la excepción con `print`, y la lista distingue "sin conexión" de "sin resultados". Tests: widget test de `AsyncStateView` en sus tres estados y test del provider con un `ApiClient` falso que falla y luego funciona.

#### ✅ T16 · Caché en disco validada con `/version`
- **Modelo:** Opus 5.5 · **Razonamiento:** high · **Depende de:** T14, T15
- **Prompt:**
  > Lee CLAUDE.md y la sección 2 de docs/PLAN_MEJORAS.md. Implementa la estrategia stale-while-revalidate: (1) `CacheStore` que guarde el JSON crudo por `idioma/endpoint` en el directorio de soporte (`path_provider`), con metadatos `{version, fetchedAt}`; (2) `VersionService` que pida `https://wilds.mhdb.io/version` como mucho una vez por arranque y otra al volver a primer plano si pasaron más de 4 h; (3) en los repositorios o providers, servir primero la caché (`Data(stale: true)`) y, si la versión remota es más nueva, refrescar con `If-Modified-Since` (304 = mantener, 200 = guardar y notificar). Debe haber un método `refresh(force: true)` para pull-to-refresh. Sin red y con caché, `Data(stale: true)` y la UI muestra "Sin conexión · datos del <fecha>". Sin red y sin caché, `Failure`. Las cachés de cada idioma conviven, así que el cambio de idioma ya no borra nada. Aplícalo a todos los endpoints de lista. Tests: caché vacía, caché al día, versión nueva con 200, versión nueva con 304, offline con caché y offline sin caché. Explica en el PR cualquier decisión que se aparte del plan.

#### ✅ T17 · Migrar el resto de listas a `LoadState`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T16
- **Prompt:**
  > Lee CLAUDE.md. Repite el patrón del piloto de T15/T16 (`MonstersProvider` + `MonstersList`) en weapons, armor sets, decorations, talismans/charms, items, skills y locations: `LoadState`, `AsyncStateView`, aviso de datos sin conexión y `RefreshIndicator` que llame a `refresh(force: true)`. Haz un commit por entidad. Cada lista debe conservar sus filtros y su comportamiento actuales.

#### ✅ T18 · Arranque sin esperar a la red
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T16
- **Prompt:**
  > Lee CLAUDE.md. Hoy `MyApp` no pinta nada hasta que `EnNamesCache` termina 4 descargas completas. Mientras no se haga T27: (1) `EnNamesCache` debe pedir solo `?p={"id":true,"name":true}` y guardarse con `CacheStore`; (2) el `FutureBuilder` de `main.dart` solo debe esperar al idioma y al índice de iconos, que son locales; (3) los widgets que necesitan el nombre en inglés escuchan `EnNamesCache` y muestran el placeholder actual hasta que esté listo. Mide el tiempo hasta el primer frame antes y después (modo profile o un log con `Stopwatch`).

### Fase 4 — Diseño

#### ✅ T19 · Paleta y contraste
- **Modelo:** Opus 5.5 · **Razonamiento:** medium · **Depende de:** T06
- **Prompt:**
  > Lee CLAUDE.md y la sección 6.1 de docs/PLAN_MEJORAS.md. En `lib/utils/theme.dart` y `colors.dart`: genera los `ColorScheme` claro y oscuro con `ColorScheme.fromSeed(seedColor: AppColors.goldSoft, brightness: …)` y fija `primary: goldSoft` con `onPrimary` oscuro. Revisa `secondary`/`tertiary` (puedes partir de `mutedOlive` y `oliveBrown`). Añade `AppColors.goldInk = Color(0xFF7A5F22)` para texto, iconos y bordes dorados sobre fondo claro (los bordes de input también). Busca textos secundarios con `alpha` por debajo de 0.7 y súbelos o usa `onSurfaceVariant`. Mantén el aspecto general: la AppBar sigue siendo dorada. Verifica en emulador las 10 secciones en claro y en oscuro, y adjunta capturas al PR.

#### ✅ T20 · (Opcional) AppBar en modo oscuro
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T19
- **Prompt:**
  > Lee CLAUDE.md. Solo en el tema oscuro, cambia la AppBar a `colorScheme.surfaceContainer` con título e iconos en `primary` (dorado). El tema claro no cambia. Adjunta capturas antes y después.

#### ✅ T21 · `GameColors` como `ThemeExtension`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T19
- **Prompt:**
  > Lee CLAUDE.md. Reúne en una `ThemeExtension<GameColors>` los colores con significado del juego que hoy están repartidos: elementos, estados, rarezas, colores de afilado y fondos de zona (`zoneBackgroundColor`). Define variante clara y oscura y regístrala en los dos temas. Sustituye los usos (grep `Color(0x`, `Colors.` en `weapon_utils.dart`, `sharpness_bar.dart`, `utils.dart`, `rarity_chip.dart` y pantallas). Los colores claros deben quedar exactamente iguales; los oscuros solo cambian donde el contraste falle.

#### ✅ T22 · Tipografía y espaciado
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T19
- **Prompt:**
  > Lee CLAUDE.md. Completa el `textTheme` de ambos temas (display/headline/title/body/label en sus tres tamaños, con 12 px como mínimo para texto legible) y crea `AppSpacing` (4, 8, 12, 16, 24) y `AppRadius` (10, 15, 20) en `lib/utils/`. Migra por carpetas (`components/`, listas y detalles) los `TextStyle(fontSize: …)` sueltos al estilo del tema más cercano, y los `EdgeInsets`/`BorderRadius` a los tokens. Un commit por carpeta. El aspecto debe ser prácticamente igual; adjunta capturas.

#### ✅ T23 · Cerrar el modo oscuro
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T21
- **Prompt:**
  > Lee CLAUDE.md y `ARCHIVOS_MODIFICAR_MODO_OSCURO.md`. Termina la lista de pendientes aplicando el patrón descrito (colorScheme/GameColors en lugar de `Colors.white`, `Colors.black` y `Colors.grey[…]`). Revisa cada pantalla en oscuro en emulador. Cuando no quede nada, borra `ARCHIVOS_MODIFICAR_MODO_OSCURO.md`. Si el PR sale grande, divídelo en tres: componentes, listas y detalles.

#### ✅ T24 · Tests y arreglos de overflow
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T02, T22
- **Prompt:**
  > Lee CLAUDE.md y la sección 6.3 de docs/PLAN_MEJORAS.md. Crea `test/overflow_test.dart` con un helper que monte un widget a 360×640 dp, con `textScaler: TextScaler.linear(2.0)` y `locale: Locale('de')`, y que falle si aparece cualquier `FlutterError` de overflow. Pruébalo sobre las tarjetas de cada lista y las cabeceras de cada detalle, usando los fixtures de T02 (extrae primero las tarjetas a widgets si siguen dentro de un `itemBuilder`). Corrige lo que falle: `Expanded` + `maxLines` + `ellipsis` en títulos dentro de `Row`, `Wrap` para grupos de chips, `minHeight` en lugar de `height` fijo, y `MediaQuery.withClampedTextScaling(maxScaleFactor: 1.3)` solo en tablas densas (afilado, daño).

#### ✅ T25 · Un único `SpriteIcon`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T11
- **Prompt:**
  > Lee CLAUDE.md. `DecorationSpriteIcon`, `SkillSpriteIcon` y `GearSpriteIcon` repiten la misma lógica: cargar la hoja de sprites, guardar el `ui.Image` en caché y recortar un rectángulo. Extrae un `SpriteIcon(sheetAsset, sourceRect, size)` con una caché compartida y deja los tres como envoltorios que solo calculan el rectángulo. Mantén sus APIs públicas para no tocar a quienes los usan. Añade un widget test que pinte cada tipo.

#### ✅ T26 · Accesibilidad y feedback
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T19
- **Prompt:**
  > Lee CLAUDE.md. Añade `tooltip` traducido a todos los `IconButton` y `semanticLabel` a las imágenes que transmiten información (debilidades, elementos, rareza, tipo de arma). Las decorativas llevan `excludeFromSemantics: true`. Comprueba que ningún área táctil mide menos de 48×48 dp. Sustituye los spinners centrados de las listas por skeletons con la forma de la tarjeta, reutilizando `AsyncStateView`.

### Fase 5 — Arquitectura

#### ✅ T27 · Mapa `id → asset` y adiós a `EnNamesCache`
- **Modelo:** Opus 5.5 · **Razonamiento:** high · **Depende de:** T11, T18
- **Prompt:**
  > Lee CLAUDE.md y la sección 5 de docs/PLAN_MEJORAS.md. Hoy `EnNamesCache` traduce `id → nombre en inglés` para construir rutas de assets locales (`monster_icons`, `monsters`, `maps`) y para el fallback de `MaterialImage`. Crea `scripts/generate_asset_ids.dart`, que llame a la API en inglés y genere `lib/utils/asset_ids.g.dart` con mapas `const` `monsterId → asset`, `locationId → carpeta de mapa` (e `itemId → asset` si aplica), y que avise de los ids sin asset. Sustituye todos los usos de `EnNamesCache` por esos mapas y elimina el provider, su espera en `main.dart` y el fallback a fextralife de `MaterialImage` (usa el placeholder local). Documenta en CLAUDE.md cómo regenerar el archivo cuando salgan monstruos nuevos. Tests: todos los ids de los fixtures resuelven a un asset que existe.

#### ✅ T28 · Provider base `CatalogProvider<T>` y filtros puros
- **Modelo:** Opus 5.5 · **Razonamiento:** high · **Depende de:** T17
- **Prompt:**
  > Lee CLAUDE.md y la sección 4 de docs/PLAN_MEJORAS.md (seguimos con Provider). Los 8 providers de datos repiten carga, `LoadState`, `invalidate` y `refresh`. Extrae una base `CatalogProvider<T, F>` que lo gestione, con un objeto de filtro inmutable `F` por entidad (p. ej. `MonsterFilter`), y una función pura `List<T> applyFilter(List<T>, F)` por entidad, testeada aparte. Hoy el estado del filtro se reparte entre el `State` de la pantalla y el provider: deja el provider como única fuente, de modo que al volver a una sección se conserven el filtro y (con `PageStorageKey`) el scroll. Migra entidad por entidad, en commits separados y sin cambiar el comportamiento de los filtros. Tests: filtros puros con casos límite y provider con repositorio falso.

#### ✅ T29 · Idioma sin estado global
- **Modelo:** Opus 5.5 · **Razonamiento:** medium · **Depende de:** T28
- **Prompt:**
  > Lee CLAUDE.md. `ApiConfig.languageCode` es estático y mutable, y se asigna dentro de `build()` (`main.dart:69`) y en `settings.dart:196`. Haz que el idioma fluya de `LocaleProvider` a los providers de datos con `ChangeNotifierProxyProvider` (o pasándolo al repositorio). Elimina la asignación en `build`, `_invalidateDataProviders` de `settings.dart` y el `addPostFrameCallback` de recarga que tienen las listas en `build`. Cambiar de idioma debe seguir recargando los datos en el idioma nuevo, y servirlos desde la caché si ya existen. Borra también el `FocusNode` global `myFocusNode` de `theme.dart` si no se usa, o muévelo a donde corresponda. Test: cambiar el idioma dispara la carga en el idioma nuevo.

#### ✅ T30 · Secciones de navegación con un `enum`
- **Modelo:** Sonnet 5.5 · **Razonamiento:** low · **Depende de:** T06
- **Prompt:**
  > Lee CLAUDE.md. `HomeScreen` decide el título y las acciones con cadenas de `if (screen is X)`, y el drawer guarda instancias de `Widget`. Crea `enum AppSection` con título traducido, icono o asset, constructor de pantalla y acciones de la AppBar, y úsalo en `HomeScreen` y en `Cdrawer` como única fuente. Mismo orden, mismos iconos y mismo comportamiento. Test: cada sección muestra su título.

#### ✅ T31 · Partir pantallas grandes (una tarea por pantalla)
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T24
- **Prompt (repetir para `weapon_details.dart`, `monster_details.dart`, `weapons_list.dart`, `armor_sets_list.dart`, `armor_piece_details.dart`):**
  > Lee CLAUDE.md. `<archivo>` supera las 800 líneas. Divídelo en widgets por sección dentro de `lib/screens/<nombre>/`, siguiendo el patrón de `lib/screens/weapons_list/`. Antes de crear nada, busca si ya existe un componente equivalente en `lib/components/` y reutilízalo. No cambies la UI ni la lógica: es un refactor puro. Constructores `const` donde se pueda. Comprueba que los tests de overflow (T24) siguen en verde y revisa la pantalla en emulador.

#### ✅ T32 · Ordenar `utils/` y `widgets/`
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** T04, T21
- **Prompt:**
  > Lee CLAUDE.md. Divide `lib/utils/utils.dart` en archivos con un solo propósito: `text_utils.dart` (`removeDiacritics`), `asset_paths.dart` (`getTypeImage`, `getKindImage`, `getJewelSlotIcon`) y lo que quede de imágenes remotas, si queda algo. Mueve lo que haya en `lib/widgets/` a `lib/components/` y borra la carpeta. Actualiza los imports. Sin cambios de comportamiento.

#### ✅ T33 · Actualizar README y CLAUDE.md
- **Modelo:** Haiku 5.5 · **Razonamiento:** low · **Depende de:** todas las anteriores
- **Prompt:**
  > Lee CLAUDE.md y docs/PLAN_MEJORAS.md. Actualiza el README (arquitectura con capas API → caché → providers → UI, cómo funciona el modo offline, cómo regenerar ARB, assets WebP y `asset_ids.g.dart`) y ajusta CLAUDE.md a la estructura final. Marca como hechas en este plan las tareas completadas.

---

## 10. Orden recomendado

```
Fase 0: T01 → T02 → T03
Fase 1: T04 → T05, T06 → T07
Fase 2: T08, T09, T10, T12, T13 (en paralelo) · T11
Fase 3: T14 → T15 → T16 → T17, T18
Fase 4: T19 → T20 (opc.), T21 → T23 · T22 → T24 · T25 · T26
Fase 5: T27 · T28 → T29 · T30 · T31 (×5) · T32 → T33
```

Cada fase deja la app publicable. Las puertas entre fases son:

- **Fase 1:** `flutter analyze` limpio y tests de modelos en verde.
- **Fase 3:** la app abre y navega en modo avión con datos guardados.
- **Fase 4:** los tests de overflow están en verde y el modo oscuro se ha revisado en dispositivo.

---

## 11. Tareas añadidas durante la ejecución

#### ✅ T34 · Generar `asset_ids.g.dart` (reintento de T27, bloqueada por red)
- **Modelo:** Opus 5.5 · **Razonamiento:** high · **Depende de:** T18
- **Problema:** T27 no pudo hacerse en la ejecución automática (T18–T33). El entorno no alcanza `https://wilds.mhdb.io` (el proxy responde `403` al `CONNECT`), y el script necesita la lista completa de monstruos, localizaciones y objetos en inglés. Los fixtures de `test/fixtures` solo traen 3 elementos por archivo, así que no sirven para generar el mapa: quitar `EnNamesCache` con un mapa incompleto dejaría sin icono a los monstruos y mapas que falten.
- **Intentado:** comprobar el acceso con `curl` (403), buscar un volcado local completo de la API (no existe) y ver si los fixtures bastaban (no). No se ha dejado ningún cambio de T27 en el código; `EnNamesCache` sigue funcionando como tras T18 (solo `id`+`name`, con `CacheStore`, sin bloquear el arranque).
- **Falta:** ejecutar el prompt de T27 desde una máquina con red: crear `scripts/generate_asset_ids.dart` (llama a la API en inglés y escribe `lib/utils/asset_ids.g.dart` con mapas `const` `monsterId → asset`, `locationId → carpeta de mapa`, `itemId → asset` si aplica, avisando de los ids sin asset), sustituir los usos de `EnNamesCache` (`nameForMonsterImage`, `nameForMapImage`, `nameForItemImage`), quitar el provider, su `ChangeNotifierProvider` en `main.dart` y el fallback a fextralife de `MaterialImage`, documentar en CLAUDE.md cómo regenerar el archivo y añadir el test «todos los ids de los fixtures resuelven a un asset que existe». Usar `ApiConfig.baseUrlForLanguage('en')` y `?p={"id":true,"name":true}` para que la descarga sea pequeña.
- **Prompt:**
  > Lee CLAUDE.md y la sección 5 y la tarea T27 de docs/PLAN_MEJORAS.md. Ejecuta T27 desde un entorno con acceso a https://wilds.mhdb.io. Tras T18, `EnNamesCache` ya pide solo `id` y `name` y se guarda con `CacheStore`; el objetivo ahora es sustituirla por mapas generados `const` y borrarla.

### Bloque .todo (T35–T41)

Salen de `.todo`. Decisiones tomadas: filtro de elemento en armaduras sin multiselección, solo piezas con resistencia > 0 y ordenadas de mayor a menor; anuncios con un JSON en el repo (sin Firebase ni web de administrador); login con Google descartado; Buy me a coffee **no se implementa por ahora** (ver nota al final). Orden: T35 · T36 → T37 → T38 · T39 · T40 → T41.

#### ✅ T35 · Bugs de listas, drawer y árbol de armas
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. Tres bugs de `.todo`, cada uno en su commit y con su test: (1) el panel de filtros tapa los primeros elementos de todas las listas (monstruos, armas, sets de armadura, decoraciones, talismanes, habilidades, objetos): reproduce en un test de widget con un `ListFiltersPanel` abierto y arregla el solape en el sitio común, sin parchear lista por lista. (2) los elementos del drawer (`Cdrawer`/`AppSection`) se pintan todos de marrón como si estuvieran seleccionados, en claro y en oscuro: solo debe destacar el activo; test con `selected`. (3) abrir un árbol (serie) desde la lista de armas lanza un error: reprodúcelo con los fixtures, arregla la causa raíz y añade el test. Aplica `ui-ux-pro-max` y comprueba contraste en claro y oscuro.

#### T36 · Dialog de mapas sin scroll y layout de stats
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** —
- **Prompt:**
  > Lee CLAUDE.md. (1) En `_showFullImage` de `lib/screens/map_details.dart`, el `InteractiveViewer` permite arrastrar sin zoom (`minScale: 0.5`, `boundaryMargin` de 20). Haz que a escala 1 la imagen no se mueva y siga pudiéndose hacer zoom (`minScale: 1`, sin margen); test de widget. (2) En los detalles de armas y armaduras los stats mezclan filas centradas y no centradas. Unifica todas con `LabelValueRow` (nombre a la izquierda, valor a la derecha) reutilizando el componente existente, sin crear otro. Comprueba que los tests de overflow (T24) siguen en verde y revisa la pantalla.

#### T37 · `GameElement` central y etiquetas traducidas
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** —
- **Contexto:** la API no tiene fuente para elementos ni estados (`/ailments` devuelve `[]`). Hoy las rutas `assets/imgs/elements/${x.toLowerCase()}.webp` se construyen a mano en ~10 sitios y `WeaponUtils.getElementAssetName/getElementIcon/elementLabel` duplican el mapeo. Elementos: fire, water, ice, thunder, dragon. Estados de armas: paralysis, poison, sleep, blastblight.
- **Prompt:**
  > Lee CLAUDE.md. Crea `GameElement` (enum en `lib/utils/game_element.dart`) con id de la API, ruta del asset, icono de respaldo y `isStatus`, y una función que devuelva la etiqueta traducida con `AppLocalizations` (añade claves ARB para los 5 elementos y los 4 estados en los 10 archivos y ejecuta `flutter gen-l10n`). Sustituye las rutas construidas a mano y `WeaponUtils.getElementAssetName/getElementIcon/elementLabel` por él, empezando por los que usan los filtros; los `semanticLabel` pasan a ser traducidos. Test: todos los assets existen, todo valor de elemento o estado del fixture de armas resuelve a un `GameElement` y cada etiqueta existe en los 10 idiomas. Sin cambios visuales.

#### T38 · Estados alterados traducidos
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T37
- **Prompt:**
  > Lee CLAUDE.md. `lib/data/ailments.dart` tiene los nombres y las descripciones de los estados solo en inglés y se muestra así en `ElementsAndAilments`. Mueve nombres y descripciones a ARB (en, es, es_419, es_ES, fr, it, pl, pt, pt_BR, de) y a un único registro con el nombre del asset, y borra `ailments.dart`. Si no hay traducción de un idioma, cae al inglés (Flutter ya lo hace con `fallback`); no inventes términos oficiales que no conozcas: deja la traducción más natural y lista los términos dudosos en la respuesta para revisarlos. Test: todas las claves existen en los 10 archivos y el diálogo muestra el texto en un idioma no inglés.

#### T39 · Filtro de elemento en armas
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T37
- **Prompt:**
  > Lee CLAUDE.md y `lib/screens/weapons_list/weapon_filters.dart`. Añade a `WeaponFilter` un campo `element` (String?, id de `GameElement`) y filtra `filterWeapons` por los `specials` del arma (`kind: element` → `element`, `kind: status` → `status`); un arma tiene como mucho un special, así que un solo desplegable con los 5 elementos y 4 estados sirve. No mires el vial: 7 de las 47 armas con vial de elemento no tienen special de elemento. Usa `ListFilterFieldConfig.select` con icono (`leading`) y nombre traducido, y mantén `provider.filter` como única fuente del estado. Comprueba además que la lista y el detalle muestran el tipo de vial (hacha cargada, hacha espada) y el recubrimiento (arco) con `GameElement`, y corrige lo que falte. Tests: `filterWeapons` con casos límite (elemento, estado, combinado con tipo y rareza, sin resultados) y el filtro se conserva al volver a la sección.

#### T40 · Filtro de elemento en armaduras
- **Modelo:** Sonnet 5.5 · **Razonamiento:** medium · **Depende de:** T37
- **Prompt:**
  > Lee CLAUDE.md, `lib/providers/filters/armor_set_filter.dart` y `lib/screens/armor_sets_list/armor_set_filters.dart`. Añade a `ArmorSetFilter` un `element` (un solo elemento, sin multiselección; solo fire, water, ice, thunder, dragon: las armaduras no resisten estados). Con elemento elegido, `filterArmorSets` conserva solo las piezas con `resistances[element] > 0` y las ordena de mayor a menor resistencia a ese elemento; se combina con nombre, tipo y rareza. Decide y documenta en un comentario cómo se ordenan los sets: por defecto, por la mejor pieza que conservan, manteniendo el orden cabeza→piernas dentro del set. Si no hay elemento, el comportamiento actual no cambia. Desplegable con icono y nombre traducido (`ListFilterFieldConfig.select`). Tests: puros de `filterArmorSets` (resistencia 0 y negativa se excluyen, empates, combinado con rareza y tipo, orden) y de conservación del filtro.

#### T41 · Pantalla de anuncios con JSON
- **Modelo:** Opus 5.5 · **Razonamiento:** medium · **Depende de:** T30
- **Prompt:**
  > Lee CLAUDE.md y docs/ANUNCIOS.md (formato y guía ya decididos). Crea `announcements/announcements.json` en la raíz con un anuncio de ejemplo, un modelo `Announcement` (id, fecha, título y texto por idioma, enlace opcional) con `fromJson` a mano, un `CatalogProvider` y una pantalla de listado nueva (título traducido, estados de carga/vacío/offline con los componentes existentes, `AsyncListBody`). No es una `AppSection`: se abre con `Navigator.push` desde un `IconButton` de altavoz (`Icons.campaign_outlined`) colocado junto al nombre de la app en `Cdrawer.menuHeader`, con `tooltip`/`semanticLabel` traducido, zona táctil de 48 dp y sin romper el centrado ni desbordar con nombres largos (el texto en un `Flexible`). El icono lleva un punto de «nuevo» si hay un anuncio cuyo `id` no se ha visto: guarda el último `id` visto en `shared_preferences` y márcalo al abrir la pantalla. La pantalla de inicio sigue siendo `AppSection.monsters` y no se abre ningún diálogo al arrancar. Descarga de `https://raw.githubusercontent.com/Sermio/MHWilds_App/main/announcements/announcements.json` con `ApiClient` y `CachedApi` (copia en disco para el modo offline); el idioma es el de `LocaleProvider` con caída a `en`. Un JSON roto o una petición fallida no debe romper la app: se enseña la copia en disco o el estado vacío. No añadas Firebase ni dependencias nuevas. Tests: parseo del JSON de ejemplo del repo (así la CI avisa si alguien lo rompe), elección de idioma con caída a `en`, estado vacío o error, y el punto de «nuevo» (aparece con un `id` no visto y desaparece al abrir la pantalla).

**Nota (Buy me a coffee, no implementar por ahora):** la FAQ de pagos de Play exime las propinas solo si el 100 % va al creador y no se da nada digital a cambio; Buy Me a Coffee cobra comisión y hay casos de apps avisadas por enlaces de donación (AnkiDroid, StreetComplete). Si se retoma: enlace externo, texto de apoyo voluntario, sin recompensas, y valorar ponerlo solo en la ficha de la tienda y el README. No se han podido leer los hilos de la comunidad de Play y de r/androiddev enlazados (cargan con JavaScript o devuelven 403).
