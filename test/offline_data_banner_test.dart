import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/offline_data_banner.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

void main() {
  testWidgets('muestra "Sin conexión · datos del <fecha>" traducido',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home:
          Scaffold(body: OfflineDataBanner(updatedAt: DateTime(2026, 10, 12))),
    ));

    expect(find.text('Sin conexión · datos del 12/10'), findsOneWidget);
  });
}
