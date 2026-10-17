import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/components/offline_data_banner.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/load_state.dart';

void main() {
  Widget host(
          {required bool offline,
          required Future<void> Function() onRefresh}) =>
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AsyncListBody<String>(
            state:
                Data(['a'], stale: offline, updatedAt: DateTime(2026, 10, 12)),
            isOffline: offline,
            onRetry: () {},
            onRefresh: onRefresh,
            loadingLabel: 'loading',
            emptyTitle: 'empty',
            builder: (_, items) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [for (final i in items) Text(i)],
            ),
          ),
        ),
      );

  testWidgets('con datos sin conexión muestra el aviso', (tester) async {
    await tester.pumpWidget(host(offline: true, onRefresh: () async {}));
    expect(find.byType(OfflineDataBanner), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
  });

  testWidgets('arrastrar hacia abajo llama a onRefresh', (tester) async {
    var refreshed = 0;
    await tester
        .pumpWidget(host(offline: false, onRefresh: () async => refreshed++));
    expect(find.byType(OfflineDataBanner), findsNothing);

    await tester.fling(find.text('a'), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    expect(refreshed, 1);
  });
}
