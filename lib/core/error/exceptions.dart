/// Exceptions are thrown by the data layer and converted to [Failure]s
/// inside repositories, so they never reach the presentation layer.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error, please try again.']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Could not access local storage.']);
}

final class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);
}
