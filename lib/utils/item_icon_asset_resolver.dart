import 'dart:convert';

import 'package:flutter/services.dart';

class ItemIconAssetResolver {
  static const String _assetsBase = 'assets/imgs/item_icons/';

  static bool _loaded = false;
  static final Map<String, String> _byKindColor = {};
  static final Map<String, String> _byKindFallback = {};

  // Decorations con patrón: MHWilds-Decoration_Level_1-Sword_Icon_Rose_xxx
  static final Map<String, String> _decorationBySlotKindColor = {};
  static final Map<String, String> _decorationBySlotColor = {};
  static final Map<String, String> _decorationByKindColor = {};

  static Future<String?> resolve({
    required String apiKind,
    required String apiColor,
  }) async {
    await _ensureIndexLoaded();

    // Excepción de negocio:
    // Honey debe usar el icono tipo "webbing" manteniendo el color cuando exista.
    final normalizedKind = _normalizeToken(apiKind);
    if (normalizedKind == 'honey') {
      final honeyColorCandidates = _colorCandidates(apiColor).toSet().toList();
      for (final color in honeyColorCandidates) {
        final byKindAndColor = _byKindColor['webbing|$color'];
        if (byKindAndColor != null) return byKindAndColor;
      }
      final honeyOverride = _byKindFallback['webbing'];
      if (honeyOverride != null) return honeyOverride;
    }

    // Excepción de negocio:
    // Powder debe usar el icono tipo "sac" manteniendo el color cuando exista.
    if (normalizedKind == 'powder') {
      final powderColorCandidates = _colorCandidates(apiColor).toSet().toList();
      for (final color in powderColorCandidates) {
        final byKindAndColor = _byKindColor['sac|$color'];
        if (byKindAndColor != null) return byKindAndColor;
      }
      final powderOverride = _byKindFallback['sac'];
      if (powderOverride != null) return powderOverride;
    }

    // Excepción de negocio:
    // Extract debe usar el icono tipo "chemical" manteniendo el color cuando exista.
    if (normalizedKind == 'extract') {
      final extractColorCandidates = _colorCandidates(apiColor).toSet().toList();
      for (final color in extractColorCandidates) {
        final byKindAndColor = _byKindColor['chemical|$color'];
        if (byKindAndColor != null) return byKindAndColor;
      }
      final extractOverride = _byKindFallback['chemical'];
      if (extractOverride != null) return extractOverride;
    }

    final kindCandidates = _kindCandidates(apiKind);
    final colorCandidates = _colorCandidates(apiColor);

    return _resolveByCandidates(
      kindCandidates: kindCandidates,
      colorCandidates: colorCandidates,
    );
  }

  static Future<String?> resolveDecoration({
    required String apiColor,
    required String decorationName,
    String? apiKind,
    int? slot,
  }) async {
    await _ensureIndexLoaded();

    final resolvedSlot = _resolveDecorationSlot(slot, decorationName);
    final kindCandidates = _decorationKindCandidates(apiKind);
    final colorCandidates = _colorCandidates(apiColor).toSet().toList();

    if (resolvedSlot != null && resolvedSlot > 0) {
      for (final kind in kindCandidates) {
        for (final color in colorCandidates) {
          final exact = _decorationBySlotKindColor['$resolvedSlot|$kind|$color'];
          if (exact != null) return exact;
        }
      }
      for (final color in colorCandidates) {
        final bySlotColor = _decorationBySlotColor['$resolvedSlot|$color'];
        if (bySlotColor != null) return bySlotColor;
      }
    }

    for (final kind in kindCandidates) {
      for (final color in colorCandidates) {
        final byKindColor = _decorationByKindColor['$kind|$color'];
        if (byKindColor != null) return byKindColor;
      }
    }

    // Fallback final al resolver genérico (solo si existe).
    return _resolveByCandidates(
      kindCandidates: kindCandidates,
      colorCandidates: colorCandidates,
    );
  }

  static String? _resolveByCandidates({
    required List<String> kindCandidates,
    required List<String> colorCandidates,
  }) {
    final uniqueKinds = kindCandidates.toSet().toList();
    final uniqueColors = colorCandidates.toSet().toList();

    for (final kind in uniqueKinds) {
      for (final color in uniqueColors) {
        final key = '$kind|$color';
        final match = _byKindColor[key];
        if (match != null) return match;
      }
    }

    for (final kind in uniqueKinds) {
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

      final genericRegex = RegExp(
        r'^MHWilds-(.+?)_Icon_([A-Za-z]+(?:_[A-Za-z]+)?)_',
        caseSensitive: false,
      );
      final decorationRegex = RegExp(
        r'^MHWilds-Decoration_Level_(\d+)-([A-Za-z]+)_Icon_([A-Za-z]+(?:_[A-Za-z]+)?)_',
        caseSensitive: false,
      );

      for (final asset in assets) {
        final filename = asset.split('/').last;

        final decorationMatch = decorationRegex.firstMatch(filename);
        if (decorationMatch != null) {
          final slotValue = int.tryParse(decorationMatch.group(1) ?? '');
          final kind = _normalizeToken(decorationMatch.group(2)!);
          final color = _normalizeToken(decorationMatch.group(3)!);

          if (slotValue != null && slotValue > 0) {
            _decorationBySlotKindColor.putIfAbsent(
              '$slotValue|$kind|$color',
              () => asset,
            );
            _decorationBySlotColor.putIfAbsent(
              '$slotValue|$color',
              () => asset,
            );
          }
          _decorationByKindColor.putIfAbsent('$kind|$color', () => asset);
        }

        final genericMatch = genericRegex.firstMatch(filename);
        if (genericMatch != null) {
          final kind = _normalizeToken(genericMatch.group(1)!);
          final color = _normalizeToken(genericMatch.group(2)!);

          _byKindColor.putIfAbsent('$kind|$color', () => asset);
          _byKindFallback.putIfAbsent(kind, () => asset);
        }
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
      'gem': ['ball', 'decoration', 'crystal'],
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
      'sapphire': ['ball', 'gem', 'crystal'],
      'trap-tool': ['trap-guild', 'trap'],
      'unknown': ['question-mark'],
      'voucher': ['lucky-voucher', 'ticket'],
      'web': ['spiderweb', 'webbing'],
    };

    return [normalized, ...?aliases[normalized]];
  }

  static List<String> _decorationKindCandidates(String? apiKind) {
    final normalized = _normalizeToken(apiKind ?? '');
    const aliases = <String, List<String>>{
      'weapon': ['sword'],
      'armor': ['armor'],
      'group': ['armor'],
      'set': ['armor'],
    };

    return {
      if (normalized.isNotEmpty) normalized,
      ...?aliases[normalized],
      'sword',
      'armor',
    }.toList();
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
      // Colores API -> colornames de los PNG de decorations
      'pink': ['rose'],
      'purple': ['violet'],
      'yellow': ['lemon', 'gold'],
    };

    return [normalized, ...?aliases[normalized]];
  }

  static int? _resolveDecorationSlot(int? slot, String decorationName) {
    if (slot != null && slot > 0) return slot;
    final bracketMatch = RegExp(r'\[(\d+)\]').firstMatch(decorationName);
    if (bracketMatch != null) {
      return int.tryParse(bracketMatch.group(1)!);
    }
    final normalizedName = _normalizeToken(decorationName);
    final trailingDigit = RegExp(r'-(\d+)$').firstMatch(normalizedName);
    if (trailingDigit != null) {
      return int.tryParse(trailingDigit.group(1)!);
    }
    return null;
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
