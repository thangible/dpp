import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dpp/app/data/submodel.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

/// Service class for handling Submodel and Shell API operations.
class SubmodelService {
  /// HTTP client for making requests.
  final http.Client _client;

  /// Constructor for SubmodelService.
  /// Accepts an optional HTTP client for dependency injection (useful for testing).
  SubmodelService({http.Client? client}) : _client = client ?? http.Client();

  /// Common headers for all API requests.
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Makes a GET request and handles common error scenarios.
  ///
  /// [url] - The complete URL to call.
  /// [errorContext] - Context string for error messages.
  ///
  /// Returns the response body if successful.
  /// Throws [SubmodelServiceException] for any errors.
  Future<String> _makeGetRequest(String url, String errorContext) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw SubmodelServiceException(
          'Failed to $errorContext: ${response.statusCode} ${response.reasonPhrase}',
          statusCode: response.statusCode,
        );
      }
    } on SubmodelServiceException {
      rethrow;
    } on FormatException catch (e) {
      throw SubmodelServiceException(
        'Invalid JSON format while $errorContext: ${e.message}',
        originalException: e,
      );
    } on TypeError catch (e) {
      throw SubmodelServiceException(
        'Invalid data structure while $errorContext: ${e.toString()}',
        originalException: e,
      );
    } catch (e) {
      throw SubmodelServiceException(
        'Unexpected error while $errorContext: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Fetches all shells from the lookup service.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchLookupShells() async {
    return await _makeGetRequest(
      ApiEndpoint.lookupShells.url,
      'fetch lookup shells',
    );
  }

  /// Fetches all shell descriptors from the registry service.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchShellDescriptors() async {
    return await _makeGetRequest(
      ApiEndpoint.shellDescriptors.url,
      'fetch shell descriptors',
    );
  }

  /// Fetches all submodel descriptors from the submodel registry.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchSubmodelDescriptors() async {
    return await _makeGetRequest(
      ApiEndpoint.submodelDescriptors.url,
      'fetch submodel descriptors',
    );
  }

  /// Fetches all shells from the AAS service.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchShells() async {
    return await _makeGetRequest(ApiEndpoint.shells.url, 'fetch shells');
  }

  /// Fetches all submodels from the AAS service.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchSubmodels() async {
    return await _makeGetRequest(ApiEndpoint.submodels.url, 'fetch submodels');
  }

  /// Fetches all concept descriptions from the AAS service.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchConceptDescriptions() async {
    return await _makeGetRequest(
      ApiEndpoint.conceptDescriptions.url,
      'fetch concept descriptions',
    );
  }

  /// Fetches a specific shell by its ID from the AAS service.
  /// The shellId will be URL-safe Base64 encoded before the request.
  ///
  /// [shellId] - The ID of the shell to fetch.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchShell(String shellId) async {
    final encodedShellId = utf8Base64UrlEncode(shellId);
    return await _makeGetRequest(
      '${ApiEndpoint.shells.url}/$encodedShellId',
      'fetch shell',
    );
  }

  /// Fetches a submodel by its ID from the AAS service with optional query parameters.
  /// The submodelId will be URL-safe Base64 encoded before the request.
  ///
  /// [submodelId] - The ID of the submodel to fetch.
  /// [level] - Optional. Determines the structural depth of the respective resource content ('deep' or 'core').
  /// [extent] - Optional. Determines to which extent the resource is being serialized ('withBlobValue' or 'withoutBlobValue').
  ///
  /// Returns a [Submodel] object if successful.
  /// Throws [SubmodelServiceException] if the request fails or data is invalid.
  Future<Submodel> getSubmodel(
    String submodelId, {
    String? level,
    String? extent,
  }) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final Map<String, String> queryParams = {};
    if (level != null) {
      queryParams['level'] = level;
    }
    if (extent != null) {
      queryParams['extent'] = extent;
    }

    Uri uri = Uri.parse('${ApiEndpoint.submodels.url}/$encodedSubmodelId');
    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final responseBody = await _makeGetRequest(
      uri.toString(),
      'fetch submodel',
    );
    return parseSubmodel(responseBody);
  }

  /// Fetches a specific concept description by its ID from the AAS service.
  /// The conceptDescriptionId will be URL-safe Base64 encoded before the request.
  ///
  /// [conceptDescriptionId] - The ID of the concept description to fetch.
  ///
  /// Returns the raw response body as a string.
  /// Throws [SubmodelServiceException] if the request fails.
  Future<String> fetchConceptDescription(String conceptDescriptionId) async {
    final encodedConceptDescriptionId = utf8Base64UrlEncode(
      conceptDescriptionId,
    );
    return await _makeGetRequest(
      '${ApiEndpoint.conceptDescriptions.url}/$encodedConceptDescriptionId',
      'fetch concept description',
    );
  }

  /// Fetches multiple submodels by their IDs.
  ///
  /// [submodelIds] - List of submodel IDs to fetch.
  ///
  /// Returns a list of [Submodel] objects.
  /// Note: This method will continue fetching even if some requests fail.
  /// Use [getSubmodelResults] if you need to handle individual failures.
  Future<List<Submodel>> getSubmodels(List<String> submodelIds) async {
    final List<Submodel> submodels = [];

    for (final id in submodelIds) {
      try {
        // Calls the enhanced getSubmodel without optional parameters for simplicity here.
        // The ID encoding is handled by the getSubmodel method itself.
        final submodel = await getSubmodel(id);
        submodels.add(submodel);
      } catch (e) {
        // Log the error but continue with other submodels
        print('Failed to fetch submodel $id: $e');
      }
    }

    return submodels;
  }

  /// Fetches multiple submodels and returns results with error handling.
  ///
  /// [submodelIds] - List of submodel IDs to fetch.
  ///
  /// Returns a list of [SubmodelResult] objects containing either success or error.
  Future<List<SubmodelResult>> getSubmodelResults(
    List<String> submodelIds,
  ) async {
    final List<SubmodelResult> results = [];

    for (final id in submodelIds) {
      try {
        // Calls the enhanced getSubmodel without optional parameters for simplicity here.
        // The ID encoding is handled by the getSubmodel method itself.
        final submodel = await getSubmodel(id);
        results.add(SubmodelResult.success(submodel));
      } catch (e) {
        results.add(SubmodelResult.error(id, e.toString()));
      }
    }

    return results;
  }

  /// Parses a JSON string containing multiple submodels.
  ///
  /// [jsonString] - The JSON string to parse.
  ///
  /// Returns a list of [Submodel] objects.
  /// Throws [SubmodelServiceException] if parsing fails.
  List<Submodel> parseSubmodels(String jsonString) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Submodel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      throw SubmodelServiceException(
        'Invalid JSON format while parsing submodels: ${e.message}',
        originalException: e,
      );
    } on TypeError catch (e) {
      throw SubmodelServiceException(
        'Invalid data structure while parsing submodels: ${e.toString()}',
        originalException: e,
      );
    } catch (e) {
      throw SubmodelServiceException(
        'Unexpected error while parsing submodels: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Fetches and parses all submodels from the AAS service.
  ///
  /// Returns a list of [Submodel] objects.
  /// Throws [SubmodelServiceException] if the request or parsing fails.
  Future<List<Submodel>> getAllSubmodels() async {
    final responseBody = await fetchSubmodels();
    return parseSubmodels(responseBody);
  }

  /// Disposes of the HTTP client.
  void dispose() {
    _client.close();
  }
}

/// Custom exception for Submodel service errors.
class SubmodelServiceException implements Exception {
  /// The error message.
  final String message;

  /// The HTTP status code if applicable.
  final int? statusCode;

  /// The original exception that caused this error.
  final dynamic originalException;

  /// Constructor for SubmodelServiceException.
  SubmodelServiceException(
    this.message, {
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() {
    return 'SubmodelServiceException: $message';
  }
}

/// Result wrapper for submodel fetch operations.
class SubmodelResult {
  /// The submodel data if successful.
  final Submodel? submodel;

  /// The submodel ID that was requested.
  final String submodelId;

  /// Error message if the operation failed.
  final String? error;

  /// Whether the operation was successful.
  final bool isSuccess;

  /// Private constructor for SubmodelResult.
  SubmodelResult._({
    required this.submodelId,
    this.submodel,
    this.error,
    required this.isSuccess,
  });

  /// Factory constructor for successful result.
  factory SubmodelResult.success(Submodel submodel) {
    return SubmodelResult._(
      submodelId: submodel.id,
      submodel: submodel,
      isSuccess: true,
    );
  }

  /// Factory constructor for error result.
  factory SubmodelResult.error(String submodelId, String error) {
    return SubmodelResult._(
      submodelId: submodelId,
      error: error,
      isSuccess: false,
    );
  }
}
