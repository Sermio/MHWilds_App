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
    String currentVersion = '';
    try {
      final info = await PackageInfo.fromPlatform();
      currentVersion = _normalizeVersionForDisplay(info.version);
    } catch (_) {}

    if (storeVersion == null) {
      try {
        // Intentar obtener el versionName desde Google Play Store
        final versionName = await _getStoreVersionName();
        // Si falla, usar el método del paquete como fallback
        if (versionName != null && versionName.isNotEmpty) {
          storeVersion = _sanitizeStoreVersionForDisplay(
            versionName,
            currentVersion: currentVersion,
          );
        } else {
          final fallback = await _checker.getStoreVersion();
          storeVersion = fallback != null
              ? _sanitizeStoreVersionForDisplay(
                  fallback,
                  currentVersion: currentVersion,
                )
              : null;
        }
      } catch (_) {
        // Si todo falla, intentar con el método del paquete
        try {
          final fallback = await _checker.getStoreVersion();
          storeVersion = fallback != null
              ? _sanitizeStoreVersionForDisplay(
                  fallback,
                  currentVersion: currentVersion,
                )
              : null;
        } catch (_) {}
      }
    }

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        final cs = Theme.of(ctx).colorScheme;
        final bodyStyle = TextStyle(
          color: cs.onSurface,
          fontSize: 16,
          height: 1.4,
        );
        return AlertDialog(
          backgroundColor: cs.surfaceContainerHighest,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.system_update, color: cs.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.newVersionAvailable,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
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
            style: bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: TextButton.styleFrom(foregroundColor: cs.primary),
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

  /// Devuelve solo el versionName (ej. 1.0.14), sin build number (+27) ni sufijos.
  /// Si el valor es solo dígitos (versionCode), devuelve vacío para no mostrarlo.
  static String _normalizeVersionForDisplay(String version) {
    if (version.isEmpty) return version;
    // Quitar sufijo +buildNumber (ej. 1.0.14+27 -> 1.0.14)
    String normalized = version.split('+').first.trim();
    // Quitar paréntesis y contenido (ej. 1.0.14 (27) -> 1.0.14)
    normalized = normalized.replaceAll(RegExp(r'\s*\([^)]*\)\s*'), '').trim();
    // Si queda solo dígitos (versionCode como "27"), no es versionName válido
    if (RegExp(r'^\d+$').hasMatch(normalized)) return '';
    return normalized;
  }

  /// Evita mostrar versiones "basura" que a veces devuelve Play/HTML
  /// (ej. capturas de chunks JS como 1.43.35).
  static String _sanitizeStoreVersionForDisplay(
    String version, {
    required String currentVersion,
  }) {
    final normalized = _normalizeVersionForDisplay(version);
    if (normalized.isEmpty) return '';

    // Solo aceptar formatos numéricos de versión habituales.
    if (!RegExp(r'^\d+(?:\.\d+){1,2}$').hasMatch(normalized)) return '';

    final parts = normalized.split('.').map(int.parse).toList();
    if (parts.length >= 2 && parts[1] > 20) return '';
    if (parts.length >= 3 && parts[2] > 200) return '';

    if (currentVersion.isNotEmpty &&
        RegExp(r'^\d+(?:\.\d+){1,2}$').hasMatch(currentVersion)) {
      final currentParts = currentVersion.split('.').map(int.parse).toList();
      final currentMajor = currentParts[0];
      final currentMinor = currentParts.length > 1 ? currentParts[1] : 0;
      final major = parts[0];
      final minor = parts.length > 1 ? parts[1] : 0;

      // Si mantiene major pero cambia demasiado el minor, suele ser ruido.
      if (major == currentMajor && (minor - currentMinor).abs() > 10) {
        return '';
      }
    }

    return normalized;
  }

  static String _buildUpdateMessage({
    required AppLocalizations l10n,
    required String currentVersion,
    String? newVersion,
  }) {
    // UX solicitado: mostrar solo la versión actual del usuario (sin versión nueva).
    if (currentVersion.isNotEmpty) {
      return l10n.updateMessageCurrentOnly(currentVersion);
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

        // Fallback robusto: softwareVersion en metadatos/JSON embebido.
        final softwareVersionPattern =
            RegExp(r'"softwareVersion"\s*:\s*"([^"]+)"');
        final softwareVersionMatch = softwareVersionPattern.firstMatch(html);
        if (softwareVersionMatch != null) {
          final version = softwareVersionMatch.group(1)?.trim();
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

  /// Public helper to open the app store page from other screens/dialogs.
  static Future<void> openStorePage() async {
    await _openStore();
  }
}
