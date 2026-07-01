import 'package:dio/dio.dart';
import '../preference_handler.dart';

Dio createDioClient({bool requireAuth = true}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://appabsensi.mobileprojp.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  if (requireAuth) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = PreferenceHandler.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
