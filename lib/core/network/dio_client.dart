import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Creates the one Dio instance the whole app uses.
Dio createDio(SecureStorage storage) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(AuthInterceptor(storage));
}