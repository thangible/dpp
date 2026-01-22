import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dpp/config/api/api_urls.dart';

class DioFactory {
  static final Map<String, Dio> _instances = {};

  static Dio _createDioInstance(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) {
          if (kDebugMode) {
            debugPrint("API URL => ${options.uri}");
            debugPrint("API HEADERS => ${_sanitizeHeaders(options.headers)}");
            debugPrint("API BODY => ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (Response response, handler) {
          if (kDebugMode) {
            debugPrint("RESPONSE STATUS => ${response.statusCode}");
            debugPrint("RESPONSE DATA => ${response.data}");
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint(
              "ERROR STATUS => ${error.response?.statusCode ?? "No status"}",
            );
            debugPrint("ERROR MESSAGE => ${error.message}");
            debugPrint("ERROR DATA => ${error.response?.data ?? "No data"}");
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  static Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    sanitized.removeWhere(
      (key, value) =>
          key.toLowerCase().contains('authorization') ||
          key.toLowerCase().contains('token') ||
          key.toLowerCase().contains('key'),
    );
    return sanitized;
  }

  // Getters for each service
  static Dio get lookupService {
    return _instances[ApiURLs.lookupServiceBaseUrl8084] ??= _createDioInstance(
      ApiURLs.lookupServiceBaseUrl8084,
    );
  }

  static Dio get registryService {
    return _instances[ApiURLs.registryServiceBaseUrl8082] ??=
        _createDioInstance(ApiURLs.registryServiceBaseUrl8082);
  }

  static Dio get submodelRegistry {
    return _instances[ApiURLs.submodelRegistryBaseUrl8083] ??=
        _createDioInstance(ApiURLs.submodelRegistryBaseUrl8083);
  }

  static Dio get aasService {
    return _instances[ApiURLs.aasServiceBaseUrl8081] ??= _createDioInstance(
      ApiURLs.aasServiceBaseUrl8081,
    );
  }
}

// Usage:
// final lookupDio = DioFactory.lookupService;
// final registryDio = DioFactory.registryService;
