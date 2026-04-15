import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;

  static const String _keyUniqueDays = 'review_unique_days_v1';
  static const String _keyLastOpenDate = 'review_last_open_date_v1';
  static const String _keyHasReviewedOrRejected = 'review_has_reviewed_rejected_v1';

  /// Increments unique day count if it's a new day.
  /// Should be called during app initialization (e.g. in HomeScreen initState).
  static Future<void> trackOpening() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final lastOpenDate = prefs.getString(_keyLastOpenDate);

    if (today != lastOpenDate) {
      int count = prefs.getInt(_keyUniqueDays) ?? 0;
      await prefs.setInt(_keyUniqueDays, count + 1);
      await prefs.setString(_keyLastOpenDate, today);
    }
  }

  /// Checks conditions and shows the pre-review dialog if applicable.
  /// Triggers on the 3rd unique day of usage.
  static Future<void> checkAndShowReview(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasReviewedOrRejected = prefs.getBool(_keyHasReviewedOrRejected) ?? false;
    
    if (hasReviewedOrRejected) return;

    final uniqueDays = prefs.getInt(_keyUniqueDays) ?? 0;

    // Trigger exactly after 3 unique days of usage
    if (uniqueDays >= 3) {
      if (!context.mounted) return;
      await _showPreReviewDialog(context);
    }
  }

  /// Manual rate option for Settings.
  /// Sets the flag to prevent automatic popups in the future.
  static Future<void> openStore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasReviewedOrRejected, true);
    await _inAppReview.openStoreListing();
  }

  static Future<void> _showPreReviewDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.rateAppTitle, 
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        content: Text(l10n.rateAppMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(_keyHasReviewedOrRejected, true);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(
              l10n.rateAppNo, 
              style: TextStyle(color: colorScheme.secondary)
            ),
          ),
          FilledButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(_keyHasReviewedOrRejected, true);
              if (ctx.mounted) Navigator.pop(ctx);
              
              if (await _inAppReview.isAvailable()) {
                await _inAppReview.requestReview();
              } else {
                await _inAppReview.openStoreListing();
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: Text(l10n.rateAppYes),
          ),
        ],
      ),
    );
  }
}
