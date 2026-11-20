import 'package:dio/dio.dart';
import 'package:flight_app/core/error/exceptions.dart';
import 'package:flight_app/core/network/dio_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

/// A fake Dio error, as if the server answered with [code].
DioException errorWithStatus(int code) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: code),
  );
}

void main() {
  group('mapDioException', () {
    test('turns 401 into AuthException', () {
      final result = mapDioException(errorWithStatus(401));

      expect(result, isA<AuthException>());
    });

    test('turns 500 into ServerException', () {
      final result = mapDioException(errorWithStatus(500));

      expect(result, isA<ServerException>());
    });

    test('turns 503 into ServerException', () {
      final result = mapDioException(errorWithStatus(503));

      expect(result, isA<ServerException>());
    });
    test('asks to check the internet on timeout', () {
      // Arrange: the server never answered
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      final result = mapDioException(error);

      // Assert
      expect(result, isA<ServerException>());
      expect(result.message, 'Check your internet connection and try again.');
    });
  });
}
