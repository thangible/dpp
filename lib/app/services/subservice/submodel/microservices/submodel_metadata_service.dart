import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class SubmodelMetadataService {
  SubmodelMetadataService();

  /// Returns the metadata attributes of a specific Submodel
  Future<Map<String, dynamic>> getSubmodelMetadata(String submodelId) async {
    final encodedSubmodelId = utf8Base64UrlEncode(submodelId);
    final responseBody = await HttpUtil.makeGetRequest(
      '${ApiEndpoint.submodels.url}/$encodedSubmodelId/\$metadata',
      'fetch submodel metadata',
    );
    return jsonDecode(responseBody);
  }
}
