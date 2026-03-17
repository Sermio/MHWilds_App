import 'dart:convert';

import 'package:flutter/services.dart';

class ItemIconAssetResolver {
  static const String _assetsBase = 'assets/imgs/item_icons/';

  static bool _loaded = false;
  static final Map<String, String> _byKindColor = {};
  static final Map<String, String> _byKindFallback = {};

  static Future<String?> resolve({
    required String apiKind,
    required String apiColor,
  }) async {
    await _ensureIndexLoaded();

    final kindCandidates = _kindCandidates(apiKind);
    final colorCandidates = _colorCandidates(apiColor);

    for (final kind in kindCandidates) {
      for (final color in colorCandidates) {
        final key = '$kind|$color';
        final match = _byKindColor[key];
        if (match != null) return match;
      }
    }

    for (final kind in kindCandidates) {
      final fallback = _byKindFallback[kind];
      if (fallback != null) return fallback;
    }

    return null;
  }

  static Future<void> _ensureIndexLoaded() async {
    if (_loaded) return;

    try {
      final rawManifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(rawManifest);
      final assets = manifest.keys.where((a) => a.startsWith(_assetsBase));

      final regex = RegExp(
        r'^MHWilds-(.+?)_Icon_([A-Za-z]+(?:_[A-Za-z]+)?)_',
        caseSensitive: false,
      );

      for (final asset in assets) {
        final filename = asset.split('/').last;
        final match = regex.firstMatch(filename);
        if (match == null) continue;

        final kind = _normalizeToken(match.group(1)!);
        final color = _normalizeToken(match.group(2)!);

        _byKindColor.putIfAbsent('$kind|$color', () => asset);
        _byKindFallback.putIfAbsent(kind, () => asset);
      }
    } catch (_) {
      // If asset manifest can't be loaded, resolver will gracefully fallback.
    } finally {
      _loaded = true;
    }
  }

  static List<String> _kindCandidates(String apiKind) {
    final normalized = _normalizeToken(apiKind);
    final aliases = <String, List<String>>{
      'ammo-basic': ['ammo'],
      'ammo-heavy': ['ammo-cluster', 'ammo'],
      'ammo-slug': ['ammo-sticky', 'ammo-pierce', 'ammo'],
      'ammo-special': ['ammo-spread', 'ammo'],
      'ammo-utility': ['ammo'],
      'armor-sphere': ['armor-sphere'],
      'camping-kit': ['tent', 'camping-kit'],
      'capture-net': ['capture-net'],
      'certificate': ['ticket', 'meal-ticket'],
      'cooking-cheese': ['ingredient-cheese-cooking', 'ingredient-cheese'],
      'cooking-egg': ['ingredient-eggs-cooking', 'ingredient-eggs'],
      'cooking-garlic': ['ingredient-garlic-cooking', 'ingredient-garlic'],
      'cooking-mushroom': [
        'ingredient-mushroom-cooking',
        'ingredient-mushroom',
        'mushroom-cooking',
      ],
      'cooking-shellfish': ['ingredient-shrimp-cooking', 'ingredient-shrimp'],
      'curative': ['medicine', 'drug'],
      'extract': ['vial', 'sac'],
      'fishing-rod': ['fish', 'capture-net'],
      'gem': ['decoration', 'crystal'],
      'grill': ['meat-guild', 'meat'],
      'honey': ['herb', 'seed'],
      'mantle': ['cape'],
      'medulla': ['monster-part-special', 'monster-part'],
      'mystery-artian': ['weapon-shard-random', 'weapon-shard'],
      'mystery-decoration': ['decoration-random-sword', 'decoration-random-armor'],
      'mystery-material': ['rare-question-mark', 'question-mark-special'],
      'nut': ['pod', 'ammo'],
      'phial': ['vial'],
      'plant': ['herb', 'seed', 'sprout'],
      'poop': ['dung'],
      'potion': ['medicine', 'drug'],
      'powder': ['chemical'],
      'question': ['question-mark', 'rare-question-mark'],
      'skull': ['head', 'horn'],
      'slinger-ammo': ['pod', 'ammo'],
      'smoke': ['smoke-bomb'],
      'sprout': ['herb', 'seed'],
      'trap-tool': ['trap-guild', 'trap'],
      'unknown': ['question-mark'],
      'voucher': ['lucky-voucher', 'ticket'],
      'web': ['spiderweb', 'webbing'],
    };

    return [normalized, ...?aliases[normalized]];
  }

  static List<String> _colorCandidates(String apiColor) {
    final normalized = _normalizeToken(apiColor);
    final aliases = <String, List<String>>{
      'blue-purple': ['dark-purple', 'violet', 'purple'],
      'moss-green': ['moss', 'green'],
      'sage-green': ['light-green', 'green'],
      'sky': ['light-blue', 'blue'],
      'ultramarine': ['dark-blue', 'violet', 'blue'],
      'ivory': ['white', 'tan'],
      'none': ['white', 'gray'],
    };

    return [normalized, ...?aliases[normalized]];
  }

  static String _normalizeToken(String value) {
    return value
        .toLowerCase()
        .replaceAll('_', '-')
        .replaceAll(RegExp(r'[^a-z0-9\-]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
