import 'dart:developer' as developer;

abstract interface class AppLogger {
  void debug(String tag, String message);
  void info(String tag, String message);
  void warning(String tag, String message, [Object? error, StackTrace? stackTrace]);
  void error(String tag, String message, [Object? error, StackTrace? stackTrace]);
}

class DeveloperAppLogger implements AppLogger {
  const DeveloperAppLogger();

  @override
  void debug(String tag, String message) {
    developer.log(message, name: tag, level: 500);
  }

  @override
  void info(String tag, String message) {
    developer.log(message, name: tag, level: 800);
  }

  @override
  void warning(String tag, String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: tag,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(String tag, String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
