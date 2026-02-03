import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_checker/flutter_update_checker.dart';
import 'package:mhwilds_app/utils/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
        storeVersion = await _checker.getStoreVersion();
      } catch (_) {}
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
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.system_update,
                color: Theme.of(ctx).colorScheme.primary, size: 28),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'New version available',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          _buildUpdateMessage(
              currentVersion: currentVersion, newVersion: storeVersion),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _openStore();
            },
            icon: const Icon(Icons.store, size: 20),
            label: const Text('Go to store'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.primary,
              foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  static String _buildUpdateMessage({
    required String currentVersion,
    String? newVersion,
  }) {
    final hasCurrent = currentVersion.isNotEmpty;
    final hasNew = newVersion != null && newVersion.isNotEmpty;
    if (hasCurrent && hasNew) {
      return 'You have version $currentVersion. '
          'A new version ($newVersion) is available in the store. '
          'Update to get the latest improvements and fixes.';
    }
    if (hasCurrent) {
      return 'You have version $currentVersion. '
          'A new version is available in the store. '
          'Update to get the latest improvements and fixes.';
    }
    if (hasNew) {
      return 'A new version ($newVersion) is available in the store. '
          'Update to get the latest improvements and fixes.';
    }
    return 'A new version is available in the store. '
        'Update to get the latest improvements and fixes.';
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
