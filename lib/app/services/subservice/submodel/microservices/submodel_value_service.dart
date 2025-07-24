import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class SubmodelValueService {
  SubmodelValueService();

  /// Returns a specific Submodel in the ValueOnly representation
  Future<Map<String, dynamic>> getSubmodelValue(String submodelId) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final responseBody = await HttpUtil.makeGetRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/\$value',
      'fetch submodel value',
    );
    return jsonDecode(responseBody);
  }

  /// Updates the values of an existing Submodel
  Future<void> updateSubmodelValue(
    String submodelId,
    Map<String, dynamic> values,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    await HttpUtil.makeHttpRequest(
      'PATCH',
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/\$value',
      'update submodel value',
      body: jsonEncode(values),
      successCodes: [200, 204],
    );
  }

  /// Returns a specific submodel element from the Submodel at a specified path in the ValueOnly representation
  Future<dynamic> getSubmodelElementValue(
    String submodelId,
    String idShortPath,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    final responseBody = await HttpUtil.makeGetRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath/\$value',
      'fetch submodel element value',
    );
    return jsonDecode(responseBody);
  }

  /// Updates the value of an existing SubmodelElement
  Future<void> updateSubmodelElementValue(
    String submodelId,
    String idShortPath,
    dynamic value,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    await HttpUtil.makeHttpRequest(
      'PATCH',
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath/\$value',
      'update submodel element value',
      body: jsonEncode(value),
      successCodes: [200, 204],
    );
  }
}
