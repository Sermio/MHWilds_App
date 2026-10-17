import 'package:http/http.dart' as http;

enum AttachmentIssue { tooMany, tooLarge }

/// Envía reportes de bugs a un Cloudflare Worker (ver `backend/bug-report-worker/`)
/// que los reenvía por email. La app nunca conoce la dirección de destino.
class BugReportService {
  BugReportService._();

  /// URL del Worker desplegado.
  static const String endpoint = 'https://mhwilds-bug-report.smtdev.workers.dev';

  static const int maxFiles = 3;
  static const int maxTotalMb = 20;
  static const int maxTotalBytes = maxTotalMb * 1024 * 1024;
  static const int maxDescriptionLength = 4000;

  /// Problema de la lista de adjuntos (tamaños en bytes), o null si es válida.
  static AttachmentIssue? validateAttachments(List<int> sizes) {
    if (sizes.length > maxFiles) return AttachmentIssue.tooMany;
    if (sizes.fold<int>(0, (a, b) => a + b) > maxTotalBytes) {
      return AttachmentIssue.tooLarge;
    }
    return null;
  }

  /// Devuelve true si el Worker aceptó el reporte.
  static Future<bool> send({
    required String description,
    String contact = '',
    List<String> filePaths = const [],
    Map<String, String> meta = const {},
    http.Client? client,
    String url = endpoint,
  }) async {
    final c = client ?? http.Client();
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['description'] = description.trim()
        ..fields['contact'] = contact.trim()
        ..fields.addAll(meta);
      for (final path in filePaths) {
        request.files.add(await http.MultipartFile.fromPath('files', path));
      }
      final response =
          await c.send(request).timeout(const Duration(seconds: 90));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    } finally {
      if (client == null) c.close();
    }
  }
}
