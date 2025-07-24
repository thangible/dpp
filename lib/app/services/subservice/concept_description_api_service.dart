import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class ConceptDescriptionApiService {
  ConceptDescriptionApiService();

  /// Fetches all concept descriptions from the AAS service.
  Future<String> fetchConceptDescriptions() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.conceptDescriptions.url,
      'fetch concept descriptions',
    );
  }

  /// Fetches a specific concept description by its ID from the AAS service.
  /// The conceptDescriptionId will be URL-safe Base64 encoded before the request using the imported utility.
  Future<String> fetchConceptDescription(String conceptDescriptionId) async {
    final encodedConceptDescriptionId = utf8Base64UrlEncode(
      conceptDescriptionId,
    );
    return await HttpUtil.makeGetRequest(
      '${ApiEndpoint.conceptDescriptions.url}/$encodedConceptDescriptionId',
      'fetch concept description',
    );
  }
}
