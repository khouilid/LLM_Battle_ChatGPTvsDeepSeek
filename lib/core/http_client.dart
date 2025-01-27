import 'package:dio/dio.dart';

class HttpClient {
  final String baseUrl;
  final String apiKey;

  late final Dio _dio;

  HttpClient({required this.baseUrl, required this.apiKey}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        validateStatus: (status) => status! < 500,
      ),
    );
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  // dio getter
  Dio get ref => _dio;




  Exception handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        final response = e.response;
        if (response != null) {
          return Exception(
            'Server error: ${response.statusCode} - ${response.statusMessage}\n'
            'Response: ${response.data}',
          );
        }
        return Exception('Bad response');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
