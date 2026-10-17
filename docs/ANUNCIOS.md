# Anuncios de la app

La app tiene una pantalla de listado con mensajes para los usuarios (planes futuros, novedades). Los mensajes viven en un archivo JSON del propio repositorio; no hace falta web de administrador, Firebase ni publicar una versión nueva de la app.

- Archivo: [`announcements/announcements.json`](../announcements/announcements.json), en la rama `main`.
- La app lo descarga de `https://raw.githubusercontent.com/Sermio/MHWilds_App/main/announcements/announcements.json` y guarda una copia en disco para el modo offline.
- En la app: altavoz junto al nombre en la cabecera del menú lateral; lleva un punto si el primer anuncio de la lista aún no se ha visto.
- `flutter test` (y la CI) parsea este archivo: si lo rompes, el test `announcements_test.dart` falla.

## Cómo añadir un anuncio

1. Abre el archivo en GitHub (rama `main`) y pulsa el lápiz para editarlo.
2. Copia una entrada existente dentro de `announcements` y pégala **al principio** de la lista (el más nuevo arriba).
3. Cambia `id`, `date`, `title` y `body`. Escribe al menos el texto en `en`; el resto de idiomas son opcionales.
4. Comprueba que el JSON es válido (por ejemplo pegándolo en jsonlint.com): una coma de más o de menos lo rompe.
5. Guarda con *Commit directly to the `main` branch*.

Los usuarios lo verán al abrir el menú lateral o al refrescar la pantalla de anuncios; GitHub puede tardar unos 5 minutos en servir la versión nueva.

Si el JSON queda roto, la app no falla: enseña la copia anterior guardada en el móvil o la pantalla vacía. Aun así, corrígelo cuanto antes.

## Formato

```json
{
  "announcements": [
    {
      "id": "2026-11-roadmap",
      "date": "2026-11-01",
      "title": {
        "en": "What's next",
        "es": "Qué viene ahora"
      },
      "body": {
        "en": "We are working on weapon filters by element.",
        "es": "Estamos trabajando en filtros de armas por elemento."
      },
      "url": "https://example.com/optional-link"
    }
  ]
}
```

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| `id` | sí | Único y **nunca reutilizado**. Sirve para identificar el anuncio. |
| `date` | sí | `AAAA-MM-DD`. |
| `title`, `body` | sí | Texto por idioma. Claves: `en`, `es`, `fr`, `it`, `pl`, `pt`, `de`. Si falta el idioma del usuario se usa `en`. |
| `url` | no | Enlace opcional; omite el campo si no hay. |

## Reglas

- Texto plano: sin HTML ni Markdown.
- No borres anuncios antiguos salvo que quieras que desaparezcan de la lista.
- No pongas datos personales ni nada que no quieras que sea público: el archivo está en un repositorio público.
