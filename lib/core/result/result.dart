sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? getOrNull() {
    return switch (this) {
      Success<T>(value: final v) => v,
      Failure<T>() => null,
    };
  }

  Object? get errorOrNull {
    return switch (this) {
      Success<T>() => null,
      Failure<T>(error: final e) => e,
    };
  }

  T getOrElse(T Function() defaultValue) {
    return switch (this) {
      Success<T>(value: final v) => v,
      Failure<T>() => defaultValue(),
    };
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(value: final v) => Result.success(transform(v)),
      Failure<T>(error: final e, stackTrace: final st) => Result.failure(e, st),
    };
  }

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Object error, [StackTrace? stackTrace]) = Failure<T>;
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  String toString() => 'Result.success($value)';
}

final class Failure<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Failure(this.error, [this.stackTrace]);

  @override
  String toString() => 'Result.failure($error)';
}
