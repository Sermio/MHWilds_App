import 'package:flutter/material.dart';
import 'package:mhwilds_app/api/api_client.dart';
import 'package:mhwilds_app/l10n/gen_l10n/app_localizations.dart';
import 'package:mhwilds_app/utils/load_state.dart';

/// Pinta un [LoadState]: carga, error con "Reintentar", vacío o los datos.
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.state,
    required this.builder,
    required this.loadingLabel,
    required this.emptyTitle,
    this.emptySubtitle,
    this.onRetry,
    this.isEmpty,
  });

  final LoadState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final String loadingLabel;
  final String emptyTitle;
  final String? emptySubtitle;
  final VoidCallback? onRetry;

  /// Por defecto, una colección vacía. Permite contar los datos ya filtrados.
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      Idle() || Loading() => _Message(
          leading: const CircularProgressIndicator(),
          title: loadingLabel,
        ),
      Failure(:final error) => _Message(
          icon:
              error is NetworkException ? Icons.wifi_off : Icons.error_outline,
          title: error is NetworkException
              ? AppLocalizations.of(context)!.errorOffline
              : AppLocalizations.of(context)!.errorLoadingData,
          action: onRetry == null
              ? null
              : FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.retry),
                ),
        ),
      Data(:final value)
          when (isEmpty?.call(value) ?? (value is Iterable && value.isEmpty)) =>
        _Message(
          icon: Icons.search_off,
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      Data(:final value) => builder(context, value),
    };
  }
}

class _Message extends StatelessWidget {
  const _Message(
      {this.icon,
      this.leading,
      required this.title,
      this.subtitle,
      this.action});

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading ??
                Icon(icon,
                    size: 64, color: scheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
