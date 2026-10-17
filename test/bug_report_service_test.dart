import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mhwilds_app/utils/bug_report_service.dart';

void main() {
  group('validateAttachments', () {
    test('acepta hasta 3 archivos y 20 MB', () {
      expect(BugReportService.validateAttachments([]), isNull);
      expect(
          BugReportService.validateAttachments(
              [BugReportService.maxTotalBytes]),
          isNull);
    });

    test('rechaza más de 3 archivos o más de 20 MB', () {
      expect(BugReportService.validateAttachments([1, 1, 1, 1]),
          AttachmentIssue.tooMany);
      expect(
          BugReportService.validateAttachments(
              [BugReportService.maxTotalBytes, 1]),
          AttachmentIssue.tooLarge);
    });
  });

  group('send', () {
    late File file;
    setUp(() {
      file = File('${Directory.systemTemp.path}/bug_report_test.png')
        ..writeAsBytesSync([1, 2, 3]);
    });
    tearDown(() => file.deleteSync());

    test('envía campos y adjuntos y devuelve true con 2xx', () async {
      late http.BaseRequest sent;
      final client = MockClient.streaming((request, body) async {
        sent = request;
        await body.drain<void>();
        return http.StreamedResponse(const Stream.empty(), 200);
      });
      final ok = await BugReportService.send(
        description: ' falla ',
        filePaths: [file.path],
        meta: {'app_version': '1.0.0+1'},
        client: client,
        url: 'https://example.test/report',
      );
      expect(ok, isTrue);
      final req = sent as http.MultipartRequest;
      expect(req.fields['description'], 'falla');
      expect(req.fields['app_version'], '1.0.0+1');
      expect(req.files.single.field, 'files');
    });

    test('devuelve false con error HTTP o excepción', () async {
      final http500 = MockClient.streaming((_, body) async {
        await body.drain<void>();
        return http.StreamedResponse(const Stream.empty(), 500);
      });
      final boom = MockClient.streaming((_, __) async => throw Exception('x'));
      for (final c in [http500, boom]) {
        expect(
            await BugReportService.send(description: 'a', client: c), isFalse);
      }
    });
  });
}
