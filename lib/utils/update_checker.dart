import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_checker/flutter_update_checker.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

/// Comprueba si hay una nueva versión en la tienda (Google Play / App Store)
/// y muestra un modal para informar al usuario.
class AppUpdateChecker {
  /// Package name / store IDs for opening the app page:
  /// - Android: applicationId from android/app/build.gradle.
  /// - iOS: numeric App Store ID from App Store Connect (set [iosAppStoreId] when you publish).
  static const String _androidPackageName = 'com.app.mhwilds_assistant';
  static const int? _iosAppStoreId = null; // e.g. 123456789 when published

  static final UpdateStoreChecker _checker = UpdateStoreChecker(
    androidGooglePlayPackage: _androidPackageName,
    iosAppStoreId: _iosAppStoreId,
  );

  /// Ejecuta la comprobación al entrar en la app y muestra el modal si hay actualización.
  /// Debe llamarse con un [context] válido (p. ej. desde [HomeScreen] tras el primer frame).
  static Future<void> checkAndShowUpdateDialog(BuildContext context) async {
    // Solo comprobar en release para no molestar en desarrollo
    if (!kReleaseMode) return;

    try {
      final hasUpdate = await _checker.checkUpdate();
      if (!context.mounted) return;
      if (hasUpdate) {
        await _showUpdateDialog(context);
      }
    } catch (_) {
      // Silenciar errores: app no instalada desde Play Store, sin red, etc.
    }
  }

  static Future<void> _showUpdateDialog(BuildContext context,
      {String? storeVersionOverride}) async {
    String? storeVersion = storeVersionOverride;
    if (storeVersion == null) {
      try {
        // Intentar obtener el versionName desde Google Play Store
        final versionName = await _getStoreVersionName();
        // Si falla, usar el método del paquete como fallback
        if (versionName != null && versionName.isNotEmpty) {
          storeVersion = versionName;
        } else {
          storeVersion = await _checker.getStoreVersion();
        }
      } catch (_) {
        // Si todo falla, intentar con el método del paquete
        try {
          storeVersion = await _checker.getStoreVersion();
        } catch (_) {}
      }
    }

    String currentVersion = '';
    try {
      final info = await PackageInfo.fromPlatform();
      currentVersion = info.version;
    } catch (_) {}

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.system_update,
                  color: Theme.of(ctx).colorScheme.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.newVersionAvailable,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            _buildUpdateMessage(
              l10n: l10n,
              currentVersion: currentVersion,
              newVersion: storeVersion,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.close),
            ),
            FilledButton.icon(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _openStore();
              },
              icon: const Icon(Icons.store, size: 20),
              label: Text(l10n.goToStore),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.primary,
                foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
              ),
            ),
          ],
        );
      },
    );
  }

  static String _buildUpdateMessage({
    required AppLocalizations l10n,
    required String currentVersion,
    String? newVersion,
  }) {
    final hasCurrent = currentVersion.isNotEmpty;
    final hasNew = newVersion != null && newVersion.isNotEmpty;
    if (hasCurrent && hasNew) {
      return l10n.updateMessageWithBoth(currentVersion, newVersion);
    }
    if (hasCurrent) {
      return l10n.updateMessageCurrentOnly(currentVersion);
    }
    if (hasNew) {
      return l10n.updateMessageNewOnly(newVersion);
    }
    return l10n.updateMessageGeneric;
  }

  /// Obtiene el versionName desde Google Play Store mediante scraping de la página.
  /// Retorna null si no se puede obtener.
  static Future<String?> _getStoreVersionName() async {
    if (!Platform.isAndroid) return null;

    try {
      final url =
          'https://play.google.com/store/apps/details?id=$_androidPackageName';
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        final html = response.body;

        // Buscar el versionName en el JSON-LD estructurado
        // Google Play Store incluye información estructurada en JSON-LD
        final jsonLdPattern = RegExp(
          r'<script type="application/ld\+json">(.*?)</script>',
          dotAll: true,
        );
        final jsonLdMatch = jsonLdPattern.firstMatch(html);

        if (jsonLdMatch != null) {
          try {
            final jsonData =
                json.decode(jsonLdMatch.group(1)!) as Map<String, dynamic>?;
            final version = jsonData?['softwareVersion'];
            if (version is String && version.isNotEmpty) {
              return version;
            }
          } catch (_) {}
        }

        // Buscar en el HTML directamente usando patrones comunes
        // Patrón 1: "Current Version" seguido del número de versión
        final versionPattern1 = RegExp(
          r'Current Version</div>\s*<div[^>]*>([^<]+)</div>',
          caseSensitive: false,
        );
        final match1 = versionPattern1.firstMatch(html);
        if (match1 != null) {
          final version = match1.group(1)?.trim();
          if (version != null && version.isNotEmpty) {
            return version;
          }
        }

        // Patrón 2: versión tipo X.Y o X.Y.Z (evitar solo dígitos = versionCode)
        final versionPattern2 = RegExp(
          r'(\d+\.\d+(?:\.\d+)?)',
        );
        final match2 = versionPattern2.firstMatch(html);
        if (match2 != null) {
          final version = match2.group(1)?.trim();
          if (version != null && version.isNotEmpty) {
            return version;
          }
        }
      }
    } catch (_) {
      // Silenciar errores de red o parsing
    }

    return null;
  }

  /// Opens the app page in the store (Play Store / App Store).
  /// Uses url_launcher so it works in debug, emulator, and when not installed from the store.
  static Future<void> _openStore() async {
    final Uri? uri = Platform.isAndroid
        ? Uri.parse(
            'https://play.google.com/store/apps/details?id=$_androidPackageName')
        : _iosAppStoreId != null
            ? Uri.parse('https://apps.apple.com/app/id$_iosAppStoreId')
            : null;
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {
        await _checker.update();
      }
    } else {
      await _checker.update();
    }
  }
}
