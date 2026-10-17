/// Estado de una carga asíncrona: lo que un provider expone a la UI.
sealed class LoadState<T> {
  const LoadState();
}

class Idle<T> extends LoadState<T> {
  const Idle();
}

class Loading<T> extends LoadState<T> {
  const Loading();
}

/// [stale]: datos de caché que aún no se han revalidado.
class Data<T> extends LoadState<T> {
  const Data(this.value, {this.stale = false, this.updatedAt});
  final T value;
  final bool stale;
  final DateTime? updatedAt;
}

class Failure<T> extends LoadState<T> {
  const Failure(this.error);
  final Object error;
}
