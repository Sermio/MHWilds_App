import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/components/async_state_view.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/load_state.dart';

Widget _app(LoadState<List<int>> state, {VoidCallback? onRetry}) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: AsyncStateView<List<int>>(
          state: state,
          loadingLabel: 'loading',
          emptyTitle: 'empty',
          onRetry: onRetry,
          builder: (_, d) => Text('data ${d.length}'),
        ),
      ),
    );

void main() {
  testWidgets('carga', (t) async {
    await t.pumpWidget(_app(const Loading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('loading'), findsOneWidget);
  });

  testWidgets('vacío y datos', (t) async {
    await t.pumpWidget(_app(const Data(<int>[])));
    expect(find.text('empty'), findsOneWidget);
    await t.pumpWidget(_app(const Data([1, 2])));
    expect(find.text('data 2'), findsOneWidget);
  });

  testWidgets('error: sin conexión vs genérico, y reintentar', (t) async {
    var retries = 0;
    await t.pumpWidget(
        _app(Failure(NetworkException('x')), onRetry: () => retries++));
    expect(find.textContaining('No connection'), findsOneWidget);
    await t.tap(find.text('Retry'));
    expect(retries, 1);

    await t.pumpWidget(_app(Failure(ApiHttpException(404))));
    expect(find.textContaining("Couldn't load"), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}
