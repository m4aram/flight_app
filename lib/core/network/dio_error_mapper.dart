import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Turns a Dio error into one of our own exceptions,
/// so the rest of the app never sees Dio.
AppException mapDioException(DioException e) {
  if (_isConnectionProblem(e.type)) {
    return const ServerException(
      'Check your internet connection and try again.',
    );
  }

  return switch (e.response?.statusCode) {
    401 => const AuthException('Please log in again.'),
    403 => const AuthException('You are not allowed to do this.'),
    404 => const ServerException('We could not find what you asked for.'),
    429 => const ServerException('Too many requests. Please wait a moment.'),
    final code? when code >= 500 => const ServerException(),
    _ => const ServerException('Something went wrong. Please try again.'),
  };
}

/// No answer from the server at all (timeout or no internet).
bool _isConnectionProblem(DioExceptionType type) => switch (type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout ||
  DioExceptionType.connectionError => true,
  _ => false,
};