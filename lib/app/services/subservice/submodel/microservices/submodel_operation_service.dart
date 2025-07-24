import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class SubmodelOperationService {
  SubmodelOperationService();

  /// Synchronously or asynchronously invokes an Operation at a specified path
  Future<Map<String, dynamic>> invokeOperation(
    String submodelId,
    String idShortPath,
    Map<String, dynamic> operationRequest,
  ) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final encodedIdShortPath = utf8Base64UrlEncode(idShortPath);
    final responseBody = await HttpUtil.makePostRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/submodel-elements/$encodedIdShortPath/invoke',
      jsonEncode(operationRequest),
      'invoke operation',
    );
    return jsonDecode(responseBody);
  }
}
