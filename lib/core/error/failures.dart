import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable {
  final String message;
  final Object? cause;

  const AppFailure(this.message, [this.cause]);

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message, [super.cause]);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [super.cause]);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message, [super.cause]);
}

class AudioFailure extends AppFailure {
  const AudioFailure(super.message, [super.cause]);
}

class StorageFailure extends AppFailure {
  const StorageFailure(super.message, [super.cause]);
}
