import 'package:http/http.dart' as http;
import 'package:dpp/app/services/subservice/submodel/shell/submodel_service_exception.dart';

/// Utility class for making HTTP requests with common error handling.
class HttpUtil {
  static http.Client? _client;

  /// Initialize the HTTP client (should be called once at app startup).
  static void initialize({http.Client? client}) {
    _client = client ?? http.Client();
  }

  /// Get the current HTTP client instance.
  static http.Client get client {
    if (_client == null) {
      throw StateError(
        'HttpUtil not initialized. Call HttpUtil.initialize() first.',
      );
    }
    return _client!;
  }

  /// Common headers for all API requests.
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Makes an HTTP request and handles common error scenarios.
  static Future<String> makeHttpRequest(
    String method,
    String url,
    String errorContext, {
    String? body,
    List<int> successCodes = const [200],
  }) async {
    try {
      final uri = Uri.parse(url);
      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await client.get(uri, headers: headers);
          break;
        case 'POST':
          response = await client.post(uri, headers: headers, body: body);
          break;
        case 'PUT':
          response = await client.put(uri, headers: headers, body: body);
          break;
        case 'PATCH':
          response = await client.patch(uri, headers: headers, body: body);
          break;
        case 'DELETE':
          response = await client.delete(uri, headers: headers);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      if (successCodes.contains(response.statusCode)) {
        return response.body;
      } else {
        throw SubmodelServiceException(
          'Failed to $errorContext: ${response.statusCode} ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw SubmodelServiceException(
        'Exception during $errorContext: $e',
        statusCode: null,
      );
    }
  }

  /// Convenience method for GET requests.
  static Future<String> makeGetRequest(String url, String errorContext) =>
      makeHttpRequest('GET', url, errorContext);

  /// Convenience method for POST requests.
  static Future<String> makePostRequest(
    String url,
    String body,
    String errorContext,
  ) => makeHttpRequest(
    'POST',
    url,
    errorContext,
    body: body,
    successCodes: [200, 201],
  );

  /// Convenience method for PUT requests.
  static Future<String> makePutRequest(
    String url,
    String body,
    String errorContext,
  ) => makeHttpRequest(
    'PUT',
    url,
    errorContext,
    body: body,
    successCodes: [200, 204],
  );

  /// Disposes of the HTTP client.
  static void dispose() {
    _client?.close();
    _client = null;
  }
}
