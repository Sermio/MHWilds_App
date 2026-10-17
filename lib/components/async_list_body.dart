import 'package:flutter/material.dart';
import 'package:mhwilds_app/components/async_state_view.dart';
import 'package:mhwilds_app/components/card_skeleton_list.dart';
import 'package:mhwilds_app/components/offline_data_banner.dart';
import 'package:mhwilds_app/utils/load_state.dart';

/// Cuerpo común de las listas: aviso de datos sin conexión, estados de carga,
/// error y vacío, y pull-to-refresh. [builder] devuelve el scrollable, que debe
/// usar `AlwaysScrollableScrollPhysics` para que el gesto funcione con pocos datos.
class AsyncListBody<T> extends StatelessWidget {
  const AsyncListBody({
    super.key,
    required this.state,
    required this.isOffline,
    required this.onRetry,
    required this.onRefresh,
    required this.loadingLabel,
    required this.emptyTitle,
    this.emptySubtitle,
    this.isEmpty,
    required this.builder,
  });

  final LoadState<List<T>> state;
  final bool isOffline;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final String loadingLabel;
  final String emptyTitle;
  final String? emptySubtitle;
  final bool Function(List<T> data)? isEmpty;
  final Widget Function(BuildContext context, List<T> data) builder;

  @override
  Widget build(BuildContext context) {
    final current = state;
    return Column(
      children: [
        if (isOffline && current is Data<List<T>>)
          OfflineDataBanner(updatedAt: current.updatedAt!),
        Expanded(
          child: AsyncStateView<List<T>>(
            state: state,
            loadingLabel: loadingLabel,
            loadingSkeleton: CardSkeletonList(semanticLabel: loadingLabel),
            emptyTitle: emptyTitle,
            emptySubtitle: emptySubtitle,
            onRetry: onRetry,
            isEmpty: isEmpty,
            builder: (context, data) => RefreshIndicator(
              onRefresh: onRefresh,
              child: builder(context, data),
            ),
          ),
        ),
      ],
    );
  }
}
