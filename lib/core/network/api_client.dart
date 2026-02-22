import 'package:dio/dio.dart';

class ApiClient {
  // TVMaze — полностью бесплатный API, без регистрации и токенов
  static const _baseUrl = 'https://api.tvmaze.com';

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }

  Dio get dio => _dio;
}
