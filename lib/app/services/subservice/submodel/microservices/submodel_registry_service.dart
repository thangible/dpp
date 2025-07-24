import 'package:dpp/app/services/http_util.dart';
import 'package:dpp/config/api/api_urls.dart';

class SubmodelRegistryService {
  SubmodelRegistryService();

  /// Fetches all submodel descriptors from the submodel registry.
  Future<String> fetchSubmodelDescriptors() async {
    return await HttpUtil.makeGetRequest(
      ApiEndpoint.submodelDescriptors.url,
      'fetch submodel descriptors',
    );
  }
}
