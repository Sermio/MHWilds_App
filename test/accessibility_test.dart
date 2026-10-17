import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/asset_thumb.dart';
import 'package:mhwilds_app/components/async_list_body.dart';
import 'package:mhwilds_app/components/card_skeleton_list.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/maps_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:mhwilds_app/utils/load_state.dart';
import 'package:mhwilds_app/utils/game_element.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overflow_helper.dart';

Widget _body(LoadState<List<String>> state, {bool disableAnimations = false}) =>
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: AsyncListBody<String>(
            state: state,
            isOffline: false,
            onRetry: () {},
            onRefresh: () async {},
            loadingLabel: 'cargando lista',
            emptyTitle: 'vacío',
            builder: (_, items) => ListView(children: [Text(items.first)]),
          ),
        ),
      ),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('skeleton de carga', () {
    testWidgets('sustituye al spinner y anuncia la etiqueta de carga',
        (tester) async {
      await tester.pumpWidget(_body(const Loading()));
      expect(find.byType(CardSkeletonList), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.bySemanticsLabel('cargando lista'), findsOneWidget);
    });

    testWidgets('con datos desaparece', (tester) async {
      await tester.pumpWidget(_body(const Data(['x'])));
      expect(find.byType(CardSkeletonList), findsNothing);
      expect(find.text('x'), findsOneWidget);
    });

    testWidgets('pulsa, salvo que el sistema pida reducir animaciones',
        (tester) async {
      await tester.pumpWidget(_body(const Loading()));
      await tester.pump(const Duration(milliseconds: 450));
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(_body(const Loading(), disableAnimations: true));
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('etiquetas de accesibilidad', () {
    test('gameElementLabel', () {
      final en = lookupAppLocalizations(const Locale('en'));
      expect(gameElementLabel(en, 'poison'), 'Poison');
      expect(gameElementLabel(en, 'close-range'), 'Close range');
      expect(gameElementLabel(en, ''), '');
    });

    testWidgets('AssetThumb: decorativa salvo que se dé semanticLabel',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Column(children: [
          AssetThumb('assets/imgs/elements/fire.webp', width: 20),
          AssetThumb('assets/imgs/elements/water.webp',
              width: 20, semanticLabel: 'Water'),
        ]),
      ));
      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images[0].excludeFromSemantics, isTrue);
      expect(images[1].excludeFromSemantics, isFalse);
      expect(images[1].semanticLabel, 'Water');
    });

    testWidgets('los IconButton de la barra y los FAB tienen tooltip',
        (tester) async {
      final data = await FixtureProviders.load(tester);
      await pumpAtStress(tester, const HomeScreen(),
          data: data, textScale: 1, locale: const Locale('en'));
      expect(find.byTooltip('Settings'), findsOneWidget);
      expect(find.byTooltip('Filters'), findsOneWidget);
      // Todos los IconButton del árbol llevan tooltip.
      for (final b in tester.widgetList<IconButton>(find.byType(IconButton))) {
        expect(b.tooltip, isNotNull, reason: '${b.icon}');
      }
    });
  });

  group('zonas táctiles', () {
    final screens = <String, Widget Function()>{
      'monstruos': () => const MonstersList(),
      'armas': () => const WeaponsList(),
      'sets de armadura': () => const ArmorSetList(),
      'decoraciones': () => const DecorationsList(),
      'talismanes': () => const AmuletList(),
      'habilidades': () => const SkillList(),
      'objetos': () => const ItemList(),
      'mapas': () => const MapsList(),
    };
    for (final e in screens.entries) {
      testWidgets('lista de ${e.key}: 48×48 dp y etiquetas', (tester) async {
        final data = await FixtureProviders.load(tester);
        final handle = tester.ensureSemantics();
        await pumpAtStress(tester, e.value(),
            data: data, textScale: 1, locale: const Locale('en'));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }
  });

  // Evita que `provider` se marque como no usado si el helper cambia.
  test('provider disponible', () => expect(Provider, isNotNull));
}
