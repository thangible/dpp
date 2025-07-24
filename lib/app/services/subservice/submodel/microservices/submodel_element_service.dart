import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class SubmodelElementService {
  SubmodelElementService();

  /// Returns all submodel elements including their hierarchy
  Future<List<Map<String, dynamic>>> getSubmodelElements(
    String submodelId,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final responseBody = await HttpUtil.makeGetRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements',
      'fetch submodel elements',
    );
    return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
  }

  /// Creates a new submodel element
  Future<Map<String, dynamic>> createSubmodelElement(
    String submodelId,
    Map<String, dynamic> elementData,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final responseBody = await HttpUtil.makePostRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements',
      jsonEncode(elementData),
      'create submodel element',
    );
    return jsonDecode(responseBody);
  }

  /// Returns a specific submodel element from the Submodel at a specified path
  Future<Map<String, dynamic>> getSubmodelElement(
    String submodelId,
    String idShortPath,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    final responseBody = await HttpUtil.makeGetRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath',
      'fetch submodel element',
    );
    return jsonDecode(responseBody);
  }

  /// Updates an existing submodel element at a specified path within submodel elements hierarchy
  Future<void> updateSubmodelElement(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> elementData,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    await HttpUtil.makePutRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath',
      jsonEncode(elementData),
      'update submodel element',
    );
  }

  /// Creates a new submodel element at a specified path within submodel elements hierarchy
  Future<Map<String, dynamic>> createSubmodelElementAtPath(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> elementData,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    final responseBody = await HttpUtil.makePostRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath',
      jsonEncode(elementData),
      'create submodel element at path',
    );
    return jsonDecode(responseBody);
  }

  /// Deletes a submodel element at a specified path within the submodel elements hierarchy
  Future<void> deleteSubmodelElement(
    String submodelId,
    String idShortPath,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    await HttpUtil.makeHttpRequest(
      'DELETE',
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath',
      'delete submodel element',
      successCodes: [200, 204],
    );
  }
}
