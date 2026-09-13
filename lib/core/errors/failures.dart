/// Base exception class for Alinea
abstract class AppException implements Exception {
  final String message;
  final dynamic details;

  const AppException(this.message, [this.details]);

  @override
  String toString() => '$runtimeType: $message${details != null ? ' (Details: $details)' : ''}';
}

/// Exceptions related to EPUB parsing and extraction
class EpubParseException extends AppException {
  const EpubParseException(super.message, [super.details]);
}

/// Exceptions related to database operations
class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.details]);
}

/// Exceptions related to translation providers and network gateway
class TranslationException extends AppException {
  final int? statusCode;
  final bool isRetryable;

  const TranslationException(
    String message, {
    this.statusCode,
    this.isRetryable = false,
    dynamic details,
  }) : super(message, details);
}

/// Base Failure class for functional error handling
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class EpubFailure extends Failure {
  const EpubFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class TranslationFailure extends Failure {
  final int? statusCode;
  final bool isRetryable;

  const TranslationFailure(
    super.message, {
    this.statusCode,
    this.isRetryable = false,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
