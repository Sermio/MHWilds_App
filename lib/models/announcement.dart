/// Mensaje de `announcements/announcements.json` (formato en docs/ANUNCIOS.md).
class Announcement {
  const Announcement({
    required this.id,
    required this.date,
    required this.title,
    required this.body,
    this.url,
  });

  final String id;
  final DateTime date;

  /// Texto por idioma (`en`, `es`, `fr`, `it`, `pl`, `pt`, `de`).
  final Map<String, String> title;
  final Map<String, String> body;
  final Uri? url;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        title: Map<String, String>.from(json['title'] as Map),
        body: Map<String, String>.from(json['body'] as Map),
        url: json['url'] == null ? null : Uri.parse(json['url'] as String),
      );

  /// Lista del archivo completo: `{"announcements": [...]}`.
  static List<Announcement> listFromJson(Map<String, dynamic> json) =>
      (json['announcements'] as List<dynamic>)
          .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList();

  String titleFor(String languageCode) => localized(title, languageCode);
  String bodyFor(String languageCode) => localized(body, languageCode);

  /// Texto en [languageCode] (`pt-BR` usa `pt`); si falta, en inglés.
  static String localized(Map<String, String> texts, String languageCode) =>
      texts[languageCode] ??
      texts[languageCode.split(RegExp('[-_]')).first] ??
      texts['en'] ??
      (texts.values.isEmpty ? '' : texts.values.first);
}
