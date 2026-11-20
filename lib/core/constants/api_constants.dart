/// Settings for talking to the backend.
abstract final class ApiConstants {
  /// Changed on Day 11 when we choose the real backend.
  static const String baseUrl = 'https://api.example.com';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}