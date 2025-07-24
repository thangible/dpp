import 'dart:convert';
import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';
import 'package:dpp/config/utils/url_encoder.dart';

class ShellApiService {
  ShellApiService();

  /// Fetches all shells from the lookup service.
  Future<String> fetchLookupShells() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.lookupShells.url,
      'fetch lookup shells',
    );
  }

  /// Fetches all shell descriptors from the registry service.
  Future<String> fetchShellDescriptors() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.shellDescriptors.url,
      'fetch shell descriptors',
    );
  }

  /// Fetches all shells from the AAS service.
  Future<String> fetchShells() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.shells.url,
      'fetch shells',
    );
  }

  /// Fetches a specific shell by its ID from the AAS service.
  /// The shellId will be URL-safe Base64 encoded before the request using the imported utility.
  Future<String> fetchShell(String shellId) async {
    final encodedShellId = utf8Base64UrlEncode(shellId);
    return await HttpUtil.makeGetRequest(
      '${ApiEndpoint.shells.url}/$encodedShellId',
      'fetch shell',
    );
  }
}
