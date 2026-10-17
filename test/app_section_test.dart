import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mhwilds_app/components/c_drawer.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations_en.dart';
import 'package:mhwilds_app/screens/app_section.dart';
import 'package:mhwilds_app/screens/armor_sets_list.dart';
import 'package:mhwilds_app/screens/build_crafter_screen.dart';
import 'package:mhwilds_app/screens/build_optimizer_screen.dart';
import 'package:mhwilds_app/screens/decorations_list.dart';
import 'package:mhwilds_app/screens/home.dart';
import 'package:mhwilds_app/screens/items_list.dart';
import 'package:mhwilds_app/screens/maps_list.dart';
import 'package:mhwilds_app/screens/monsters_list.dart';
import 'package:mhwilds_app/screens/skills_list.dart';
import 'package:mhwilds_app/screens/talismans_list.dart';
import 'package:mhwilds_app/screens/weapons_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overflow_helper.dart';

void main() {
  final l10n = AppLocalizationsEn();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('orden del menú', () {
    expect(AppSection.values.map((s) => s.title(l10n)), [
      l10n.monsters,
      l10n.weapons,
      l10n.armorSets,
      l10n.decorations,
      l10n.talismans,
      l10n.skills,
      l10n.items,
      l10n.locations,
      l10n.buildCrafter,
      l10n.buildOptimizer,
    ]);
  });

  test('cada sección construye su pantalla', () {
    expect(AppSection.monsters.screen, isA<MonstersList>());
    expect(AppSection.weapons.screen, isA<WeaponsList>());
    expect(AppSection.armorSets.screen, isA<ArmorSetList>());
    expect(AppSection.decorations.screen, isA<DecorationsList>());
    expect(AppSection.talismans.screen, isA<AmuletList>());
    expect(AppSection.skills.screen, isA<SkillList>());
    expect(AppSection.items.screen, isA<ItemList>());
    expect(AppSection.locations.screen, isA<MapsList>());
    expect(AppSection.buildCrafter.screen, isA<BuildCrafterScreen>());
    expect(AppSection.buildOptimizer.screen, isA<BuildOptimizerScreen>());
  });

  test('títulos y subtítulos no están vacíos', () {
    for (final s in AppSection.values) {
      expect(s.title(l10n), isNotEmpty, reason: '$s');
      expect(s.subtitle(l10n), isNotEmpty, reason: '$s');
    }
  });

  testWidgets('las herramientas web añaden créditos y ajustes a la AppBar',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    late BuildContext ctx;
    await pumpAtStress(tester, Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    }), data: data, textScale: 1, locale: const Locale('en'));

    for (final s in AppSection.values) {
      final actions = s.appBarActions(ctx);
      if (s == AppSection.buildCrafter || s == AppSection.buildOptimizer) {
        expect(actions, hasLength(2), reason: '$s');
      } else {
        expect(actions, isNull, reason: '$s');
      }
    }
  });

  testWidgets('el menú lista todas las secciones y cada una muestra su título',
      (tester) async {
    final data = await FixtureProviders.load(tester);
    await pumpAtStress(tester, const HomeScreen(),
        data: data, textScale: 1, locale: const Locale('en'));

    Finder appBarTitle(String t) =>
        find.descendant(of: find.byType(AppBar), matching: find.text(t));
    expect(appBarTitle(l10n.monsters), findsOneWidget);

    // Las secciones con WebView no se abren en un test de widgets.
    const listSections = [
      AppSection.weapons,
      AppSection.armorSets,
      AppSection.decorations,
      AppSection.talismans,
      AppSection.skills,
      AppSection.items,
      AppSection.locations,
      AppSection.monsters,
    ];

    for (final section in listSections) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      final drawer = find.byType(Cdrawer);
      for (final s in AppSection.values) {
        expect(find.descendant(of: drawer, matching: find.text(s.title(l10n))),
            findsWidgets,
            reason: 'falta ${s.title(l10n)} en el menú');
      }
      final entry =
          find.descendant(of: drawer, matching: find.text(section.title(l10n)));
      await tester.ensureVisible(entry.first);
      await tester.tap(entry.first);
      await tester.pumpAndSettle();
      expect(appBarTitle(section.title(l10n)), findsOneWidget,
          reason: '$section');
    }
  });
}
