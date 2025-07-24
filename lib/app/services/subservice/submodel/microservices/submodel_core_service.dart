import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/app/data/submodel.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';
import 'package:dpp/app/services/subservice/submodel/shell/submodel_result.dart';
import 'package:dpp/app/services/subservice/submodel/shell/submodel_parser.dart';

class SubmodelCoreService {
  final SubmodelParser _parser;

  SubmodelCoreService({required SubmodelParser parser}) : _parser = parser;


  /// Fetches all submodels from the AAS service.
  Future<String> fetchSubmodels() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.submodels.url,
      'fetch submodels',
    );
  }

  /// Fetches a submodel by its ID from the AAS service with optional query parameters.
  Future<Submodel> getSubmodel(
    String submodelId, {
    String? level,
    String? extent,
  }) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final Map<String, String> queryParams = {};
    if (level != null) queryParams['level'] = level;
    if (extent != null) queryParams['extent'] = extent;

    Uri uri = Uri.parse('${ApiEndpoint.submodels.url}/$encodedSubmodelId');
    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final responseBody = await HttpUtil.makeGetRequest(
      uri.toString(),
      'fetch submodel',
    );
    return _parser.parseSubmodel(responseBody);
  }

  /// Returns all Submodels
  Future<List<Submodel>> getAllSubmodels() async {
    final responseBody = await HttpUtil.makeGetRequest(
      ApiEndpoint.submodels.url,
      'fetch all submodels',
    );
    return _parser.parseSubmodels(responseBody);
  }

  /// Creates a new Submodel
  Future<Submodel> createSubmodel(Map<String, dynamic> submodelData) async {
    final responseBody = await HttpUtil.makePostRequest(
      ApiEndpoint.submodels.url,
      jsonEncode(submodelData),
      'create submodel',
    );
    return _parser.parseSubmodel(responseBody);
  }

  /// Updates an existing Submodel
  Future<void> updateSubmodel(
    String submodelId,
    Map<String, dynamic> submodelData,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    await HttpUtil.makePutRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId',
      jsonEncode(submodelData),
      'update submodel',
    );
  }

  /// Deletes a Submodel
  Future<void> deleteSubmodel(String submodelId) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    await HttpUtil.makeHttpRequest(
      'DELETE',
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId',
      'delete submodel',
      successCodes: [200, 204],
    );
  }

  /// Fetches multiple submodels by their IDs.
  Future<List<Submodel>> getSubmodels(List<String> submodelIds) async {
    final List<Submodel> submodels = [];
    for (final id in submodelIds) {
      try {
        final submodel = await getSubmodel(id);
        submodels.add(submodel);
      } catch (e) {
        print('Failed to fetch submodel $id: $e');
      }
    }
    return submodels;
  }

  /// Fetches multiple submodels and returns results with error handling.
  Future<List<SubmodelResult>> getSubmodelResults(
    List<String> submodelIds,
  ) async {
    final List<SubmodelResult> results = [];
    for (final id in submodelIds) {
      try {
        final submodel = await getSubmodel(id);
        results.add(SubmodelResult.success(submodel));
      } catch (e) {
        results.add(SubmodelResult.error(id, e.toString()));
      }
    }
    return results;
  }
}
