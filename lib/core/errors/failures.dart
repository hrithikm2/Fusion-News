/// Custom failure classes for error handling
///
/// This file defines the failure types used throughout the application
/// to handle different kinds of errors in a type-safe manner.
abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  String toString() =>
      'Failure: $message${code != null ? ' (Code: $code)' : ''}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Permission-related failures
class PermissionFailure extends Failure {
  final bool isPermanentlyDenied;

  const PermissionFailure({
    required super.message,
    super.code,
    this.isPermanentlyDenied = false,
  });
}

/// Live streaming-related failures
class LiveStreamFailure extends Failure {
  const LiveStreamFailure({required super.message, super.code});
}

/// Generic unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code});
}
